
module Top
#(
    parameter num_i2c_ports  = 4          , //Number of I2C master ports
    parameter num_uart_ports = 3          , //Number of UART ports
    parameter num_gpio       = 10           //Number of UART ports
)
(
    input   wire                   CLK_IN , //50Mhz input clock

    inout   wire [1:num_i2c_ports] I2C_SCL, //I2C master ports
    inout   wire [1:num_i2c_ports] I2C_SDA,

    output  wire [1:num_uart_ports]UART_TXD,//UART ports
    input   wire [1:num_uart_ports]UART_RXD,

    output  wire [num_gpio-1:0] PARALLEL_GPIO,

    inout   wire usb_dxp_io,
    inout   wire usb_dxn_io,
    input   wire usb_rxdp_i,
    input   wire usb_rxdn_i,
    output  wire usb_pullup_en_o,
    inout   wire usb_term_dp_io,
    inout   wire usb_term_dn_io
  );

  wire RESET_IN;
  wire fclk_480M;
  wire rxpktval;
  wire usb_busreset;
  wire usb_highspeed;
  wire usb_suspend;
  wire usb_online;
  wire usb_sof;
  wire     [1:num_i2c_ports] i2c_scl_o;
  wire     [1:num_i2c_ports] i2c_sda_o;
  wire     [1:num_i2c_ports] i2c_scl_i;
  wire     [1:num_i2c_ports] i2c_sda_i;

  wire [num_i2c_ports-1:0] i2c_paddr;
  wire [31:0]i2c_pwdata;
  wire i2c_penable;
  wire i2c_pwrite;
  wire [num_i2c_ports-1:0] i2c_psel;

  wire [31:0] i2c_prdata[1:num_i2c_ports];


  wire [1:num_i2c_ports] i2c_rd;
  wire [7:0] i2c_rx_data[1:num_i2c_ports];
  wire [8:0] i2c_rx_len[1:num_i2c_ports];
  wire [1:num_i2c_ports] usb_rxrdy_i2c;
  wire [7:0] usb_txdat_i2c[1:num_i2c_ports];
  wire [11:0] usb_txdat_len_i2c[1:num_i2c_ports];
  wire [1:num_i2c_ports] usb_txcork_i2c;

  wire [1:num_uart_ports] usb_rxrdy_uart;
  wire [7:0] usb_txdat_uart[1:num_uart_ports];
  wire [11:0] usb_txdat_len_uart[1:num_uart_ports];
  wire [1:num_uart_ports] usb_txcork_uart;

  wire lock_o;

  wire [7:0] usb_txdat;
  reg  [11:0]usb_txdat_len;
  wire usb_txcork;
  wire usb_txpop ;
  wire usb_txact ;
  wire [7:0] usb_rxdat ;
  wire usb_rxval ;
  wire usb_rxact ;
  wire usb_rxrdy ;
  wire [3:0] endpt_sel;
  wire [11:0] txdat_len;

  wire       setup_active;
  wire       setup_val   ;
  wire [7:0] setup_data  ;
  wire       endpt0_send ;
  wire  [7:0]endpt0_dat  ;

  wire [31:0]uart_s_dte_rate[1:num_uart_ports];
  wire [7:0] uart_s_char_format[1:num_uart_ports];
  wire [7:0] uart_s_parity_type[1:num_uart_ports];
  wire [7:0] uart_s_data_bits[1:num_uart_ports];

  wire [11:0]txdat_len_uart_config;

  reg [7:0] rst_cnt = 0;
  wire usb_rxrdy_gpio;

  wire [7:0] uart_tx_data[1:num_uart_ports]    ;
  wire       uart_tx_data_val[1:num_uart_ports];
  wire       uart_tx_busy[1:num_uart_ports]    ;
  wire [15:0] uart_rx_data[1:num_uart_ports]    ;
  wire       uart_rx_data_val[1:num_uart_ports];

  wire [1:0]  PHY_XCVRSELECT      ;
  wire        PHY_TERMSELECT      ;
  wire [1:0]  PHY_OPMODE          ;
  wire [1:0]  PHY_LINESTATE       ;
  wire        PHY_TXVALID         ;
  wire        PHY_TXREADY         ;
  wire        PHY_RXVALID         ;
  wire        PHY_RXACTIVE        ;
  wire        PHY_RXERROR         ;
  wire [7:0]  PHY_DATAIN          ;
  wire [7:0]  PHY_DATAOUT         ;
  wire        PHY_CLKOUT          ;

  wire [9:0]  DESCROM_RADDR       ;
  wire [7:0]  DESCROM_RDAT        ;
  wire [9:0]  DESC_DEV_ADDR       ;
  wire [7:0]  DESC_DEV_LEN        ;
  wire [9:0]  DESC_QUAL_ADDR      ;
  wire [7:0]  DESC_QUAL_LEN       ;
  wire [9:0]  DESC_FSCFG_ADDR     ;
  wire [7:0]  DESC_FSCFG_LEN      ;
  wire [9:0]  DESC_HSCFG_ADDR     ;
  wire [7:0]  DESC_HSCFG_LEN      ;
  wire [9:0]  DESC_OSCFG_ADDR     ;
  wire [9:0]  DESC_STRLANG_ADDR   ;
  wire [9:0]  DESC_STRVENDOR_ADDR ;
  wire [7:0]  DESC_STRVENDOR_LEN  ;
  wire [9:0]  DESC_STRPRODUCT_ADDR;
  wire [7:0]  DESC_STRPRODUCT_LEN ;
  wire [9:0]  DESC_STRSERIAL_ADDR ;
  wire [7:0]  DESC_STRSERIAL_LEN  ;
  wire        DESCROM_HAVE_STRINGS;


  //For now there is a fixed number of UART, I2C and GPIO Endpoints. 
  //Later will will make endpoints configurable based on total number of ports in design.
  parameter ENDPT_UART_CONFIG =4'h0;
  parameter ENDPT_UART1_DATA  =4'h5;
  parameter ENDPT_UART2_DATA  =4'h6;
  parameter ENDPT_UART3_DATA  =4'h7;
  parameter ENDPT_I2C1        =4'h1;
  parameter ENDPT_I2C2        =4'h2;
  parameter ENDPT_I2C3        =4'h3;
  parameter ENDPT_I2C4        =4'h4;
  parameter ENDPT_PARALLEL    =4'h8;

  //==============================================================
  //======RST

  assign RESET_IN = rst_cnt<32;

  always@(posedge PHY_CLKOUT) begin
    if (rst_cnt <= 32) begin
      rst_cnt <= rst_cnt + 8'd1;
    end
  end

  //==============================================================
  //==============================================================
  //======PLL 
  Gowin_rPLL u_pll(
    .clkout(fclk_480M), //output clkout
    .clkoutd(PHY_CLKOUT), //output clkout
    .lock(lock_o), //output lock
    .clkin (CLK_IN    )  //input clkin
  );
  //==============================================================
  //======PARALLEL_ctrl

  usb_gpio_ctrl u_usb_gpio_ctrl
  (
    .clk_i          (PHY_CLKOUT  )//clock
    ,.reset_i        (RESET_IN    )//reset

    ,.usb_endpt_i    (endpt_sel)//

    ,.usb_rxdat_i    (usb_rxdat)//
    ,.usb_rxval_i    (usb_rxval)//
    ,.usb_rxact_i    (usb_rxact)//
    ,.usb_rxrdy_o    (usb_rxrdy_gpio)//
    ,.usb_rxpktval_i (rxpktval)//

    ,.parallel_gpio_o(PARALLEL_GPIO)
  );
  defparam u_usb_gpio_ctrl.ENDPT_PARALLEL = ENDPT_PARALLEL;

  //==============================================================
  //======UART_config
  usb_uart_config u_usb_uart_config
  (
    .PHY_CLKOUT  (PHY_CLKOUT     ) // clock
    ,.RESET_IN    (RESET_IN       ) // reset
    ,.setup_active(setup_active   )
    ,.endpt_sel   (endpt_sel      )
    ,.usb_rxval   (usb_rxval) 
    ,.usb_rxact   (usb_rxact) 
    ,.usb_rxdat   (usb_rxdat)
    ,.usb_txact   (usb_txact)
    ,.usb_txpop   (usb_txpop)
    ,.txdat_len_o (txdat_len_uart_config)

    ,.uart1_endpt0_dat_o (endpt0_dat   )
    ,.uart1_endpt0_send_o(endpt0_send  ) 

    ,.uart1_BAUD_RATE_o  (uart_s_dte_rate[1]) 
    ,.uart1_PARITY_BIT_o (uart_s_parity_type[1]) 
    ,.uart1_STOP_BIT_o   (uart_s_char_format[1]) 
    ,.uart1_DATA_BITS_o  (uart_s_data_bits[1]) 
    ,.uart2_BAUD_RATE_o  (uart_s_dte_rate[2]) 
    ,.uart2_PARITY_BIT_o (uart_s_parity_type[2]) 
    ,.uart2_STOP_BIT_o   (uart_s_char_format[2]) 
    ,.uart2_DATA_BITS_o  (uart_s_data_bits[2]) 
    ,.uart3_BAUD_RATE_o  (uart_s_dte_rate[3]) 
    ,.uart3_PARITY_BIT_o (uart_s_parity_type[3]) 
    ,.uart3_STOP_BIT_o   (uart_s_char_format[3]) 
    ,.uart3_DATA_BITS_o  (uart_s_data_bits[3]) 

  );
  defparam u_usb_uart_config.ENDPT_UART_CONFIG = ENDPT_UART_CONFIG;

  //==============================================================
  //=====UART 
  genvar g_uart_id;
  for (g_uart_id = 1; g_uart_id <= num_uart_ports; g_uart_id = g_uart_id + 1) begin: GEN_UART 
    UART  #(
      .CLK_FREQ     (60000000)  // set system clock frequency in Hz
      //.BAUD_RATE    (115200  )  // baud rate value
    )u_UART1
    (
       .CLK        (PHY_CLKOUT     ) // clock
      ,.RST        (RESET_IN       ) // reset
      ,.UART_TXD   (UART_TXD[g_uart_id]       )
      ,.UART_RXD   (UART_RXD[g_uart_id]       )//
      ,.UART_RTS   () // when UART_RTS = 0, UART This Device Ready to receive.
      ,.UART_CTS   (1'b0) // when UART_CTS = 0, UART Opposite Device Ready to receive.
      ,.BAUD_RATE  (uart_s_dte_rate[g_uart_id]    )
      ,.PARITY_BIT (uart_s_parity_type[g_uart_id] )
      ,.STOP_BIT   (uart_s_char_format[g_uart_id] )
      ,.DATA_BITS  (uart_s_data_bits[g_uart_id]   )
      ,.TX_DATA    ({8'b0,uart_tx_data[g_uart_id]}    ) //
      ,.TX_DATA_VAL(uart_tx_data_val[g_uart_id]) // when TX_DATA_VAL = 1, data on TX_DATA will be transmit, DATA_SEND can set to 1 only when BUSY = 0
      ,.TX_BUSY    (uart_tx_busy[g_uart_id]    ) // when BUSY = 2 transiever is busy, you must not set DATA_SEND to 1
      ,.RX_DATA    (uart_rx_data[g_uart_id]    ) //
      ,.RX_DATA_VAL(uart_rx_data_val[g_uart_id]) //
    );
  end

  //==============================================================
  //======UART ctrl rx&tx
  usb_uart_ctrl u_usb_uart_ctrl
  (
    .PHY_CLKOUT         (PHY_CLKOUT)//clock
    ,.RESET_IN           (RESET_IN  )//reset

    ,.endpt_sel          (endpt_sel )//
    ,.usb_rxdat          (usb_rxdat)//
    ,.usb_rxval          (usb_rxval)//
    ,.usb_rxact          (usb_rxact  )//
    ,.usb_rxrdy_uart1    (usb_rxrdy_uart[1]  )//
    ,.usb_rxrdy_uart2    (usb_rxrdy_uart[2]  )//
    ,.usb_rxrdy_uart3    (usb_rxrdy_uart[3]  )//
    ,.rxpktval           (rxpktval)//
    ,.usb_txact          (usb_txact)//
    ,.usb_txpop          (usb_txpop)//

    ,.usb_txdat_uart1    (usb_txdat_uart[1])//
    ,.usb_txdat_len_uart1(usb_txdat_len_uart[1])//
    ,.usb_txcork_uart1   (usb_txcork_uart[1]  )//

    ,.usb_txdat_uart2    (usb_txdat_uart[2])//
    ,.usb_txdat_len_uart2(usb_txdat_len_uart[2])//
    ,.usb_txcork_uart2   (usb_txcork_uart[2]  )//

    ,.usb_txdat_uart3    (usb_txdat_uart[3])//
    ,.usb_txdat_len_uart3(usb_txdat_len_uart[3])//
    ,.usb_txcork_uart3   (usb_txcork_uart[3]  )//

    ,.uart1_tx_data_o    (uart_tx_data[1]    ) //
    ,.uart1_tx_data_val_o(uart_tx_data_val[1]) // when TX_DATA_VAL = 1, data on TX_DATA will be transmit, DATA_SEND can set to 1 only when BUSY = 0
    ,.uart1_tx_busy_i    (uart_tx_busy[1]    ) // when BUSY = 1 transiever is busy, you must not set DATA_SEND to 1
    ,.uart1_rx_data_i    (uart_rx_data[1][7:0]    ) //
    ,.uart1_rx_data_val_i(uart_rx_data_val[1]) //

    ,.uart2_tx_data_o    (uart_tx_data[2]    ) //
    ,.uart2_tx_data_val_o(uart_tx_data_val[2]) // when TX_DATA_VAL = 1, data on TX_DATA will be transmit, DATA_SEND can set to 1 only when BUSY = 0
    ,.uart2_tx_busy_i    (uart_tx_busy[2]    ) // when BUSY = 1 transiever is busy, you must not set DATA_SEND to 1
    ,.uart2_rx_data_i    (uart_rx_data[2][7:0]    ) //
    ,.uart2_rx_data_val_i(uart_rx_data_val[2]) //

    ,.uart3_tx_data_o    (uart_tx_data[3]    ) //
    ,.uart3_tx_data_val_o(uart_tx_data_val[3]) // when TX_DATA_VAL = 1, data on TX_DATA will be transmit, DATA_SEND can set to 1 only when BUSY = 0
    ,.uart3_tx_busy_i    (uart_tx_busy[3]    ) // when BUSY = 1 transiever is busy, you must not set DATA_SEND to 1
    ,.uart3_rx_data_i    (uart_rx_data[3][7:0]    ) //
    ,.uart3_rx_data_val_i(uart_rx_data_val[3]) //
  );

  defparam u_usb_uart_ctrl.ENDPT_UART1_DATA = ENDPT_UART1_DATA;
  defparam u_usb_uart_ctrl.ENDPT_UART2_DATA = ENDPT_UART2_DATA;
  defparam u_usb_uart_ctrl.ENDPT_UART3_DATA = ENDPT_UART3_DATA;

  //==============================================================
  //======i2c_ctrl
  usb_i2c_ctrl u_usb_i2c_ctrl
  (
    .clk_i          (PHY_CLKOUT  )//clock
    ,.reset_i        (RESET_IN    )//reset

    ,.usb_endpt_i    (endpt_sel)//

    ,.usb_rxdat_i    (usb_rxdat)//
    ,.usb_rxval_i    (usb_rxval)//
    ,.usb_rxact_i    (usb_rxact  )//
    ,.usb_rxrdy_i2c1_o    (usb_rxrdy_i2c[1])//
    ,.usb_rxrdy_i2c2_o    (usb_rxrdy_i2c[2])//
    ,.usb_rxrdy_i2c3_o    (usb_rxrdy_i2c[3])//
    ,.usb_rxrdy_i2c4_o    (usb_rxrdy_i2c[4])//
    ,.usb_rxpktval_i (rxpktval)//

    ,.usb_txact_i    (usb_txact)//
    ,.usb_txpop_i    (usb_txpop)//
    ,.usb_txdat_i2c1_o    (usb_txdat_i2c[1]  )//
    ,.usb_txdat_i2c2_o    (usb_txdat_i2c[2]  )//
    ,.usb_txdat_i2c3_o    (usb_txdat_i2c[3]  )//
    ,.usb_txdat_i2c4_o    (usb_txdat_i2c[4]  )//
    ,.usb_txdat_len_i2c1_o(usb_txdat_len_i2c[1]  )//
    ,.usb_txdat_len_i2c2_o(usb_txdat_len_i2c[2]  )//
    ,.usb_txdat_len_i2c3_o(usb_txdat_len_i2c[3]  )//
    ,.usb_txdat_len_i2c4_o(usb_txdat_len_i2c[4]  )//
    ,.usb_txcork_i2c1_o   (usb_txcork_i2c[1] )//
    ,.usb_txcork_i2c2_o   (usb_txcork_i2c[2] )//
    ,.usb_txcork_i2c3_o   (usb_txcork_i2c[3] )//
    ,.usb_txcork_i2c4_o   (usb_txcork_i2c[4] )//

    ,.i2c_paddr        (i2c_paddr      )
    ,.i2c_pwdata       (i2c_pwdata     )
    ,.i2c1_prdata      (i2c_prdata[1]     )
    ,.i2c2_prdata      (i2c_prdata[2]     )
    ,.i2c3_prdata      (i2c_prdata[3]     )
    ,.i2c4_prdata      (i2c_prdata[4]     )
    ,.i2c_pwrite       (i2c_pwrite     )
    ,.i2c_penable      (i2c_penable    )
    ,.i2c_psel         (i2c_psel       )

    ,.i2c1_rd       (i2c_rd[1]     )
    ,.i2c1_rx_data  (i2c_rx_data[1])
    ,.i2c1_rx_len   (i2c_rx_len[1][7:0])

    ,.i2c2_rd       (i2c_rd[2]     )
    ,.i2c2_rx_data  (i2c_rx_data[2])//
    ,.i2c2_rx_len   (i2c_rx_len[2][7:0])//

    ,.i2c3_rd       (i2c_rd[3]     )
    ,.i2c3_rx_data  (i2c_rx_data[3])//
    ,.i2c3_rx_len   (i2c_rx_len[3][7:0])//

    ,.i2c4_rd       (i2c_rd[4]     )
    ,.i2c4_rx_data  (i2c_rx_data[4])//
    ,.i2c4_rx_len   (i2c_rx_len[4][7:0])//

  );
  defparam u_usb_i2c_ctrl.ENDPT_I2C1 = ENDPT_I2C1;
  defparam u_usb_i2c_ctrl.ENDPT_I2C2 = ENDPT_I2C2;
  defparam u_usb_i2c_ctrl.ENDPT_I2C3 = ENDPT_I2C3;
  defparam u_usb_i2c_ctrl.ENDPT_I2C4 = ENDPT_I2C4;

  //==============================================================
  //======I2C
  genvar g_i2c_num;
  for(g_i2c_num = 1; g_i2c_num <= num_i2c_ports; g_i2c_num = g_i2c_num + 1) begin: GEN_I2C
    
     assign I2C_SCL[g_i2c_num] = i2c_scl_o[g_i2c_num] ? 1'bz : i2c_scl_o[g_i2c_num];
     assign I2C_SDA[g_i2c_num] = i2c_sda_o[g_i2c_num] ? 1'bz : i2c_sda_o[g_i2c_num];
     assign i2c_scl_i[g_i2c_num] = I2C_SCL[g_i2c_num];
     assign i2c_sda_i[g_i2c_num] = I2C_SDA[g_i2c_num];

     atciic100 u1_i2c 
    (
       .pclk    (PHY_CLKOUT   )
      ,.presetn (!RESET_IN    )
      ,.paddr   (i2c_paddr        )
      ,.penable (i2c_penable      )
      ,.prdata  (i2c_prdata[g_i2c_num]       )
      ,.pwdata  (i2c_pwdata       )
      ,.pwrite  (i2c_pwrite       )
      ,.psel    (i2c_psel[(u_ic-1)]      )
      ,.iic_rd  (i2c_rd[g_i2c_num]       )
      ,.rd_data (i2c_rx_data[g_i2c_num]  )
      ,.entries (i2c_rx_len[g_i2c_num]  )
      ,.dma_ack (1'b0         )
      ,.dma_req (             )
      ,.scl_o   (i2c_scl_o[g_i2c_num]        )
      ,.sda_o   (i2c_sda_o[g_i2c_num]        )
      ,.scl_i   (i2c_scl_i[g_i2c_num]        )
      ,.sda_i   (i2c_sda_i[g_i2c_num]        )
      ,.i2c_int (             )
    );
  end

  //==============================================================
  //======USB Controller 

  assign usb_rxrdy = (endpt_sel ==ENDPT_UART1_DATA) ? usb_rxrdy_uart[1]:
                     (endpt_sel ==ENDPT_UART2_DATA) ? usb_rxrdy_uart[2]:
                     (endpt_sel ==ENDPT_UART3_DATA) ? usb_rxrdy_uart[3]:
                     (endpt_sel ==ENDPT_I2C1) ? usb_rxrdy_i2c[1]:
                     (endpt_sel ==ENDPT_I2C2) ? usb_rxrdy_i2c[2]:
                     (endpt_sel ==ENDPT_I2C3) ? usb_rxrdy_i2c[3]:
                     (endpt_sel ==ENDPT_I2C4) ? usb_rxrdy_i2c[4]:
                     (endpt_sel ==ENDPT_PARALLEL)   ? usb_rxrdy_gpio :1'b0;


  assign usb_txcork =(endpt_sel ==ENDPT_UART_CONFIG) ? ~endpt0_send    :
                     (endpt_sel ==ENDPT_UART1_DATA)  ? usb_txcork_uart[1]:
                     (endpt_sel ==ENDPT_UART2_DATA)  ? usb_txcork_uart[2]:
                     (endpt_sel ==ENDPT_UART3_DATA)  ? usb_txcork_uart[3]: 
                     (endpt_sel ==ENDPT_I2C1) ? usb_txcork_i2c[1]:
                     (endpt_sel ==ENDPT_I2C2) ? usb_txcork_i2c[2]:
                     (endpt_sel ==ENDPT_I2C3) ? usb_txcork_i2c[3]:
                     (endpt_sel ==ENDPT_I2C4) ? usb_txcork_i2c[4]:1'b1;

  assign usb_txdat = (endpt_sel==ENDPT_UART_CONFIG) ? endpt0_dat :
                     (endpt_sel ==ENDPT_UART1_DATA)  ? usb_txdat_uart[1]:
                     (endpt_sel ==ENDPT_UART2_DATA)  ? usb_txdat_uart[2]:
                     (endpt_sel ==ENDPT_UART3_DATA)  ? usb_txdat_uart[3]: 
                     (endpt_sel ==ENDPT_I2C1) ? usb_txdat_i2c[1]:
                     (endpt_sel ==ENDPT_I2C2) ? usb_txdat_i2c[2]:
                     (endpt_sel ==ENDPT_I2C3) ? usb_txdat_i2c[3]:
                     (endpt_sel ==ENDPT_I2C4) ? usb_txdat_i2c[4]:8'd0;

  assign txdat_len = (endpt_sel ==ENDPT_UART_CONFIG) ? txdat_len_uart_config:
                     (endpt_sel ==ENDPT_UART1_DATA)  ? usb_txdat_len_uart[1]:
                     (endpt_sel ==ENDPT_UART2_DATA)  ? usb_txdat_len_uart[2]:
                     (endpt_sel ==ENDPT_UART3_DATA)  ? usb_txdat_len_uart[3]:
                     (endpt_sel ==ENDPT_I2C1) ? usb_txdat_len_i2c[1]:
                     (endpt_sel ==ENDPT_I2C2) ? usb_txdat_len_i2c[2]:
                     (endpt_sel ==ENDPT_I2C3) ? usb_txdat_len_i2c[3]:
                     (endpt_sel ==ENDPT_I2C4) ? usb_txdat_len_i2c[4]:12'h0;



  USB_Device_Controller_Top u_usb_device_controller_top (
     .clk_i                 (PHY_CLKOUT          )
    ,.reset_i               (RESET_IN            )
    ,.usbrst_o              (usb_busreset        )
    ,.highspeed_o           (usb_highspeed       )
    ,.suspend_o             (usb_suspend         )
    ,.online_o              (usb_online          )
    ,.txdat_i               (usb_txdat           )
    ,.txval_i               (endpt0_send&(endpt_sel==ENDPT_UART_CONFIG))//
    ,.txdat_len_i           (txdat_len           )
    ,.txcork_i              (usb_txcork          )
    ,.txpop_o               (usb_txpop           )
    ,.txact_o               (usb_txact           )
    ,.rxdat_o               (usb_rxdat           )
    ,.rxval_o               (usb_rxval           )
    ,.rxact_o               (usb_rxact           )
    ,.rxrdy_i               (usb_rxrdy           )
    ,.rxpktval_o            (rxpktval            )
    ,.setup_o               (setup_active        )
    ,.endpt_o               (endpt_sel           )
    ,.sof_o                 (usb_sof             )
    ,.descrom_rdata_i       (DESCROM_RDAT        )
    ,.descrom_raddr_o       (DESCROM_RADDR       )
    ,.desc_dev_addr_i       (DESC_DEV_ADDR       )
    ,.desc_dev_len_i        (DESC_DEV_LEN        )
    ,.desc_qual_addr_i      (DESC_QUAL_ADDR      )
    ,.desc_qual_len_i       (DESC_QUAL_LEN       )
    ,.desc_fscfg_addr_i     (DESC_FSCFG_ADDR     )
    ,.desc_fscfg_len_i      (DESC_FSCFG_LEN      )
    ,.desc_hscfg_addr_i     (DESC_HSCFG_ADDR     )
    ,.desc_hscfg_len_i      (DESC_HSCFG_LEN      )
    ,.desc_oscfg_addr_i     (DESC_OSCFG_ADDR     )
    ,.desc_strlang_addr_i   (DESC_STRLANG_ADDR   )
    ,.desc_strvendor_addr_i (DESC_STRVENDOR_ADDR )
    ,.desc_strvendor_len_i  (DESC_STRVENDOR_LEN  )
    ,.desc_strproduct_addr_i(DESC_STRPRODUCT_ADDR)
    ,.desc_strproduct_len_i (DESC_STRPRODUCT_LEN )
    ,.desc_strserial_addr_i (DESC_STRSERIAL_ADDR )
    ,.desc_strserial_len_i  (DESC_STRSERIAL_LEN  )
    ,.desc_have_strings_i   (DESCROM_HAVE_STRINGS)

    ,.utmi_dataout_o        (PHY_DATAOUT       )
    ,.utmi_txvalid_o        (PHY_TXVALID       )
    ,.utmi_txready_i        (PHY_TXREADY       )
    ,.utmi_datain_i         (PHY_DATAIN        )
    ,.utmi_rxactive_i       (PHY_RXACTIVE      )
    ,.utmi_rxvalid_i        (PHY_RXVALID       )
    ,.utmi_rxerror_i        (PHY_RXERROR       )
    ,.utmi_linestate_i      (PHY_LINESTATE     )
    ,.utmi_opmode_o         (PHY_OPMODE        )
    ,.utmi_xcvrselect_o     (PHY_XCVRSELECT    )
    ,.utmi_termselect_o     (PHY_TERMSELECT    )
    ,.utmi_reset_o          (               )
    ,.txiso_pid_i           ('d0            )
    ,.txpktfin_o            (           )
  );

  usb_desc
  #(

    .VENDORID    (16'h33AA)//0403   08bb
    //         ,.PRODUCTID   (16'h0020)//UART : 0020;I2C: 0120 /////////////////////////////////

    ,.PRODUCTID   (16'h0150)//6010   27c6
    ,.VERSIONBCD  (16'h0100)
    ,.HSSUPPORT   (1)
    ,.SELFPOWERED (1)
  )
  u_usb_desc (
    .CLK                    (PHY_CLKOUT          )
    ,.RESET                  (RESET_IN            )
    ,.i_descrom_raddr        (DESCROM_RADDR       )
    ,.o_descrom_rdat         (DESCROM_RDAT        )
    ,.o_desc_dev_addr        (DESC_DEV_ADDR       )
    ,.o_desc_dev_len         (DESC_DEV_LEN        )
    ,.o_desc_qual_addr       (DESC_QUAL_ADDR      )
    ,.o_desc_qual_len        (DESC_QUAL_LEN       )
    ,.o_desc_fscfg_addr      (DESC_FSCFG_ADDR     )
    ,.o_desc_fscfg_len       (DESC_FSCFG_LEN      )
    ,.o_desc_hscfg_addr      (DESC_HSCFG_ADDR     )
    ,.o_desc_hscfg_len       (DESC_HSCFG_LEN      )
    ,.o_desc_oscfg_addr      (DESC_OSCFG_ADDR     )
    ,.o_desc_strlang_addr    (DESC_STRLANG_ADDR   )
    ,.o_desc_strvendor_addr  (DESC_STRVENDOR_ADDR )
    ,.o_desc_strvendor_len   (DESC_STRVENDOR_LEN  )
    ,.o_desc_strproduct_addr (DESC_STRPRODUCT_ADDR)
    ,.o_desc_strproduct_len  (DESC_STRPRODUCT_LEN )
    ,.o_desc_strserial_addr  (DESC_STRSERIAL_ADDR )
    ,.o_desc_strserial_len   (DESC_STRSERIAL_LEN  )
    ,.o_descrom_have_strings (DESCROM_HAVE_STRINGS)
  );

  //==============================================================
  //======USB SoftPHY 
  USB2_0_SoftPHY_Top u_USB_SoftPHY_Top
  (
    .clk_i            (PHY_CLKOUT    )
    ,.rst_i            (RESET_IN      )
    ,.pll_locked_i     (lock_o    )

    ,.fclk_i           (fclk_480M)
    ,.utmi_data_out_i  (PHY_DATAOUT   )
    ,.utmi_txvalid_i   (PHY_TXVALID   )
    ,.utmi_op_mode_i   (PHY_OPMODE    )
    ,.utmi_xcvrselect_i(PHY_XCVRSELECT)
    ,.utmi_termselect_i(PHY_TERMSELECT)
    ,.utmi_data_in_o   (PHY_DATAIN    )
    ,.utmi_txready_o   (PHY_TXREADY   )
    ,.utmi_rxvalid_o   (PHY_RXVALID   )
    ,.utmi_rxactive_o  (PHY_RXACTIVE  )
    ,.utmi_rxerror_o   (PHY_RXERROR   )
    ,.utmi_linestate_o (PHY_LINESTATE )
    ,.usb_dxp_io       (usb_dxp_io   )
    ,.usb_dxn_io       (usb_dxn_io   )
    ,.usb_rxdp_i       (usb_rxdp_i   )
    ,.usb_rxdn_i       (usb_rxdn_i   )
    ,.usb_pullup_en_o  (usb_pullup_en_o)
    ,.usb_term_dp_io   (usb_term_dp_io)
    ,.usb_term_dn_io   (usb_term_dn_io)
  );

endmodule
