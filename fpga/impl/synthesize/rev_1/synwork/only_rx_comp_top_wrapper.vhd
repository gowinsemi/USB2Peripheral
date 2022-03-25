--
-- Synopsys
-- Vhdl wrapper for top level design, written on Wed Jun 10 14:56:58 2020
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.usb_pkg.all;

entity wrapper_for_work_usb_serial_usb_serial_arch_0000100010111011_0010011111000110_0000000100000000_BurrBrown from Texas Instruments_USB AUDIO    DAC_false_false_10_10_1_VENDORIDPRODUCTIDVERSIONBCDHSSUPPORTSELFPOWEREDRXBUFSIZE_BITSTXBUFSIZE_BITS is
   port (
      CLK : in std_logic;
      RESET : in std_logic;
      USBRST : out std_logic;
      HIGHSPEED : out std_logic;
      SUSPEND : out std_logic;
      ONLINE : out std_logic;
      RXVAL : out std_logic;
      RXDAT : out std_logic_vector(7 downto 0);
      RXRDY : in std_logic;
      RXLEN : out std_logic_vector(9 downto 0);
      TXVAL : in std_logic;
      TXDAT : in std_logic_vector(7 downto 0);
      test : out std_logic_vector(9 downto 0);
      TXRDY : out std_logic;
      TXROOM : out std_logic_vector(9 downto 0);
      TXCORK : in std_logic;
      PHY_DATAIN : in std_logic_vector(7 downto 0);
      PHY_DATAOUT : out std_logic_vector(7 downto 0);
      PHY_TXVALID : out std_logic;
      PHY_TXREADY : in std_logic;
      PHY_RXACTIVE : in std_logic;
      PHY_RXVALID : in std_logic;
      PHY_RXERROR : in std_logic;
      PHY_LINESTATE : in std_logic_vector(1 downto 0);
      PHY_OPMODE : out std_logic_vector(1 downto 0);
      PHY_XCVRSELECT : out std_logic;
      PHY_TERMSELECT : out std_logic;
      PHY_RESET : out std_logic;
      IIS_RXBUFFER_WREN : out std_logic;
      IIS_RXBUFFER_DATA : out std_logic_vector(7 downto 0);
      IIS_WREND : out std_logic
   );
end wrapper_for_work_usb_serial_usb_serial_arch_0000100010111011_0010011111000110_0000000100000000_BurrBrown from Texas Instruments_USB AUDIO    DAC_false_false_10_10_1_VENDORIDPRODUCTIDVERSIONBCDHSSUPPORTSELFPOWEREDRXBUFSIZE_BITSTXBUFSIZE_BITS;

architecture usb_serial_arch of wrapper_for_work_usb_serial_usb_serial_arch_0000100010111011_0010011111000110_0000000100000000_BurrBrown from Texas Instruments_USB AUDIO    DAC_false_false_10_10_1_VENDORIDPRODUCTIDVERSIONBCDHSSUPPORTSELFPOWEREDRXBUFSIZE_BITSTXBUFSIZE_BITS is

component work_usb_serial_usb_serial_arch_0000100010111011_0010011111000110_0000000100000000_BurrBrown from Texas Instruments_USB AUDIO    DAC_false_false_10_10_1_VENDORIDPRODUCTIDVERSIONBCDHSSUPPORTSELFPOWEREDRXBUFSIZE_BITSTXBUFSIZE_BITS
 port (
   CLK : in std_logic;
   RESET : in std_logic;
   USBRST : out std_logic;
   HIGHSPEED : out std_logic;
   SUSPEND : out std_logic;
   ONLINE : out std_logic;
   RXVAL : out std_logic;
   RXDAT : out std_logic_vector (7 downto 0);
   RXRDY : in std_logic;
   RXLEN : out std_logic_vector (9 downto 0);
   TXVAL : in std_logic;
   TXDAT : in std_logic_vector (7 downto 0);
   test : out std_logic_vector (9 downto 0);
   TXRDY : out std_logic;
   TXROOM : out std_logic_vector (9 downto 0);
   TXCORK : in std_logic;
   PHY_DATAIN : in std_logic_vector (7 downto 0);
   PHY_DATAOUT : out std_logic_vector (7 downto 0);
   PHY_TXVALID : out std_logic;
   PHY_TXREADY : in std_logic;
   PHY_RXACTIVE : in std_logic;
   PHY_RXVALID : in std_logic;
   PHY_RXERROR : in std_logic;
   PHY_LINESTATE : in std_logic_vector (1 downto 0);
   PHY_OPMODE : out std_logic_vector (1 downto 0);
   PHY_XCVRSELECT : out std_logic;
   PHY_TERMSELECT : out std_logic;
   PHY_RESET : out std_logic;
   IIS_RXBUFFER_WREN : out std_logic;
   IIS_RXBUFFER_DATA : out std_logic_vector (7 downto 0);
   IIS_WREND : out std_logic
 );
end component;

