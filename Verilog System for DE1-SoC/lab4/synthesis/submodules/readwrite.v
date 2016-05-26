`define SDRAM_BASE 32'h0
`define IDLE 0      
`define READ 1      
`define WRITE 2     

module readwrite (
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
input inc_addr,
input dec_addr,
input read,
input write,
output [17:0] adr,
input [9:0] sw,
// debugging
output reg [15:0] val = 16'h0
//input man_rst_n
);

assign adr = address[17:0];

assign writedata = {6'h0,sw};
reg [3:0] buttons_prev;

reg [1:0] state;
// state logic for reading and writing
always @(posedge clk) begin
	if(~reset_n) begin
		state <= `IDLE;
		val <= 0;
		buttons_prev <= 0;
	end
	else begin
		buttons_prev <= {inc_addr, dec_addr, read, write};
		val <= readdatavalid ? readdata : val;
		case(state)
			`IDLE: begin
					state <= read ? `READ : write ? `WRITE : `IDLE;
					if(inc_addr && ~buttons_prev[3]) begin
						address <= address + 1;
					end
					else if(dec_addr && ~buttons_prev[2]) begin
						address <= address - 1;
					end
					else begin
						address <= address;
					end
			end
			`READ: begin
					state <= ~waitrequest ? `IDLE : `READ;			
					address <= address;
			end
			`WRITE: begin
					state <= ~waitrequest ? `IDLE: `WRITE;
					address <= address;
			end
			default: begin
					state <= `IDLE;
					address <= address;
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
		end
		`READ: begin
			write_n <= 1;
			read_n <= 0;
		end
		`WRITE: begin
			write_n <= 0;
			read_n <= 1;
		end
		// Includes SHIFT, DONE, and DEBUG states
		default: begin
			write_n <= 1;
			read_n <= 1;					
		end
	endcase
			
			
end		

endmodule
