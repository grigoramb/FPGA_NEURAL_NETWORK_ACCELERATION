`define SDRAM_BASE 32'h0
`define IDLE 0      
`define LDR 1      	// Load Kernel
`define BRAM_DONE 2  // Done Loading Kernel
`define INITPIX 3		// Load sample into pixel reg (360 bits)
`define CALCPIX 4		// Calculate one output node
`define SIGMOID 5		// Apply sigmoid to current node, result is 1 bit.
`define SAVEPIX 6		// Shift the 1 bit sigmoid result into result register. If register is full, go to WRITEPIX 
`define WRITEPIX 7	// Write 16 one bit results
`define SAMPLEDONE 8 // Done with one sample
`define DONE 9			// Done with 100 samples
`define KERNEL_SIZE 32'd36180
`define SAMPLE_ADDR 32'hA000
`define RESULT_ADDR 32'hE000
`define WORDS_PER_SAMPLE1 23   // 360 pixels / 16 bit words = 22.5 
`define BITS_PER_SAMPLE1 360	


module layer1 (
input clk,
input reset_n,
input waitrequest,
input readdatavalid,
input [15:0] readdata,
output reg read_n = 1'b1,
output reg write_n = 1'b1,
output reg chipselect = 1'b1,
output reg [31:0] address = `SDRAM_BASE,
output reg [1:0] byteenable = 2'b11,
output [15:0] writedata,
// control signals
input ready,
output [6:0] done,
// debugging
output reg [3:0] state = 4'h0,
//input man_rst_n
// BRAM STUFF
output [16:0]s1_adr,
output [16:0] s2_adr,
output [7:0] s1_d,
output [7:0] s2_d,
input [7:0] s1_q,
input [7:0] s2_q,
output s1_cs,
output s2_cs,
output s1_w,
output s2_w
);

assign done = numsamples;//(state == `DONE);
//wire rst;
//assign rst = ~man_rst_n | ~reset_n;


reg [359:0] calc_pix;
reg [15:0] accumulator;	//round to 1 bit num(sigmoid) and then put back into SDRAM
reg [15:0] layer1_res;	//store 1 bit sigmoid values into a 16 bit final reg to store back into SDRAM
reg bram_wait;
reg [8:0] shifted;
reg [7:0] nodecount;

reg	[16:0]  address_a = 0;
reg	[16:0]  address_b = 1;
wire	[7:0]  data_a;
wire	[7:0]  data_b;
wire	  rden_a;
wire	  rden_b;
wire	  wren_a;
wire	  wren_b;
wire	[7:0]  q_a; // output from W0 - port 1
wire	[7:0]  q_b; // output from W0 - port 2

assign s1_adr = address_a;
assign s2_adr = address_b;
assign s1_d = data_a;
assign s2_d = data_b;
assign q_a = s1_q ;
assign q_b = s2_q;
assign s1_cs = rden_a;
assign s2_cs = rden_b;
assign s1_w = wren_a;
assign s2_w = wren_b;


reg [16:0] loaded = 0;
reg [16:0] adrsent = 0;
reg [6:0] numsamples = 0;

reg [31:0] rdaddr = `SDRAM_BASE;
reg [31:0] wraddr = `SDRAM_BASE + `RESULT_ADDR; //h20000 = 512 rows * 256 reads (2 pixels per read)
reg [15:0] readdatareg;

assign writedata = layer1_res;
//switched data_a and data_b
assign {data_b,data_a} = readdatareg;
assign rden_a = 1;//(state == `WRITE);
assign rden_b = 1;//(state == `WRITE);
assign wren_a = (state == `LDR);// && readdatavalid);
assign wren_b = (state == `LDR);// && readdatavalid);

