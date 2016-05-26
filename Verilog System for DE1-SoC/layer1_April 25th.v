`define SDRAM_BASE 32'h0
`define IDLE 0      
`define LDR 1      
`define WRITE2 2     
`define WRITE 3      
`define BRAM_DONE 4
`define TRANSITION 5
`define INITPIX 6		//load into pixel reg, 1 sample
`define CALCPIX 7	//stay in for all 16 and then back to movepix to load in the next 16, toggle 1 bit reg for the read BRAM wait
`define SIGMOID 8
`define SAVEPIX 9	//save 1 bit result in 16 bit reg, go back to initpix for next sample
`define WRITEPIX 10
`define DONE 11

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
output done,
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

assign done = (state == `DONE);
//wire rst;
//assign rst = ~man_rst_n | ~reset_n;


reg [359:0] calc_pix;
reg [15:0] accumulator;	//round to 1 bit num(sigmoid) and then put back into SDRAM
reg [15:0] layer1_res;	//store 1 bit sigmoid values into a 16 bit final reg to store back into SDRAM
reg bram_wait;
reg [8:0] shifted;

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


reg [16:0] writes = 0;  

reg [16:0] loaded = 0;
reg [16:0] adrsent = 0;

reg [31:0] rdaddr = `SDRAM_BASE;
reg [31:0] wraddr = `SDRAM_BASE + 32'd57000; //h20000 = 512 rows * 256 reads (2 pixels per read)
reg [15:0] readdatareg;

assign writedata = {q_a,q_b};
assign {data_a,data_b} = readdatareg;
assign rden_a = 1;//(state == `WRITE);
assign rden_b = 1;//(state == `WRITE);
assign wren_a = (state == `LDR);// && readdatavalid);
assign wren_b = (state == `LDR);// && readdatavalid);

