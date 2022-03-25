//
// File name          :usb_controller.v
// Module name        :usb_controller.v
// Created by         :GaoYun Semi
// Author             :(Winson)
// Created On         :2020-12-03 09:28 GuangZhou
// Last Modified      :
// Update Count       :2020-12-03 09:28
// Description        :
//===========================================
`include "static_macro_define.v"
`include "usb_device_controller_define.v"
module `module_name
(
        // 60 MHz UTMI clock.
        input clk_i         ,
        // Synchronous reset; clear buffers && re-attach to the bus.
        input reset_i       ,
        // High for one clock when a reset wire is detected on the USB bus.
        // Note: do NOT wire this wire to RESET externally.
        output usbrst_o      ,
        // High when the device is operating (|| suspended) in high speed mode.
        output highspeed_o   ,
        // High while the device is suspended.
        // Note: This wire is not synchronized to CLK.
        // It may be used to asynchronously drive the UTMI SuspendM pin.
        output suspend_o     ,
        // High when the device is in the Configured state.
        output online_o      ,
        // Data byte to send
        input  [7:0]    txdat_i  ,
        input           txval_i  ,
        // Data Number to send
        input  [11:0]   txdat_len_i  ,
        input  [3:0]    txiso_pid_i  ,
        // buffer in order to blast data efficiently in big chunks
        input           txcork_i ,
        // High if the entity read the next byte
        output          txpop_o  ,
        // High if the entity TX is active
        output          txact_o  ,
        // High if the TX Packet transfer finish
        output          txpktfin_o  ,

        // Received data byte, valid if RXVAL is high.
        output [7:0]    rxdat_o  ,
        // High if a received byte is available on RXDAT.
        output          rxval_o  ,
        // High if the buffer is ready to accept the next packet
        input           rxrdy_i  ,
        // High if the entity RX is active
        output          rxact_o  ,
        // High if the RX Packet is a good packet
        output          rxpktval_o  ,
        // Endpoint 0 Control Channel Setup Data
        // High if the Setup is active
        output          setup_o,
        // The Active Endpoint
        output [3:0]    endpt_o  ,
        // High when the controller received the start of frame packet.
        output          sof_o    ,

        // Read Address of device descriptor
        output [9:0]    descrom_raddr_o,
        // Read Data of device descriptor
        input  [7:0]    descrom_rdata_i,
        // Start Address of device descriptor
        input  [9:0]    desc_dev_addr_i,
        // Length of device descriptor
        input  [7:0]    desc_dev_len_i,
        // Start Address of device qualifier
        input  [9:0]    desc_qual_addr_i,
        // Length of device qualifier
        input  [7:0]    desc_qual_len_i,
        // Start Address of device full speed configuration
        input  [9:0]    desc_fscfg_addr_i,
        // Length of device full speed configuration
        input  [7:0]    desc_fscfg_len_i,
        // Start Address of device high speed configuration
        input  [9:0]    desc_hscfg_addr_i,
        // Length of device high speed configuration
        input  [7:0]    desc_hscfg_len_i,
        // Start Address of device other speed configuration
        input  [9:0]    desc_oscfg_addr_i,
        // Start Address of device string descriptor
        input  [9:0]    desc_strlang_addr_i,
        // Start Address of device verdor string
        input  [9:0]    desc_strvendor_addr_i,
        // Length of device verdor string
        input  [7:0]    desc_strvendor_len_i,
        // Start Address of device product string
        input  [9:0]    desc_strproduct_addr_i,
        // Length of device verdor string
        input  [7:0]    desc_strproduct_len_i,
        // Start Address of device serial string
        input  [9:0]    desc_strserial_addr_i,
        // Length of device verdor string
        input  [7:0]    desc_strserial_len_i,
        // High when device decriptor have string descriptor
        input           desc_have_strings_i,

        //UTMI Interface
        output [7:0] utmi_dataout_o   ,
        output       utmi_txvalid_o   ,
        input        utmi_txready_i   ,
        input  [7:0] utmi_datain_i    ,
        input        utmi_rxactive_i  ,
        input        utmi_rxvalid_i   ,
        input        utmi_rxerror_i   ,
        input  [1:0] utmi_linestate_i ,
        output [1:0] utmi_opmode_o    ,
        output [1:0] utmi_xcvrselect_o,
        output       utmi_termselect_o,
        output       utmi_reset_o
);
    //usb_controller u_usb_controller (
    `getname(usb_device_controller,`module_name) u_usb_device_controller(
             .clk_i               (clk_i               )
            ,.reset_i             (reset_i             )
            ,.usbrst_o            (usbrst_o            )
            ,.highspeed_o         (highspeed_o         )
            ,.suspend_o           (suspend_o           )
            ,.online_o            (online_o            )
            ,.txdat_i             (txdat_i             )
            ,.txval_i             (txval_i             )
            ,.txdat_len_i         (txdat_len_i         )
            ,.txiso_pid_i         (txiso_pid_i         )
            ,.txcork_i            (txcork_i            )
            ,.txpop_o             (txpop_o             )
            ,.txact_o             (txact_o             )
            ,.txpktfin_o          (txpktfin_o          )
            ,.rxdat_o             (rxdat_o             )
            ,.rxval_o             (rxval_o             )
            ,.rxact_o             (rxact_o             )
            ,.rxrdy_i             (rxrdy_i             )
            ,.rxpktval_o          (rxpktval_o          )
            ,.setup_o             (setup_o             )
            ,.endpt_o             (endpt_o             )
            ,.sof_o               (sof_o               )
            ,.descrom_rdata_i     (descrom_rdata_i     )
            ,.descrom_raddr_o     (descrom_raddr_o     )
            ,.desc_dev_addr_i       (desc_dev_addr_i       )
            ,.desc_dev_len_i        (desc_dev_len_i        )
            ,.desc_qual_addr_i      (desc_qual_addr_i      )
            ,.desc_qual_len_i       (desc_qual_len_i       )
            ,.desc_fscfg_addr_i     (desc_fscfg_addr_i     )
            ,.desc_fscfg_len_i      (desc_fscfg_len_i      )
            ,.desc_hscfg_addr_i     (desc_hscfg_addr_i     )
            ,.desc_hscfg_len_i      (desc_hscfg_len_i      )
            ,.desc_oscfg_addr_i     (desc_oscfg_addr_i     )
            ,.desc_strlang_addr_i   (desc_strlang_addr_i   )
            ,.desc_strvendor_addr_i (desc_strvendor_addr_i )
            ,.desc_strvendor_len_i  (desc_strvendor_len_i  )
            ,.desc_strproduct_addr_i(desc_strproduct_addr_i)
            ,.desc_strproduct_len_i (desc_strproduct_len_i )
            ,.desc_strserial_addr_i (desc_strserial_addr_i )
            ,.desc_strserial_len_i  (desc_strserial_len_i  )
            ,.desc_have_strings_i   (desc_have_strings_i   )
            ,.utmi_dataout_o      (utmi_dataout_o      )
            ,.utmi_txvalid_o      (utmi_txvalid_o      )
            ,.utmi_txready_i      (utmi_txready_i      )
            ,.utmi_datain_i       (utmi_datain_i       )
            ,.utmi_rxactive_i     (utmi_rxactive_i     )
            ,.utmi_rxvalid_i      (utmi_rxvalid_i      )
            ,.utmi_rxerror_i      (utmi_rxerror_i      )
            ,.utmi_linestate_i    (utmi_linestate_i    )
            ,.utmi_opmode_o       (utmi_opmode_o       )
            ,.utmi_xcvrselect_o   (utmi_xcvrselect_o   )
            ,.utmi_termselect_o   (utmi_termselect_o   )
            ,.utmi_reset_o        (utmi_reset_o        )
         );
endmodule
