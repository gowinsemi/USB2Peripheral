//Copyright (C)2014-2021 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.8
//Part Number: GW2AR-LV18QN88PC7/I6
//Device: GW2AR-18C
//Created Time: Fri Nov 05 17:24:14 2021

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    Gowin_rPLL your_instance_name(
        .clkout(clkout_o), //output clkout
        .lock(lock_o), //output lock
        .lock(lock_o), //output lock
        .clkoutd(clkoutd_o), //output clkoutd
        .clkin(clkin_i) //input clkin
    );

//--------Copy end-------------------