// state logic for reading and writing
always @(posedge clk) begin
	if(~reset_n) begin
		state <= `IDLE;
		loaded <= 0;
		writes <= 0;
		rdaddr <= 0;
		wraddr <= 32'd57000;
		adrsent <= 0;
		address_a <= 0;
		address_b <= 1;
		readdatareg <= 16'hF00D;
		calc_pix <= 0;
		accumulator <= 0;
		layer1_res <= 0;
		bram_wait <= 0;
		shifted <= 0;
	end
	else begin
		case(state)
			`IDLE: begin
					state <= ready ? `LDR : `IDLE;	//will need two ready signals, for weights and pixels
					loaded <= 0;
					writes <= 0;
					rdaddr <= 0;
					wraddr <= 32'd57000;
					adrsent <= 0;
					address_a <= 0;
					address_b <= 1;
					readdatareg <= 16'hBEEF;
					calc_pix <= 0;
					accumulator <= 0;
					layer1_res <= 0;
					bram_wait <= 0;
					shifted <= 0;
			end
			`LDR: begin
					// Change to write the value of "Writes" to memory and see if its byte addressable or word addressable
					loaded <= readdatavalid ? loaded + 1 : loaded;
					state <= (loaded == 57000) ? `BRAM_DONE : `LDR;
					address_a <= loaded*2;
					address_b <= loaded*2 + 1;					
					writes <= writes;
					rdaddr <= (~waitrequest && adrsent < 57000) ? rdaddr + 1 : rdaddr;
					wraddr <= wraddr;
					adrsent <= (~waitrequest && adrsent < 57000) ? adrsent + 1: adrsent;
					readdatareg <= readdatavalid ? readdata : readdatareg;
					calc_pix <= 0;
					accumulator <= 0;
					layer1_res <= 0;
					bram_wait <= 0;
					shifted <= 0;
			end
//			`TRANSITION: begin
//					loaded <= 57000;
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
//					state <= (writes == 57000) ? `DONE: `WRITE;
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
			`BRAM_DONE: begin
					state <= `INITPIX;
					loaded <= 0;
					writes <= 0;
					rdaddr <= 0;
					wraddr <= 32'd57000;
					adrsent <= 0;
					address_a <= 0;
					address_b <= 1;
					readdatareg <= 16'hDEAF;
					calc_pix <= 0;
					accumulator <= 0;
					layer1_res <= 0;
					bram_wait <= 0;
					shifted <= 0;
			end
			`INITPIX: begin
					// Change to write the value of "Writes" to memory and see if its byte addressable or word addressable
					loaded <= readdatavalid ? loaded + 1 : loaded;
					state <= (loaded == 23) ? `CALCPIX : `INITPIX;
					address_a <= loaded < 20 ? 0 : 1;
					address_b <= 2;					
					writes <= writes;
					rdaddr <= (~waitrequest && adrsent < 23) ? rdaddr + 1 : rdaddr;
					wraddr <= wraddr;
					adrsent <= (~waitrequest && adrsent < 23) ? adrsent + 1: adrsent;
					readdatareg <= 0;
					calc_pix <= ~readdatavalid? calc_pix : loaded == 22 ? {readdata[7:0], calc_pix[359:8]} : {readdata, calc_pix[359:16]};
					accumulator <= loaded < 20 ? q_a : accumulator;
					layer1_res <= 0;
					bram_wait <= 0;
					shifted <= 0;
		
			end
			`CALCPIX: begin		//per node for layer 2
					loaded <= 0;
					state <= (shifted == 359) ? `SIGMOID : `CALCPIX;
					address_a <= ~bram_wait ? address_a + 2 : address_a;
					address_b <= bram_wait ? address_b + 2 : address_b;					
					writes <= writes;
					rdaddr <= rdaddr;
					wraddr <= wraddr;
					adrsent <= adrsent;
					readdatareg <= 0;
					calc_pix <= {calc_pix[0],calc_pix[359:1]};
					accumulator <= ~calc_pix[0] ? accumulator : bram_wait ? accumulator + {{8{q_b[7]}}, q_b} : accumulator + {{8{q_a[7]}}, q_a};
					//q_a and q_b are the weights
					layer1_res <= 0;
					bram_wait <= ~bram_wait;
					shifted <= shifted + 1;
			
			end
			
			`SIGMOID: begin
					loaded <= 0;
					state <= `SAVEPIX;	//check if 200 nodes are done, if the num of results is divisible by 16, go to writepix state
					address_a <= address_a + 1;
					address_b <= address_b + 1;				
					writes <= writes;
					rdaddr <= rdaddr;
					wraddr <= wraddr;
					adrsent <= adrsent;
					readdatareg <= 0;
					calc_pix <= calc_pix;
					accumulator <= q_a;
					//q_a and q_b are the weights
					layer1_res <= {~accumulator[15], layer1_res[15:1]};
				
					bram_wait <= bram_wait;
					shifted <= 0;
			
			end
			
			`SAVEPIX: begin
					loaded <= loaded;
					state <= `CALCPIX;	//check if 200 nodes are done, if the num of results is divisible by 16, go to writepix state
					address_a <= address_a;
					address_b <= address_b;				
					writes <= writes;
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
			
			end
			
			`WRITEPIX: begin
					loaded <= 0;
					calc_pix <= 0;
					accumulator <= 0;
					layer1_res <= 0;
					bram_wait <= 0;
			
			
			end
			
			`DONE: begin
					loaded <= 0;
					calc_pix <= 0;
					accumulator <= 0;
					layer1_res <= 0;
					bram_wait <= 0;
			
			
			end
			
			default: begin
					state <= ready ? `LDR : `IDLE;
					loaded <= 0;
					writes <= 0;
					rdaddr <= 0;
					wraddr <= 32'd57000;
					adrsent <= 0;
					readdatareg <= readdatareg;
					calc_pix <= 0;
					accumulator <= 0;
					layer1_res <= 0;
					bram_wait <= 0;
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
			read_n <= adrsent < 57000 ? 0 : 1;
			address <= rdaddr;
		end
//		`WRITE: begin
//			write_n <= 0;
//			read_n <= 1;
//			address <= wraddr;
//		end
//		`WRITE2: begin
//			write_n <= 1;
//			read_n <= 1;
//			address <= wraddr;
//		end
//		`TRANSITION: begin
//			write_n <= 1;
//			read_n <= 1;
//			address <= wraddr;
//		end
		`INITPIX: begin
			write_n <= 1;
			read_n <= adrsent < 23 ? 0 : 1;
			address <= rdaddr;
		end
		default: begin
			write_n <= 1;
			read_n <= 1;					
			address <= 0;
		end
	endcase
			
			
end		

endmodule
