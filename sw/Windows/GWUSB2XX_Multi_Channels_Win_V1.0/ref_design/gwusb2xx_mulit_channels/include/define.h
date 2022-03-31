/*
 * *****************************************************************************************
 *
 * 		Copyright (C) 2014-2022 Gowin Semiconductor Technology Co.,Ltd.
 *
 * @file	    define.h
 * @author		Embedded System R&D Department
 * @version		V1.0.0
 * @date		2021-12-01 09:00:00
 * @brief		Define parameters.
 ******************************************************************************************
 */

 #ifndef DEFINE_H_
 #define DEFINE_H_


#if defined(__cplusplus)
extern "C" {
#endif


/* Definitions ---------------------------------------------------------------------------------------------------------- */
//Select channels
//usb2iic channels
//#define CHANNEL_I2C1_SELECTED         //select channel USB2I2C1
//#define CHANNEL_I2C2_SELECTED         //select channel USB2I2C2
//#define CHANNEL_I2C3_SELECTED         //select channel USB2I2C3
//#define CHANNEL_I2C4_SELECTED         //select channel USB2I2C4

//usb2uart  channels
#define CHANNEL_UART1_SELECTED        //select channel USB2UART1
//#define CHANNEL_UART2_SELECTED        //select channel USB2UART2
//#define CHANNEL_UART3_SELECTED        //select channel USB2UART3

//usb2parallel channels
//#define CHANNEL_PARALLEL1_SELECTED    //select channel USB2Parallel


#if defined(__cplusplus)
}
#endif


#endif // DEFINE_H_
