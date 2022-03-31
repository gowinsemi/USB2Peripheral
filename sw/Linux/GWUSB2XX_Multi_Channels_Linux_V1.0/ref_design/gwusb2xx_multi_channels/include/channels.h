/*
 * *****************************************************************************************
 *
 * 		Copyright (C) 2014-2022 Gowin Semiconductor Technology Co.,Ltd.
 *
 * @file		channels.h
 * @author		Embedded System R&D Department
 * @version		V1.0.0
 * @date		2021-12-01 09:00:00
 * @brief		Channels.
 ******************************************************************************************
 */

#ifndef CHANNELS_H_
#define CHANNELS_H_


#if defined(__cplusplus)
extern "C" {
#endif


//Multi channels
//8 channels: I2C1, I2C2, I2C3, I2C4, UART1, UART2, UART3, Parallel
typedef enum {
    CH_I2C1       = 0x01,
    CH_I2C2       = 0x02,
    CH_I2C3       = 0x03,
    CH_I2C4       = 0x04,
    CH_UART1      = 0x05,
    CH_UART2      = 0x06,
    CH_UART3      = 0x07,
    CH_PARALLEL1  = 0x08

}ChannelType;


//Endpoint definitions
//I2C1
#define I2C1_USB_EP_IN          0x81
#define I2C1_USB_EP_OUT         0x01
//I2C2
#define I2C2_USB_EP_IN          0x82
#define I2C2_USB_EP_OUT         0x02
//I2C3
#define I2C3_USB_EP_IN          0x83
#define I2C3_USB_EP_OUT         0x03
//I2C4
#define I2C4_USB_EP_IN          0x84
#define I2C4_USB_EP_OUT         0x04
//UART1
#define UART1_USB_EP_IN         0x85
#define UART1_USB_EP_OUT        0x05
//UART2
#define UART2_USB_EP_IN         0x86
#define UART2_USB_EP_OUT        0x06
//UART3
#define UART3_USB_EP_IN         0x87
#define UART3_USB_EP_OUT        0x07
//Parallel
#define PARALLEL_USB_EP_OUT     0x08

//Interface definitions
#define I2C1_USB_INTERFACE		0			//channel I2C1 interface
#define I2C2_USB_INTERFACE		1			//channel I2C2 interface
#define I2C3_USB_INTERFACE		2			//channel I2C3 interface
#define I2C4_USB_INTERFACE		3			//channel I2C4 interface
#define UART1_USB_INTERFACE		4			//channel UART1	interface
#define UART2_USB_INTERFACE		5			//channel UART2 interface
#define UART3_USB_INTERFACE		6			//channel UART3 interface
#define PARALLEL_USB_INTERFACE	7			//channel Parallel interface

//ID definitions
#define VENDOR_ID				0x33AA		//Vendor ID
#define PRODUCT_ID				0x0150		//Product ID

//Error code
#define ERR_COUNT 20
enum gwusb_error_code {
	SUCCESS                    =  0,  /** Success (no error) */
	USB_ERROR_IO               = -1,  /** Input/output error */
	USB_ERROR_INVALID_PARAM    = -2,  /** Invalid parameter */
	USB_ERROR_ACCESS           = -3,  /** Access denied (insufficient permissions) */
	USB_ERROR_NO_DEVICE        = -4,  /** No such device (it may have been disconnected) */
	USB_ERROR_NOT_FOUND        = -5,  /** Entity not found */
	USB_ERROR_BUSY             = -6,  /** Resource busy */
	USB_ERROR_TIMEOUT          = -7,  /** Operation timed out */
	USB_ERROR_OVERFLOW         = -8,  /** Overflow */
	USB_ERROR_PIPE             = -9,  /** Pipe error */
	USB_ERROR_INTERRUPTED      = -10, /** System call interrupted (perhaps due to signal) */
	USB_ERROR_NO_MEM           = -11, /** Insufficient memory */
	USB_ERROR_NOT_SUPPORTED    = -12, /** Operation not supported or unimplemented on this platform */

	USB2IIC_ERR_SENDCMD_FAIL   = -13, /** USB2IIC send command fail*/
	USB2IIC_ERR_GETREG_FAIL    = -14, /** USB2IIC get iic registers fail*/
	USB2IIC_ERR_SETREG_FAIL    = -15, /** USB2IIC set iic registers fail*/
	USB2IIC_ERR_INVALID_PARAM  = -16, /** USB2IIC invalid timing parameter*/
	USB2IIC_ERR_TXDATA_FAIL    = -17, /** USB2IIC iic tx data fail*/
	USB2IIC_ERR_RXDATA_FAIL    = -18, /** USB2IIC iic rx data fail*/
	USB2IIC_ERR_CMPL_TIMEOUT   = -19, /** USB2IIC waiting complete timeout*/

	ERROR_OTHER = -99 /** Other error */
};


#if defined(__cplusplus)
}
#endif

#endif // CHANNELS_H_
