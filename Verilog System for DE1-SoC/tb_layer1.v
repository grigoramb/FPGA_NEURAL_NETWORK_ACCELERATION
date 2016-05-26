`timescale 1 ns / 100 ps

module tb_layer1;
	reg clock;
	reg reset_n;
	reg readdatavalid;
	reg [15:0] readdata;
	reg waitrequest;
	reg ready;
	reg cont = 1;
	reg [9:0] counter = 0;
	reg[15:0] memory[0:131072];
	wire [31:0] address;
	reg [31:0] rdadr;
	reg isread = 0;
	reg [7:0] s1_q;
	reg [7:0] s2_q;
	initial begin
		isread <= 0;
		clock <= 0;
		ready <= 0;
		reset_n <= 0;
		readdatavalid <= 0;
		readdata <= 16'h0001;
		waitrequest <= 0;
		#20;
		reset_n <= 1;
		ready <= 1;
		s1_q <= 8'h1;
		s2_q <= 8'h2;
	end

	layer2 DUT(
		.clk(clock),
		.reset_n(reset_n),
		.waitrequest(waitrequest),
		.readdatavalid(readdatavalid),
		.readdata(readdata),
		.read_n(read_n),
		.write_n(write_n),
		.chipselect(chipselect),
		.address(address),
		.byteenable(byteenable),
		.writedata(writedata),
		.ready(ready),
		.done(done),
		.s1_q(s1_q),
		.s2_q(s2_q)
		);

	always begin
		#10 clock = ~clock;
		if (read_n == 0 && counter > 8) begin
			counter = 0;
			isread = 1;
	        end
		if ((write_n == 0) && counter > 6) begin
			counter = 0;
	        end
		if(counter == 4) begin
			waitrequest <= 0;
			rdadr <= ~read_n ? address : 0;
		end
		else begin
			waitrequest <= 0;
		end
		if ((counter == 6) && isread == 1) begin
			readdatavalid = 1;
			
			//readdata = memory[rdadr] || 0;
		end
		else begin
			readdatavalid = 1;
		end
		if(counter == 8) begin
			isread = 0;
		end

		counter = counter + clock;
		readdata <= $random;
		//readdata <= 0;
	end

endmodule