signal tmp_CLK : std_logic;
signal tmp_RESET : std_logic;
signal tmp_USBRST : std_logic;
signal tmp_HIGHSPEED : std_logic;
signal tmp_SUSPEND : std_logic;
signal tmp_ONLINE : std_logic;
signal tmp_RXVAL : std_logic;
signal tmp_RXDAT : std_logic_vector (7 downto 0);
signal tmp_RXRDY : std_logic;
signal tmp_RXLEN : std_logic_vector (9 downto 0);
signal tmp_TXVAL : std_logic;
signal tmp_TXDAT : std_logic_vector (7 downto 0);
signal tmp_test : std_logic_vector (9 downto 0);
signal tmp_TXRDY : std_logic;
signal tmp_TXROOM : std_logic_vector (9 downto 0);
signal tmp_TXCORK : std_logic;
signal tmp_PHY_DATAIN : std_logic_vector (7 downto 0);
signal tmp_PHY_DATAOUT : std_logic_vector (7 downto 0);
signal tmp_PHY_TXVALID : std_logic;
signal tmp_PHY_TXREADY : std_logic;
signal tmp_PHY_RXACTIVE : std_logic;
signal tmp_PHY_RXVALID : std_logic;
signal tmp_PHY_RXERROR : std_logic;
signal tmp_PHY_LINESTATE : std_logic_vector (1 downto 0);
signal tmp_PHY_OPMODE : std_logic_vector (1 downto 0);
signal tmp_PHY_XCVRSELECT : std_logic;
signal tmp_PHY_TERMSELECT : std_logic;
signal tmp_PHY_RESET : std_logic;
signal tmp_IIS_RXBUFFER_WREN : std_logic;
signal tmp_IIS_RXBUFFER_DATA : std_logic_vector (7 downto 0);
signal tmp_IIS_WREND : std_logic;

begin

tmp_CLK <= CLK;

tmp_RESET <= RESET;

USBRST <= tmp_USBRST;

HIGHSPEED <= tmp_HIGHSPEED;

SUSPEND <= tmp_SUSPEND;

ONLINE <= tmp_ONLINE;

RXVAL <= tmp_RXVAL;

RXDAT <= tmp_RXDAT;

tmp_RXRDY <= RXRDY;

RXLEN <= tmp_RXLEN;

tmp_TXVAL <= TXVAL;

tmp_TXDAT <= TXDAT;

test <= tmp_test;

TXRDY <= tmp_TXRDY;

TXROOM <= tmp_TXROOM;

tmp_TXCORK <= TXCORK;

tmp_PHY_DATAIN <= PHY_DATAIN;

PHY_DATAOUT <= tmp_PHY_DATAOUT;

PHY_TXVALID <= tmp_PHY_TXVALID;

tmp_PHY_TXREADY <= PHY_TXREADY;

tmp_PHY_RXACTIVE <= PHY_RXACTIVE;

tmp_PHY_RXVALID <= PHY_RXVALID;

tmp_PHY_RXERROR <= PHY_RXERROR;

tmp_PHY_LINESTATE <= PHY_LINESTATE;

PHY_OPMODE <= tmp_PHY_OPMODE;

PHY_XCVRSELECT <= tmp_PHY_XCVRSELECT;

PHY_TERMSELECT <= tmp_PHY_TERMSELECT;

PHY_RESET <= tmp_PHY_RESET;

IIS_RXBUFFER_WREN <= tmp_IIS_RXBUFFER_WREN;

IIS_RXBUFFER_DATA <= tmp_IIS_RXBUFFER_DATA;

IIS_WREND <= tmp_IIS_WREND;



u1:   work_usb_serial_usb_serial_arch_0000100010111011_0010011111000110_0000000100000000_BurrBrown from Texas Instruments_USB AUDIO    DAC_false_false_10_10_1_VENDORIDPRODUCTIDVERSIONBCDHSSUPPORTSELFPOWEREDRXBUFSIZE_BITSTXBUFSIZE_BITS port map (
		CLK => tmp_CLK,
		RESET => tmp_RESET,
		USBRST => tmp_USBRST,
		HIGHSPEED => tmp_HIGHSPEED,
		SUSPEND => tmp_SUSPEND,
		ONLINE => tmp_ONLINE,
		RXVAL => tmp_RXVAL,
		RXDAT => tmp_RXDAT,
		RXRDY => tmp_RXRDY,
		RXLEN => tmp_RXLEN,
		TXVAL => tmp_TXVAL,
		TXDAT => tmp_TXDAT,
		test => tmp_test,
		TXRDY => tmp_TXRDY,
		TXROOM => tmp_TXROOM,
		TXCORK => tmp_TXCORK,
		PHY_DATAIN => tmp_PHY_DATAIN,
		PHY_DATAOUT => tmp_PHY_DATAOUT,
		PHY_TXVALID => tmp_PHY_TXVALID,
		PHY_TXREADY => tmp_PHY_TXREADY,
		PHY_RXACTIVE => tmp_PHY_RXACTIVE,
		PHY_RXVALID => tmp_PHY_RXVALID,
		PHY_RXERROR => tmp_PHY_RXERROR,
		PHY_LINESTATE => tmp_PHY_LINESTATE,
		PHY_OPMODE => tmp_PHY_OPMODE,
		PHY_XCVRSELECT => tmp_PHY_XCVRSELECT,
		PHY_TERMSELECT => tmp_PHY_TERMSELECT,
		PHY_RESET => tmp_PHY_RESET,
		IIS_RXBUFFER_WREN => tmp_IIS_RXBUFFER_WREN,
		IIS_RXBUFFER_DATA => tmp_IIS_RXBUFFER_DATA,
		IIS_WREND => tmp_IIS_WREND
       );
end usb_serial_arch;
