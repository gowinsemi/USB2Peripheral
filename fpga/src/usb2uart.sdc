//Copyright (C)2014-2021 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.8 
//Created Time: 2021-11-11 16:33:10
create_clock -name M60 -period 12.5 -waveform {0 6.25} [get_nets {PARALLEL_GPIO_d[9]}]
