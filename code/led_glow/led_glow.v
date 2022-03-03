module led_glow(clk, out);
	parameter NOUT = 55;
	input clk;
	output [NOUT:0] out;

	reg [29:0] cnt;
	wire [NOUT:0] out;

	wire pwmclk;
	
	assign pwmclk = clk;
	
	always @(posedge clk) begin
		cnt = cnt+30'd1;
	end

	wire [3:0] PWM_input1 = cnt[23] ? cnt[22:19] : ~cnt[22:19];    // ramp the PWM input up and down

	reg [4:0] PWM1;
	always @(posedge pwmclk) PWM1 <= PWM1[3:0]+PWM_input1;

	// http://www.rhinocerus.net/forum/lang-verilog/167265-sized-genvar.html
	genvar i;
	generate
	for (i=6'd0;i<(NOUT+6'd1);i=i+6'd1)
	begin : foo
	  assign out[i] = (i[2:0]==cnt[26:24]) ? (~PWM1[4]) : 1'd0;
	end
	endgenerate

endmodule
/*
module led_glow(clk, LED0,fout,clko);
	input clk;
	output LED0;
	output [3:0]fout;
	output clko;

	reg [25:0] cnt;

	always @(posedge clk) cnt<=cnt+1;
	wire [3:0] PWM_input1 = cnt[25] ? cnt[24:21] : ~cnt[24:21];    // ramp the PWM input up and down

	reg [4:0] PWM1;
	always @(posedge clk) PWM1 <= PWM1[3:0]+PWM_input1;

	assign LED0 = (PWM1[4]);
	assign fout = cnt[25:22];
	assign clko = cnt[3];

endmodule
*/