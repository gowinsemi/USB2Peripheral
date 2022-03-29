
module Top(
    input      wire CLK_IN,//50M

    output reg    LED,

    inout   wire I2C1_SCL,
    inout   wire I2C1_SDA,
    inout   wire I2C2_SCL,
    inout   wire I2C2_SDA,
    inout   wire I2C3_SCL,
    inout   wire I2C3_SDA,
    inout   wire I2C4_SCL,
    inout   wire I2C4_SDA,

    output  wire UART1_TXD,
    input   wire UART1_RXD,
    output  wire UART2_TXD,
    input   wire UART2_RXD,
    output  wire UART3_TXD,
    input   wire UART3_RXD,

    output wire [9:0]    PARALLEL_GPIO,

    inout   wire usb_dxp_io,
    inout   wire usb_dxn_io,
    input   wire usb_rxdp_i,
    input   wire usb_rxdn_i,
    output  wire usb_pullup_en_o,
    inout   wire usb_term_dp_io,
    inout   wire usb_term_dn_io
  );

  reg [31:0] cnt;

  wire        i2c1_scl_o;
  wire        i2c1_sda_o;
  wire        i2c1_scl_i;
  wire        i2c1_sda_i;
  wire        i2c2_scl_o;
  wire        i2c2_sda_o;
  wire        i2c2_scl_i;
  wire        i2c2_sda_i;
  wire        i2c3_scl_o;
  wire        i2c3_sda_o;
  wire        i2c3_scl_i;
  wire        i2c3_sda_i;
  wire        i2c4_scl_o;
  wire        i2c4_sda_o;
  wire        i2c4_scl_i;
  wire        i2c4_sda_i;

  wire [3:0] i2c_paddr;
  wire [31:0]i2c_pwdata;
  wire i2c_penable;
  wire i2c_pwrite;
  wire [3:0] i2c_psel;
  wire [31:0]i2c1_prdata;
  wire [31:0]i2c2_prdata;
  wire [31:0]i2c3_prdata;
  wire [31:0]i2c4_prdata;

  wire i2c1_rd;
  wire [7:0] i2c1_rx_data;
  wire [8:0] i2c1_rx_len;

  wire i2c2_rd;
  wire [7:0] i2c2_rx_data;
  wire [8:0] i2c2_rx_len;

  wire i2c3_rd;
  wire [7:0] i2c3_rx_data;
  wire [8:0] i2c3_rx_len;

  wire i2c4_rd;
  wire [7:0] i2c4_rx_data;
  wire [8:0] i2c4_rx_len;

  wire usb_rxrdy_i2c1;
  wire usb_rxrdy_i2c2;
  wire usb_rxrdy_i2c3;
  wire usb_rxrdy_i2c4;
  wire [7:0] usb_txdat_i2c1;
  wire [7:0] usb_txdat_i2c2;
  wire [7:0] usb_txdat_i2c3;
  wire [7:0] usb_txdat_i2c4;
  wire [11:0]usb_txdat_len_i2c1;
  wire [11:0]usb_txdat_len_i2c2;
  wire [11:0]usb_txdat_len_i2c3;
  wire [11:0]usb_txdat_len_i2c4;
  wire usb_txcork_i2c1;
  wire usb_txcork_i2c2;
  wire usb_txcork_i2c3;
  wire usb_txcork_i2c4;

  wire usb_rxrdy_uart1;
  wire usb_rxrdy_uart2;
  wire usb_rxrdy_uart3;

  wire [7:0] usb_txdat_uart1;
  wire [7:0] usb_txdat_uart2;
  wire [7:0] usb_txdat_uart3;
  wire [11:0]usb_txdat_len_uart1;
  wire [11:0]usb_txdat_len_uart2;
  wire [11:0]usb_txdat_len_uart3;
  wire usb_txcork_uart1;
  wire usb_txcork_uart2;
  wire usb_txcork_uart3;

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

  wire [31:0]uart1_s_dte_rate;
  wire [7:0] uart1_s_char_format;
  wire [7:0] uart1_s_parity_type;
  wire [7:0] uart1_s_data_bits;
  wire [31:0]uart2_s_dte_rate;
  wire [7:0] uart2_s_char_format;
  wire [7:0] uart2_s_parity_type;
  wire [7:0] uart2_s_data_bits;
  wire [31:0]uart3_s_dte_rate;
  wire [7:0] uart3_s_char_format;
  wire [7:0] uart3_s_parity_type;
  wire [7:0] uart3_s_data_bits;
  wire [11:0]txdat_len_uart_config;

  reg [7:0] rst_cnt = 0;
  wire usb_rxrdy_gpio;

  wire [7:0] uart1_tx_data    ;
  wire       uart1_tx_data_val;
  wire       uart1_tx_busy    ;
  wire [15:0] uart1_rx_data    ;
  wire       uart1_rx_data_val;
  wire [7:0] uart2_tx_data    ;
  wire       uart2_tx_data_val;
  wire       uart2_tx_busy    ;
  wire [15:0] uart2_rx_data    ;
  wire       uart2_rx_data_val;
  wire [7:0] uart3_tx_data    ;
  wire       uart3_tx_data_val;
  wire       uart3_tx_busy    ;
  wire [15:0] uart3_rx_data    ;
  wire       uart3_rx_data_val;


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

  //======LED
  always@(posedge PHY_CLKOUT) begin
    if (RESET_IN) begin
      LED <= 1'b0;
      cnt <= 32'd0;
    end
    else begin
      if (cnt >= 32'd60000000) begin
        cnt <= 32'd0;
      end
      else begin
        cnt <= cnt + 32'd1;
      end
      if (cnt == 32'd30000000) begin
        LED <= ~LED;
      end
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

    ,.uart1_BAUD_RATE_o  (uart1_s_dte_rate) 
    ,.uart1_PARITY_BIT_o (uart1_s_parity_type) 
    ,.uart1_STOP_BIT_o   (uart1_s_char_format) 
    ,.uart1_DATA_BITS_o  (uart1_s_data_bits) 
    ,.uart2_BAUD_RATE_o  (uart2_s_dte_rate) 
    ,.uart2_PARITY_BIT_o (uart2_s_parity_type) 
    ,.uart2_STOP_BIT_o   (uart2_s_char_format) 
    ,.uart2_DATA_BITS_o  (uart2_s_data_bits) 
    ,.uart3_BAUD_RATE_o  (uart3_s_dte_rate) 
    ,.uart3_PARITY_BIT_o (uart3_s_parity_type) 
    ,.uart3_STOP_BIT_o   (uart3_s_char_format) 
    ,.uart3_DATA_BITS_o  (uart3_s_data_bits) 

  );
  defparam u_usb_uart_config.ENDPT_UART_CONFIG = ENDPT_UART_CONFIG;

  //==============================================================
  //=====UART 
  UART  #(
    .CLK_FREQ     (60000000)  // set system clock frequency in Hz
    //.BAUD_RATE    (115200  )  // baud rate value
  )u_UART1
  (
    .CLK        (PHY_CLKOUT     ) // clock
    ,.RST        (RESET_IN       ) // reset
    ,.UART_TXD   (UART1_TXD       )
    ,.UART_RXD   (UART1_RXD       )//
    ,.UART_RTS   () // when UART_RTS = 0, UART This Device Ready to receive.
    ,.UART_CTS   (1'b0) // when UART_CTS = 0, UART Opposite Device Ready to receive.
    ,.BAUD_RATE  (uart1_s_dte_rate    )
    ,.PARITY_BIT (uart1_s_parity_type )
    ,.STOP_BIT   (uart1_s_char_format )
    ,.DATA_BITS  (uart1_s_data_bits   )
    ,.TX_DATA    ({8'b0,uart1_tx_data}    ) //
    ,.TX_DATA_VAL(uart1_tx_data_val) // when TX_DATA_VAL = 1, data on TX_DATA will be transmit, DATA_SEND can set to 1 only when BUSY = 0
    ,.TX_BUSY    (uart1_tx_busy    ) // when BUSY = 1 transiever is busy, you must not set DATA_SEND to 1
    ,.RX_DATA    (uart1_rx_data    ) //
    ,.RX_DATA_VAL(uart1_rx_data_val) //
  );

  UART  #(
    .CLK_FREQ     (60000000)  // set system clock frequency in Hz
    //.BAUD_RATE    (115200  )  // baud rate value
  )u_UART2
  (
    .CLK        (PHY_CLKOUT     ) // clock
    ,.RST        (RESET_IN       ) // reset
    ,.UART_TXD   (UART2_TXD       )
    ,.UART_RXD   (UART2_RXD       )//
    ,.UART_RTS   () // when UART_RTS = 0, UART This Device Ready to receive.
    ,.UART_CTS   (1'b0) // when UART_CTS = 0, UART Opposite Device Ready to receive.
    ,.BAUD_RATE  (uart2_s_dte_rate    )
    ,.PARITY_BIT (uart2_s_parity_type )
    ,.STOP_BIT   (uart2_s_char_format )
    ,.DATA_BITS  (uart2_s_data_bits   )
    ,.TX_DATA    ({8'b0,uart2_tx_data}    ) //
    ,.TX_DATA_VAL(uart2_tx_data_val) // when TX_DATA_VAL = 1, data on TX_DATA will be transmit, DATA_SEND can set to 1 only when BUSY = 0
    ,.TX_BUSY    (uart2_tx_busy    ) // when BUSY = 1 transiever is busy, you must not set DATA_SEND to 1
    ,.RX_DATA    (uart2_rx_data    ) //
    ,.RX_DATA_VAL(uart2_rx_data_val) //
  );

  UART  #(
    .CLK_FREQ     (60000000)  // set system clock frequency in Hz
    //.BAUD_RATE    (115200  )  // baud rate value
  )u_UART3
  (
    .CLK        (PHY_CLKOUT     ) // clock
    ,.RST        (RESET_IN       ) // reset
    ,.UART_TXD   (UART3_TXD       )
    ,.UART_RXD   (UART3_RXD       )//
    ,.UART_RTS   () // when UART_RTS = 0, UART This Device Ready to receive.
    ,.UART_CTS   (1'b0) // when UART_CTS = 0, UART Opposite Device Ready to receive.
    ,.BAUD_RATE  (uart3_s_dte_rate    )
    ,.PARITY_BIT (uart3_s_parity_type )
    ,.STOP_BIT   (uart3_s_char_format )
    ,.DATA_BITS  (uart3_s_data_bits   )
    ,.TX_DATA    ({8'b0,uart3_tx_data}    ) //
    ,.TX_DATA_VAL(uart3_tx_data_val) // when TX_DATA_VAL = 1, data on TX_DATA will be transmit, DATA_SEND can set to 1 only when BUSY = 0
    ,.TX_BUSY    (uart3_tx_busy    ) // when BUSY = 1 transiever is busy, you must not set DATA_SEND to 1
    ,.RX_DATA    (uart3_rx_data    ) //
    ,.RX_DATA_VAL(uart3_rx_data_val) //
  );

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
    ,.usb_rxrdy_uart1    (usb_rxrdy_uart1  )//
    ,.usb_rxrdy_uart2    (usb_rxrdy_uart2  )//
    ,.usb_rxrdy_uart3    (usb_rxrdy_uart3  )//
    ,.rxpktval           (rxpktval)//
    ,.usb_txact          (usb_txact)//
    ,.usb_txpop          (usb_txpop)//

    ,.usb_txdat_uart1    (usb_txdat_uart1)//
    ,.usb_txdat_len_uart1(usb_txdat_len_uart1)//
    ,.usb_txcork_uart1   (usb_txcork_uart1  )//

    ,.usb_txdat_uart2    (usb_txdat_uart2)//
    ,.usb_txdat_len_uart2(usb_txdat_len_uart2)//
    ,.usb_txcork_uart2   (usb_txcork_uart2  )//

    ,.usb_txdat_uart3    (usb_txdat_uart3)//
    ,.usb_txdat_len_uart3(usb_txdat_len_uart3)//
    ,.usb_txcork_uart3   (usb_txcork_uart3  )//

    ,.uart1_tx_data_o    (uart1_tx_data    ) //
    ,.uart1_tx_data_val_o(uart1_tx_data_val) // when TX_DATA_VAL = 1, data on TX_DATA will be transmit, DATA_SEND can set to 1 only when BUSY = 0
    ,.uart1_tx_busy_i    (uart1_tx_busy    ) // when BUSY = 1 transiever is busy, you must not set DATA_SEND to 1
    ,.uart1_rx_data_i    (uart1_rx_data[7:0]    ) //
    ,.uart1_rx_data_val_i(uart1_rx_data_val) //

    ,.uart2_tx_data_o    (uart2_tx_data    ) //
    ,.uart2_tx_data_val_o(uart2_tx_data_val) // when TX_DATA_VAL = 1, data on TX_DATA will be transmit, DATA_SEND can set to 1 only when BUSY = 0
    ,.uart2_tx_busy_i    (uart2_tx_busy    ) // when BUSY = 1 transiever is busy, you must not set DATA_SEND to 1
    ,.uart2_rx_data_i    (uart2_rx_data[7:0]    ) //
    ,.uart2_rx_data_val_i(uart2_rx_data_val) //

    ,.uart3_tx_data_o    (uart3_tx_data    ) //
    ,.uart3_tx_data_val_o(uart3_tx_data_val) // when TX_DATA_VAL = 1, data on TX_DATA will be transmit, DATA_SEND can set to 1 only when BUSY = 0
    ,.uart3_tx_busy_i    (uart3_tx_busy    ) // when BUSY = 1 transiever is busy, you must not set DATA_SEND to 1
    ,.uart3_rx_data_i    (uart3_rx_data[7:0]    ) //
    ,.uart3_rx_data_val_i(uart3_rx_data_val) //
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
    ,.usb_rxrdy_i2c1_o    (usb_rxrdy_i2c1)//
    ,.usb_rxrdy_i2c2_o    (usb_rxrdy_i2c2)//
    ,.usb_rxrdy_i2c3_o    (usb_rxrdy_i2c3)//
    ,.usb_rxrdy_i2c4_o    (usb_rxrdy_i2c4)//
    ,.usb_rxpktval_i (rxpktval)//

    ,.usb_txact_i    (usb_txact)//
    ,.usb_txpop_i    (usb_txpop)//
    ,.usb_txdat_i2c1_o    (usb_txdat_i2c1  )//
    ,.usb_txdat_i2c2_o    (usb_txdat_i2c2  )//
    ,.usb_txdat_i2c3_o    (usb_txdat_i2c3  )//
    ,.usb_txdat_i2c4_o    (usb_txdat_i2c4  )//
    ,.usb_txdat_len_i2c1_o(usb_txdat_len_i2c1  )//
    ,.usb_txdat_len_i2c2_o(usb_txdat_len_i2c2  )//
    ,.usb_txdat_len_i2c3_o(usb_txdat_len_i2c3  )//
    ,.usb_txdat_len_i2c4_o(usb_txdat_len_i2c4  )//
    ,.usb_txcork_i2c1_o   (usb_txcork_i2c1 )//
    ,.usb_txcork_i2c2_o   (usb_txcork_i2c2 )//
    ,.usb_txcork_i2c3_o   (usb_txcork_i2c3 )//
    ,.usb_txcork_i2c4_o   (usb_txcork_i2c4 )//

    ,.i2c_paddr        (i2c_paddr      )
    ,.i2c_pwdata       (i2c_pwdata     )
    ,.i2c1_prdata      (i2c1_prdata     )
    ,.i2c2_prdata      (i2c2_prdata     )
    ,.i2c3_prdata      (i2c3_prdata     )
    ,.i2c4_prdata      (i2c4_prdata     )
    ,.i2c_pwrite       (i2c_pwrite     )
    ,.i2c_penable      (i2c_penable    )
    ,.i2c_psel         (i2c_psel       )

    ,.i2c1_rd       (i2c1_rd     )
    ,.i2c1_rx_data  (i2c1_rx_data)
    ,.i2c1_rx_len   (i2c1_rx_len[7:0])

    ,.i2c2_rd       (i2c2_rd     )
    ,.i2c2_rx_data  (i2c2_rx_data)//
    ,.i2c2_rx_len   (i2c2_rx_len[7:0])//

    ,.i2c3_rd       (i2c3_rd     )
    ,.i2c3_rx_data  (i2c3_rx_data)//
    ,.i2c3_rx_len   (i2c3_rx_len[7:0])//

    ,.i2c4_rd       (i2c4_rd     )
    ,.i2c4_rx_data  (i2c4_rx_data)//
    ,.i2c4_rx_len   (i2c4_rx_len[7:0])//

  );
  defparam u_usb_i2c_ctrl.ENDPT_I2C1 = ENDPT_I2C1;
  defparam u_usb_i2c_ctrl.ENDPT_I2C2 = ENDPT_I2C2;
  defparam u_usb_i2c_ctrl.ENDPT_I2C3 = ENDPT_I2C3;
  defparam u_usb_i2c_ctrl.ENDPT_I2C4 = ENDPT_I2C4;

  //==============================================================
  //======I2C
  assign I2C1_SCL = i2c1_scl_o ? 1'bz : i2c1_scl_o;
  assign I2C1_SDA = i2c1_sda_o ? 1'bz : i2c1_sda_o;
  assign i2c1_scl_i = I2C1_SCL;
  assign i2c1_sda_i = I2C1_SDA;
  assign I2C2_SCL = i2c2_scl_o ? 1'bz : i2c2_scl_o;
  assign I2C2_SDA = i2c2_sda_o ? 1'bz : i2c2_sda_o;
  assign i2c2_scl_i = I2C2_SCL;
  assign i2c2_sda_i = I2C2_SDA;
  assign I2C3_SCL = i2c3_scl_o ? 1'bz : i2c3_scl_o;
  assign I2C3_SDA = i2c3_sda_o ? 1'bz : i2c3_sda_o;
  assign i2c3_scl_i = I2C3_SCL;
  assign i2c3_sda_i = I2C3_SDA;
  assign I2C4_SCL = i2c4_scl_o ? 1'bz : i2c4_scl_o;
  assign I2C4_SDA = i2c4_sda_o ? 1'bz : i2c4_sda_o;
  assign i2c4_scl_i = I2C4_SCL;
  assign i2c4_sda_i = I2C4_SDA;


  atciic100 u1_i2c 
  (
    .pclk    (PHY_CLKOUT   )
    ,.presetn (!RESET_IN    )
    ,.paddr   (i2c_paddr        )
    ,.penable (i2c_penable      )
    ,.prdata  (i2c1_prdata       )
    ,.pwdata  (i2c_pwdata       )
    ,.pwrite  (i2c_pwrite       )
    ,.psel    (i2c_psel[0]      )
    ,.iic_rd  (i2c1_rd       )
    ,.rd_data (i2c1_rx_data  )
    ,.entries (i2c1_rx_len  )
    ,.dma_ack (1'b0         )
    ,.dma_req (             )
    ,.scl_o   (i2c1_scl_o        )
    ,.sda_o   (i2c1_sda_o        )
    ,.scl_i   (i2c1_scl_i        )
    ,.sda_i   (i2c1_sda_i        )
    ,.i2c_int (             )
  );

  atciic100 u2_i2c 
  (
    .pclk    (PHY_CLKOUT   )
    ,.presetn (!RESET_IN    )
    ,.paddr   (i2c_paddr        )
    ,.penable (i2c_penable      )
    ,.prdata  (i2c2_prdata       )
    ,.pwdata  (i2c_pwdata       )
    ,.pwrite  (i2c_pwrite       )
    ,.psel    (i2c_psel[1]      )
    ,.iic_rd  (i2c2_rd       )
    ,.rd_data (i2c2_rx_data  )
    ,.entries (i2c2_rx_len  )
    ,.dma_ack (1'b0         )
    ,.dma_req (             )
    ,.scl_o   (i2c2_scl_o        )
    ,.sda_o   (i2c2_sda_o        )
    ,.scl_i   (i2c2_scl_i        )
    ,.sda_i   (i2c2_sda_i        )
    ,.i2c_int (             )
  );
  atciic100 u3_i2c 
  (
    .pclk    (PHY_CLKOUT   )
    ,.presetn (!RESET_IN    )
    ,.paddr   (i2c_paddr        )
    ,.penable (i2c_penable      )
    ,.prdata  (i2c3_prdata       )
    ,.pwdata  (i2c_pwdata       )
    ,.pwrite  (i2c_pwrite       )
    ,.psel    (i2c_psel[2]      )
    ,.iic_rd  (i2c3_rd       )
    ,.rd_data (i2c3_rx_data  )
    ,.entries (i2c3_rx_len  )
    ,.dma_ack (1'b0         )
    ,.dma_req (             )
    ,.scl_o   (i2c3_scl_o        )
    ,.sda_o   (i2c3_sda_o        )
    ,.scl_i   (i2c3_scl_i        )
    ,.sda_i   (i2c3_sda_i        )
    ,.i2c_int (             )
  );
  atciic100 u4_i2c 
  (
    .pclk    (PHY_CLKOUT   )
    ,.presetn (!RESET_IN    )
    ,.paddr   (i2c_paddr        )
    ,.penable (i2c_penable      )
    ,.prdata  (i2c4_prdata       )
    ,.pwdata  (i2c_pwdata       )
    ,.pwrite  (i2c_pwrite       )
    ,.psel    (i2c_psel[3]      )
    ,.iic_rd  (i2c4_rd       )
    ,.rd_data (i2c4_rx_data  )
    ,.entries (i2c4_rx_len  )
    ,.dma_ack (1'b0         )
    ,.dma_req (             )
    ,.scl_o   (i2c4_scl_o        )
    ,.sda_o   (i2c4_sda_o        )
    ,.scl_i   (i2c4_scl_i        )
    ,.sda_i   (i2c4_sda_i        )
    ,.i2c_int (             )
  );

  //==============================================================
  //======USB Controller 

  assign usb_rxrdy = (endpt_sel ==ENDPT_UART1_DATA) ? usb_rxrdy_uart1:
  (endpt_sel ==ENDPT_UART2_DATA) ? usb_rxrdy_uart2:
  (endpt_sel ==ENDPT_UART3_DATA) ? usb_rxrdy_uart3:
  (endpt_sel ==ENDPT_I2C1) ? usb_rxrdy_i2c1:
  (endpt_sel ==ENDPT_I2C2) ? usb_rxrdy_i2c2:
  (endpt_sel ==ENDPT_I2C3) ? usb_rxrdy_i2c3:
  (endpt_sel ==ENDPT_I2C4) ? usb_rxrdy_i2c4:
  (endpt_sel ==ENDPT_PARALLEL)   ? usb_rxrdy_gpio :1'b0;


  assign usb_txcork =(endpt_sel ==ENDPT_UART_CONFIG) ? ~endpt0_send    :
  (endpt_sel ==ENDPT_UART1_DATA)  ? usb_txcork_uart1:
  (endpt_sel ==ENDPT_UART2_DATA)  ? usb_txcork_uart2:
  (endpt_sel ==ENDPT_UART3_DATA)  ? usb_txcork_uart3: 
  (endpt_sel ==ENDPT_I2C1) ? usb_txcork_i2c1:
  (endpt_sel ==ENDPT_I2C2) ? usb_txcork_i2c2:
  (endpt_sel ==ENDPT_I2C3) ? usb_txcork_i2c3:
  (endpt_sel ==ENDPT_I2C4) ? usb_txcork_i2c4:1'b1;

  assign usb_txdat = (endpt_sel==ENDPT_UART_CONFIG) ? endpt0_dat :
  (endpt_sel ==ENDPT_UART1_DATA)  ? usb_txdat_uart1:
  (endpt_sel ==ENDPT_UART2_DATA)  ? usb_txdat_uart2:
  (endpt_sel ==ENDPT_UART3_DATA)  ? usb_txdat_uart3: 
  (endpt_sel ==ENDPT_I2C1) ? usb_txdat_i2c1:
  (endpt_sel ==ENDPT_I2C2) ? usb_txdat_i2c2:
  (endpt_sel ==ENDPT_I2C3) ? usb_txdat_i2c3:
  (endpt_sel ==ENDPT_I2C4) ? usb_txdat_i2c4:8'd0;

  assign txdat_len = (endpt_sel ==ENDPT_UART_CONFIG) ? txdat_len_uart_config:
  (endpt_sel ==ENDPT_UART1_DATA)  ? usb_txdat_len_uart1:
  (endpt_sel ==ENDPT_UART2_DATA)  ? usb_txdat_len_uart2:
  (endpt_sel ==ENDPT_UART3_DATA)  ? usb_txdat_len_uart3:
  (endpt_sel ==ENDPT_I2C1) ? usb_txdat_len_i2c1:
  (endpt_sel ==ENDPT_I2C2) ? usb_txdat_len_i2c2:
  (endpt_sel ==ENDPT_I2C3) ? usb_txdat_len_i2c3:
  (endpt_sel ==ENDPT_I2C4) ? usb_txdat_len_i2c4:12'h0;



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
