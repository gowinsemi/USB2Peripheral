/*
 * *****************************************************************************************
 *
 * 		Copyright (C) 2014-2022 Gowin Semiconductor Technology Co.,Ltd.
 *
 * @file		gw_usb2iic.h
 * @author		Embedded System R&D Department
 * @version		V1.0.0
 * @date		2021-12-01 09:00:00
 * @brief		Gowin USB2IIC API.
 ******************************************************************************************
 */

#ifndef _GW_USB2IIC_H_
#define _GW_USB2IIC_H_


//Cross platform
#if defined(_WIN32) || defined(__CYGWIN__)
#ifndef DLLIMPORT
#define DLLIMPORT __declspec(dllexport)
#endif
#else
#define DLLIMPORT
#endif


/* Includes ------------------------------------------------------------------------------------------------------------- */
#include "libusb.h"
#include "channels.h"


/* Definitions ---------------------------------------------------------------------------------------------------------- */
// I2C mode: standard-mode, fast-mode, fast-mode-plus, all based on APB-clk(60MHZ)
// standard mode (100KHz)
#define SETUP_T_SUDAT_STD           (8)           // setup time = (two + 3 + 8) * (T_pm + 1) * 16.67ns + two * 16.67ns = 250ns
#define SETUP_T_SP_STD              (3)           // spikes time = 3 * (T_pm + 1) * 16.67ns = 50ns
#define SETUP_T_HDDAT_STD           (11)          // hold time = (two + 3 + 11) * (T_pm + 1) * 16.67ns + two * 16.67ns = 300ns
#define SETUP_T_SCL_RATIO_STD       (0)           // ratio=1, (two + 3 + 293) * (T_pm + 1) * 16.67ns + two * 16.67ns = 5000ns > 4000ns, for I2C SCL clock high period
// The T_SCLHi value must be greater than T_SP and T_HDDAT values.
#define SETUP_T_SCLHI_STD           (293)           // (two + 3 + 293 * 1) * (T_pm + 1) * 16.67ns + two * 16.67ns = 5000ns > 4700ns, for I2C SCL clock low period

//fast mode (400KHz)
#define SETUP_T_SUDAT_FAST          (2)           // setup time = (two + 3 + 2) * 16.67ns + two * 16.67ns = 150ns
#define SETUP_T_SP_FAST             (3)           // spikes time = 3 * 16.67ns = 50ns
#define SETUP_T_HDDAT_FAST          (11)          // hold time = (two + 3 + 11) * 16.67ns + two * 16.67ns = 300ns
#define SETUP_T_SCL_RATIO_FAST      (1)           // ratio=2, (two + 3 + 45) * 16.67ns + two * 16.67ns = 867ns >= 600ns, for I2C SCL clock high period
// The T_SCLHi value must be greater than T_SP and T_HDDAT values.
#define SETUP_T_SCLHI_FAST          (45)            // (two + 3 + 45 * 2) * 16.67ns + two * 16.67ns = 1617ns >= 1300ns, for I2C SCL clock low period

//fast mode plus (3400KHz)
#define SETUP_T_SUDAT_FAST_P        (2)           // setup time = (two + 3 + 2) * 16.67ns + two * 16.67ns = 150ns
#define SETUP_T_SP_FAST_P           (3)           // spikes time = 3 * 16.67ns = 50ns
#define SETUP_T_HDDAT_FAST_P        (2)           // hold time = (two + 3 + 2) * 16.67ns + two * 16.67ns = 150ns
#define SETUP_T_SCL_RATIO_FAST_P    (1)           // ratio=2, (two + 3 + 12) * 16.67ns + two * 16.67ns = 316.73ns >= 260ns, for I2C SCL clock high period
// The T_SCLHi value must be greater than T_SP and T_HDDAT values.
#define SETUP_T_SCLHI_FAST_P        (12)            // (two + 3 + 12 * 2) * 16.67ns + two * 16.67ns = 516.77ns >= 500ns, for I2C SCL clock low period

#if defined(__cplusplus)
extern "C" {
#endif

//USB2IIC configurations
typedef struct _USB2IIC_Config_ {
	unsigned int  SetupDat;
	unsigned int  SpikePulse;
	unsigned int  HoldDat;
	unsigned int  SclRatio;
	unsigned int  SclHi;
	unsigned int  TParam;
	unsigned int  Addr;
	unsigned char PhaseStart;
	unsigned char PhaseAddr;
	unsigned char PhaseData;
	unsigned char PhaseStop;
	unsigned char Dir;
	unsigned char DataCnt;
	unsigned char Master;
	unsigned char Addressing;
	unsigned char Cmd;
	unsigned char IICEnable;
} USB2IIC_Config;

//Direction setting in Control Register
typedef enum _I2C_CTRL_REG_ITEM_DIR_
{
	I2C_MASTER_TX = 0x0,
	I2C_MASTER_RX = 0x1,
	I2C_SLAVE_TX  = 0x1,
	I2C_SLAVE_RX  = 0x0,
}I2C_CTRL_REG_ITEM_DIR;


/* Declarations --------------------------------------------------------------------------------------------------*/
//Set(Write) USB2IIC configurations through usb
DLLIMPORT int iic_set_config(libusb_device_handle *devh, ChannelType ch, USB2IIC_Config *pusb2iic_config, unsigned int uiTimeout);

//Get(Read) USB2IIC configurations through usb
DLLIMPORT int iic_get_config(libusb_device_handle *devh, ChannelType ch, USB2IIC_Config *pusb2iic_config, unsigned int uiTimeout);

//Print USB2IIC configurations
DLLIMPORT int print_iic_config(USB2IIC_Config *pusb2iic_config);

//Reset USB2IIC device
DLLIMPORT int usb2iic_reset(libusb_device_handle *devh, ChannelType ch, unsigned int timeout);

//GW USB2IIC as master device, write data to slave device
DLLIMPORT int usb2iic_master_write(libusb_device_handle *devh, ChannelType ch, int DataCnt, unsigned char *TransData,  unsigned int uiTimeout);

//GW USB2IIC as master device, read data from slave device
DLLIMPORT int usb2iic_master_read(libusb_device_handle *devh, ChannelType ch, int DataCnt, unsigned char *RcvData, unsigned int uiTimeout);

//GW USB2IIC as slave device, write data to master device
DLLIMPORT int usb2iic_slave_write(libusb_device_handle *devh, ChannelType ch, int DataCnt, unsigned char *TransData, int *DataTransed, unsigned int uiTimeout);

//GW USB2IIC as slave device, read data from master device
DLLIMPORT int usb2iic_slave_read(libusb_device_handle *devh, ChannelType ch, unsigned char *RcvData, int *ptr_RcvDataBytes, unsigned int uiTimeout);


#if defined(__cplusplus)
}
#endif


#endif  //ifndef _GW_USB2IIC_H_
