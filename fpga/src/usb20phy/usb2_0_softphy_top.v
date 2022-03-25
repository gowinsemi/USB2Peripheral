

`timescale 1ns / 1ns
`include "usb2_0_softphy_name.v"
//`include "usb2_0_softphy_define.v"
`include "static_macro_define.v"

module `module_name    (
            input       clk_i,
            input       rst_i,
            input       fclk_i,
            input       pll_locked_i,
            //utmi
            input[7:0]  utmi_data_out_i,
            input       utmi_txvalid_i,
            input[1:0]  utmi_op_mode_i,
            input[1:0]  utmi_xcvrselect_i,
            input       utmi_termselect_i,
            output[7:0] utmi_data_in_o,
            output      utmi_txready_o,
            output      utmi_rxvalid_o,
            output      utmi_rxactive_o,
            output      utmi_rxerror_o,
            output[1:0] utmi_linestate_o,
            //usb interface
            inout       usb_dxp_io,
            inout       usb_dxn_io,
            input       usb_rxdp_i,
            input       usb_rxdn_i,
            output      usb_pullup_en_o,
            inout       usb_term_dp_io,
            inout       usb_term_dn_io
);

wire       fs_txready_o  ;
wire [7:0] fs_data_in_o  ;
wire       fs_rxvalid_o  ;
wire       fs_rxactive_o ;
wire       fs_rxerror_o  ;
wire [1:0] fs_linestate_o;
wire       hs_txready_o  ;
wire [7:0] hs_data_in_o  ;
wire       hs_rxvalid_o  ;
wire       hs_rxactive_o ;
wire       hs_rxerror_o  ;
wire [1:0] hs_linestate_o;




assign utmi_txready_o   = utmi_xcvrselect_i[0] ? fs_txready_o   : hs_txready_o  ;
assign utmi_data_in_o   = utmi_xcvrselect_i[0] ? fs_data_in_o   : hs_data_in_o  ;
assign utmi_rxvalid_o   = utmi_xcvrselect_i[0] ? fs_rxvalid_o   : hs_rxvalid_o  ;
assign utmi_rxactive_o  = utmi_xcvrselect_i[0] ? fs_rxactive_o  : hs_rxactive_o ;
assign utmi_rxerror_o   = utmi_xcvrselect_i[0] ? fs_rxerror_o   : hs_rxerror_o  ;
assign utmi_linestate_o = utmi_xcvrselect_i[0] ? fs_linestate_o : hs_linestate_o;


//--------------------------------------------------------------------
wire rxd;
wire txdx;
wire txoe;


ELVDS_IOBUF u_TLVDS_IOBUF (.O(rxd), .IO(usb_dxp_io), .IOB(usb_dxn_io), .I(txdx), .OEN(txoe));

`getname(usb2_0_softphy,`module_name) 
    #(
        .usb_rst_det(1)
    ) 
    u_usb2_0_softphy 
    (
         .fclk_deg0        (fclk_i           )
        ,.pll_locked       (pll_locked_i     )
        ,.clk              (clk_i            )
        ,.rstn             (~rst_i           )
        ,.usb_rst          (                 )
        ,.phy_tx_mode      (1'b0             )
        ,.DataOut_i        (utmi_data_out_i  )
        ,.TxValid_i        (utmi_txvalid_i&(!utmi_xcvrselect_i[0]))
        ,.OpMode_i         (utmi_op_mode_i   )
        ,.TermSelect_i     (utmi_termselect_i)
        ,.XcvrSelect_i     (utmi_xcvrselect_i)
        ,.TxReady_o        (hs_txready_o     )
        ,.DataIn_o         (hs_data_in_o     )
        ,.RxValid_o        (hs_rxvalid_o     )
        ,.RxActive_o       (hs_rxactive_o    )
        ,.RxError_o        (hs_rxerror_o     )
        ,.LineState_o      (hs_linestate_o   )
        ,.rxd              (rxd              )
        ,.txdx             (txdx             )
        ,.txoe             (txoe             )
        ,.rxdp             (usb_rxdp_i       )
        ,.rxdn             (usb_rxdn_i       )
        ,.pullup_en        (usb_pullup_en_o  )
        ,.term_Dp          (                 )
        ,.term_Dn          (                 )
);

//--------------------------------------------------------------------

`getname(usb_fs_phy,`module_name) u_usb_fs_phy
(
     .clk_i             (clk_i            )
    ,.rst_i             (rst_i            )
    ,.usb_reset_detect_o(                 )
    ,.utmi_data_out_i   (utmi_data_out_i  )
    ,.utmi_txvalid_i    (utmi_txvalid_i&(utmi_xcvrselect_i[0]))
    ,.utmi_op_mode_i    (utmi_op_mode_i   )
    ,.utmi_xcvrselect_i (utmi_xcvrselect_i)
    ,.utmi_termselect_i (utmi_termselect_i)
    ,.utmi_data_in_o    (fs_data_in_o     )
    ,.utmi_txready_o    (fs_txready_o     )
    ,.utmi_rxvalid_o    (fs_rxvalid_o     )
    ,.utmi_rxactive_o   (fs_rxactive_o    )
    ,.utmi_rxerror_o    (fs_rxerror_o     )
    ,.utmi_linestate_o  (fs_linestate_o   )
    ,.usb_dp_io         (usb_term_dp_io   )
    ,.usb_dn_io         (usb_term_dn_io   )
);
endmodule
