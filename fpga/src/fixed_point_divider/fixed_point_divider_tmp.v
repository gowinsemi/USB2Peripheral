//Copyright (C)2014-2021 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: GowinSynthesis V1.9.7.02Beta
//Part Number: GW1N-LV2LQ144XC7/I6
//Device: GW1N-2
//Created Time: Mon May 10 08:46:21 2021

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	Fixed_Point_Divider_Top your_instance_name(
		.dividend(dividend_i), //input [31:0] dividend
		.divisor(divisor_i), //input [31:0] divisor
		.start(start_i), //input start
		.clk(clk_i), //input clk
		.quotient_out(quotient_out_o), //output [31:0] quotient_out
		.complete(complete_o) //output complete
	);

//--------Copy end-------------------
