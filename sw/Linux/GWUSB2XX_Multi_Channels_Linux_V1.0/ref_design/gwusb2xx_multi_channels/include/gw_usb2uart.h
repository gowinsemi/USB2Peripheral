/*
 * *****************************************************************************************
 *
 * 		Copyright (C) 2014-2022 Gowin Semiconductor Technology Co.,Ltd.
 *
 * @file		gw_usb2uart.h
 * @author		Embedded System R&D Department
 * @version		V1.0.0
 * @date		2021-12-01 09:00:00
 * @brief		Gowin USB2UART API.
 ******************************************************************************************
 */

#ifndef GW_USB2UART_H_
#define GW_USB2UART_H_


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
#include "define.h"
#include "channels.h"

#if defined(__cplusplus)
extern "C" {
#endif


/* Definitions ------------------------------------------------------------------------------------------------------------- */
//Stop bits
#define STOPBITS_1    0			//1
#define STOPBITS_1_5  1			//1.5
#define STOPBITS_2    2			//2

//Parity
#define GW_PARITY_NONE   0		//none
#define GW_PARITY_ODD    1		//odd
#define GW_PARITY_EVEN   2		//even
#define GW_PARITY_MARK   3
#define GW_PARITY_SPACE  4

#define PACK_SIZE   64

//USB2UART configurations
typedef struct _usb2uart_config_setting {
	unsigned int  BaudRate;		//baud rate
	unsigned char StopBits;		//stop bits
	unsigned char Parity;		//parity
	unsigned char DataBits;		//data bits
} usb2uart_config_setting;



#ifdef CHANNEL_UART1_SELECTED
#define UART_ENDPOINT_IN    UART1_USB_EP_IN
#define UART_ENDPOINT_OUT   UART1_USB_EP_OUT
#define UART_INTERFACE      UART1_USB_INTERFACE
#define CH_UART             CH_UART1
#define CHANNEL_UART_FLAG
#endif
#ifdef CHANNEL_UART2_SELECTED
#define UART_ENDPOINT_IN    UART2_USB_EP_IN
#define UART_ENDPOINT_OUT   UART2_USB_EP_OUT
#define UART_INTERFACE      UART2_USB_INTERFACE
#define CH_UART             CH_UART2
#define CHANNEL_UART_FLAG
#endif
#ifdef CHANNEL_UART3_SELECTED
#define UART_ENDPOINT_IN    UART3_USB_EP_IN
#define UART_ENDPOINT_OUT   UART3_USB_EP_OUT
#define UART_INTERFACE      UART3_USB_INTERFACE
#define CH_UART             CH_UART3
#define CHANNEL_UART_FLAG
#endif

#ifndef CHANNEL_UART_FLAG
#define UART_ENDPOINT_IN    UART1_USB_EP_IN
#define UART_ENDPOINT_OUT   UART1_USB_EP_OUT
#define UART_INTERFACE      UART1_USB_INTERFACE
#define CH_UART             CH_UART1
#endif



/* Declarations ------------------------------------------------------------------------------------------------------------- */
//Set USB2UART configurations
DLLIMPORT int usb2uart_set_config(libusb_device_handle *devh, usb2uart_config_setting* pusb2uart_config, unsigned int uiTimeout);

//Print USB2UART configurations
DLLIMPORT int print_usb2uart_config(usb2uart_config_setting* pusb2uart_config);

//USB2UART send data synchronously
DLLIMPORT int usb2uart_send_data(libusb_device_handle *devh, int DataCnt, unsigned char *TransData,  unsigned int uiTimeout);

//USB2UART receive data synchronously
DLLIMPORT int usbuart_receive_data(libusb_device_handle *devh, int *DataCnt, unsigned char* TransData, unsigned int uiTimeout);


//USB2UART send/receive data asynchronously, please see reference design and document


#if defined(__cplusplus)
}
#endif

#endif // GW_USB2UART_H_