// state logic for reading and writing
always @(posedge clk) begin
	if(~reset_n) begin
		state <= `IDLE;
		loaded <= 0;
		rdaddr <= 0;
		wraddr <= `RESULT_ADDR;
		adrsent <= 0;
		address_a <= 0;
		address_b <= 1;
		readdatareg <= 16'hF00D;
		calc_pix <= 0;
		accumulator <= 0;
		layer1_res <= 0;
		bram_wait <= 0;
		shifted <= 0;
		nodecount<= 0;
		numsamples <= 0;
	end
	else begin
		case(state)
			`IDLE: begin
					state <= ready ? `LDR : `IDLE;	//will need two ready signals, for weights and pixels
					loaded <= 0;
					rdaddr <= 0;
					wraddr <= `RESULT_ADDR;
					adrsent <= 0;
					address_a <= 0;
					address_b <= 1;
					readdatareg <= 16'hBEEF;
					calc_pix <= 0;
					accumulator <= 0;
					layer1_res <= 0;
					bram_wait <= 0;
					shifted <= 0;
					nodecount<= 0;
					numsamples <= 0;
			end
			`LDR: begin
					// Change to write the value of "Writes" to memory and see if its byte addressable or word addressable
					loaded <= readdatavalid ? loaded + 1 : loaded;
					state <= (loaded == `KERNEL_SIZE) ? `BRAM_DONE : `LDR;
					address_a <= loaded*2;
					address_b <= loaded*2 + 1;					
					rdaddr <= (~waitrequest && adrsent < `KERNEL_SIZE) ? rdaddr + 1 : rdaddr;
					wraddr <= wraddr;
					adrsent <= (~waitrequest && adrsent < `KERNEL_SIZE) ? adrsent + 1: adrsent;
					readdatareg <= readdatavalid ? readdata : readdatareg;
					calc_pix <= 0;
					accumulator <= 0;
					layer1_res <= 0;
					bram_wait <= 0;
					shifted <= 0;
					nodecount<= 0;
					numsamples <= 0;
			end
			`BRAM_DONE: begin
					state <= `INITPIX;
					loaded <= 0;
					rdaddr <= `SAMPLE_ADDR;
					wraddr <= `RESULT_ADDR;
					adrsent <= 0;
					address_a <= 0;
					address_b <= 1;
					readdatareg <= 16'hDEAF;
					calc_pix <= 0;
					accumulator <= 0;
					layer1_res <= 0;
					bram_wait <= 0;
					shifted <= 0;
					nodecount<= 0;
					numsamples <= 0;
			end
			`INITPIX: begin
					// First load loads in the bias into the accumulator
					// Change to write the value of "Writes" to memory and see if its byte addressable or word addressable
					loaded <= readdatavalid ? loaded + 1 : loaded;
					state <= (loaded == `WORDS_PER_SAMPLE1) ? `CALCPIX : `INITPIX;  // subtracted 1 because it was skipping 1 extra word
					address_a <= loaded < 20 ? 0 : 1;
					address_b <= 2;					
					rdaddr <= (~waitrequest && adrsent < `WORDS_PER_SAMPLE1) ? rdaddr + 1 : rdaddr;
					wraddr <= wraddr;
					adrsent <= (~waitrequest && adrsent < `WORDS_PER_SAMPLE1) ? adrsent + 1: adrsent;
					readdatareg <= 0;
					calc_pix <= ~readdatavalid? calc_pix : loaded == `WORDS_PER_SAMPLE1-1 ? {readdata[7:0], calc_pix[`BITS_PER_SAMPLE1-1:8]} : {readdata, calc_pix[`BITS_PER_SAMPLE1-1:16]};
					accumulator <= loaded < 20 ? {{8{q_a[7]}}, q_a} : accumulator;
					layer1_res <= 0;
					bram_wait <= 0;
					shifted <= 0;
					nodecount<= 0;
					numsamples <= numsamples;
			end
			`CALCPIX: begin		//per node for layer 2
					loaded <= 0;
					state <= (shifted == `BITS_PER_SAMPLE1-1) ? `SIGMOID : `CALCPIX;
					address_a <= ~bram_wait ? address_a + 2 : address_a;
					address_b <= bram_wait ? address_b + 2 : address_b;					
					rdaddr <= rdaddr;
					wraddr <= wraddr;
					adrsent <= 0;
					readdatareg <= 0;
					calc_pix <= {calc_pix[0],calc_pix[`BITS_PER_SAMPLE1-1:1]};
					accumulator <= ~calc_pix[0] ? accumulator : bram_wait ? accumulator + {{8{q_b[7]}}, q_b} : accumulator + {{8{q_a[7]}}, q_a};
					//q_a and q_b are the weights
					layer1_res <= layer1_res;
					bram_wait <= ~bram_wait;
					shifted <= shifted + 1;
					nodecount<= nodecount;
					numsamples <= numsamples;
			
			end	
			
			`SIGMOID: begin
					loaded <= 0;
					state <= (nodecount == 199) ? `WRITEPIX : `SAVEPIX;	//check if 200 nodes are done, if the num of results is divisible by 16, go to writepix state
					address_a <= address_a + 1;
					address_b <= address_b + 1;				
					rdaddr <= rdaddr;
					wraddr <= wraddr;
					adrsent <= adrsent;
					readdatareg <= 0;
					calc_pix <= calc_pix;
					accumulator <= {{8{q_a[7]}}, q_a};
					//q_a and q_b are the weights
					// For 200th node, the result will be in the upper 8 bits of layer1_res
					layer1_res <= (nodecount != 199) ? {~accumulator[15], layer1_res[15:1]} : {8'b0,~accumulator[15], layer1_res[15:9]};
					bram_wait <= bram_wait;
					shifted <= 0;
					nodecount<= nodecount + 1;
					numsamples <= numsamples;
			end
			
			`SAVEPIX: begin
					// state to add a delay for BRAM address
					loaded <= loaded;
					state <= (nodecount % 16) ? `CALCPIX : `WRITEPIX;	//check if 200 nodes are done, if the num of results is divisible by 16, go to writepix state
					address_a <= address_a;
					address_b <= address_b;				
					rdaddr <= rdaddr;
					wraddr <= wraddr;
					adrsent <= adrsent;
					readdatareg <= 0;
					calc_pix <= calc_pix;
					accumulator <= accumulator;
					//q_a and q_b are the weights
					layer1_res <= layer1_res;
					bram_wait <= bram_wait;
					shifted <= shifted;
					nodecount<= nodecount;
					numsamples <= numsamples;
			end
			
			`WRITEPIX: begin
					loaded <= loaded;
					state <= waitrequest ? `WRITEPIX: (nodecount == 200) ? `SAMPLEDONE : `CALCPIX;
					address_a <= address_a;
					address_b <= address_b;
					rdaddr <= rdaddr;
					wraddr <= ~waitrequest? wraddr + 1 : wraddr;
					adrsent <= adrsent;
					readdatareg <= 16'hDEAD;
					calc_pix <= calc_pix;
					accumulator <= accumulator;
					layer1_res <= layer1_res;
					bram_wait <= bram_wait;
					shifted <= shifted;
					nodecount<= nodecount;
					numsamples <= numsamples;
			end
			
			`SAMPLEDONE: begin
					loaded <= loaded;
					state <= (numsamples == 99) ? `DONE : `INITPIX;
					address_a <= address_a;
					address_b <= address_b;
					rdaddr <= rdaddr;
					wraddr <= wraddr;
					adrsent <= adrsent;
					readdatareg <= readdatareg;
					calc_pix <= calc_pix;
					accumulator <= accumulator;
					layer1_res <= layer1_res;
					bram_wait <= bram_wait;
					shifted <= shifted;
					nodecount<= nodecount;
					numsamples <= numsamples + 1;
			end
			
			`DONE: begin
					loaded <= loaded;
					state <= ~ready ? `IDLE: `DONE;
					address_a <= address_a;
					address_b <= address_b;
					rdaddr <= rdaddr;
					wraddr <= wraddr;
					adrsent <= adrsent;
					readdatareg <= readdatareg;
					calc_pix <= calc_pix;
					accumulator <= accumulator;
					layer1_res <= layer1_res;
					bram_wait <= bram_wait;
					shifted <= shifted;
					nodecount<= nodecount;
					numsamples <= numsamples;
			end
			
			default: begin
					state <= `IDLE;	//will need two ready signals, for weights and pixels
					loaded <= 0;
					rdaddr <= 0;
					wraddr <= `RESULT_ADDR;
					adrsent <= 0;
					address_a <= 0;
					address_b <= 1;
					readdatareg <= 16'hBEEF;
					calc_pix <= 0;
					accumulator <= 0;
					layer1_res <= 0;
					bram_wait <= 0;
					shifted <= 0;
					nodecount<= 0;
					numsamples <= 0;
			end
		endcase
	end
end

always @(*) begin
	byteenable <= 2'b11;
	chipselect <= 1;
	case (state)
		`IDLE: begin
			write_n <= 1;
			read_n <= 1;
			address <= `SDRAM_BASE;
		end
		`LDR: begin
			write_n <= 1;
			read_n <= adrsent < `KERNEL_SIZE ? 0 : 1;
			address <= rdaddr;
		end
		`INITPIX: begin
			write_n <= 1;
			read_n <= adrsent < `WORDS_PER_SAMPLE1 ? 0 : 1;
			address <= rdaddr;
		end		
		`WRITEPIX: begin
			write_n <= 0;
			read_n <= 1;
			address <= wraddr;
		end
		default: begin
			write_n <= 1;
			read_n <= 1;					
			address <= `SDRAM_BASE;
		end
	endcase
			
			
end		

endmodule

//			`TRANSITION: begin
//					loaded <= `KERNEL_SIZE;
//					state <= `WRITE2;
//					address_a <= 0;
//					address_b <= 1;					
//					writes <= writes;
//					rdaddr <= rdaddr;
//					wraddr <= wraddr - 1;
//					adrsent <= adrsent;
//					readdatareg <= 16'hFEED;
//					calc_pix <= 0;
//					accumulator <= 0;
//					layer1_res <= 0;
//					bram_wait <= 0;
//			end
//			`WRITE: begin
//					writes = ~waitrequest ? writes + 1 : writes;
//					state <= ~waitrequest ? `WRITE2: `WRITE;
//					loaded <= loaded;
//					address_a <= writes*2;
//					address_b <= writes*2 + 1;
//					rdaddr <= rdaddr;
//					wraddr <= wraddr;
//					adrsent <= adrsent;
//					readdatareg <= 16'hDEAD;
//					calc_pix <= 0;
//					accumulator <= 0;
//					layer1_res <= 0;
//					bram_wait <= 0;
//			end
//			`WRITE2: begin // gives BRAM time to read the data
//					writes <= writes;
//					state <= (writes == `KERNEL_SIZE) ? `DONE: `WRITE;
//					loaded <= loaded;
//					address_a <= writes*2;
//					address_b <= writes*2 + 1;
//					rdaddr <= rdaddr;
//					wraddr <= wraddr + 1;
//					adrsent <= adrsent;
//					readdatareg <= 16'hDEED;
//					calc_pix <= 0;
//					accumulator <= 0;
//					layer1_res <= 0;
//					bram_wait <= 0;			
//			end
