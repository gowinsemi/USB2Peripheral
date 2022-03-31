/*
 * *****************************************************************************************
 *
 * 		Copyright (C) 2014-2022 Gowin Semiconductor Technology Co.,Ltd.
 *
 * @file	    gwusb_demo.h
 * @author		Embedded System R&D Department
 * @version		V1.0.0
 * @date		2021-12-01 09:00:00
 * @brief		Define parameters.
 ******************************************************************************************
 */

 #ifndef GWUSB_DEMO_H_
 #define GWUSB_DEMO_H_


/* Includes ---------------------------------------------------------------------------------------------------------- */
#include "define.h"


#if defined(__cplusplus)
extern "C" {
#endif

//Select to test which USB2I2C function
/* Config by user */
//#define I2C_CONFIG_SETTING_TEST     //test USB2I2C configuration settings
#define I2C_MASTER_WRITE_TEST       //test USB2I2C master write
//#define I2C_MASTER_READ_TEST      //test USB2I2C master read
//#define I2C_SLAVE_WRITE_TEST      //test USB2I2C slave write
//#define I2C_SLAVE_READ_TEST       //test USB2I2C slave read






//Internal definitions
#ifdef CHANNEL_I2C1_SELECTED
#define USB2IIC_TEST
#endif // CHANNEL_I2C1_SELECTED
#ifdef CHANNEL_I2C2_SELECTED
#define USB2IIC_TEST
#endif // CHANNEL_I2C2_SELECTED
#ifdef CHANNEL_I2C3_SELECTED
#define USB2IIC_TEST
#endif // CHANNEL_I2C3_SELECTED
#ifdef CHANNEL_I2C4_SELECTED
#define USB2IIC_TEST
#endif // CHANNEL_I2C4_SELECTED

#ifdef CHANNEL_UART1_SELECTED
#define USB2UART_TEST
#endif // CHANNEL_UART1_SELECTED
#ifdef CHANNEL_UART2_SELECTED
#define USB2UART_TEST
#endif // CHANNEL_UART2_SELECTED
#ifdef CHANNEL_UART3_SELECTED
#define USB2UART_TEST
#endif // CHANNEL_UART3_SELECTED

#ifdef CHANNEL_PARALLEL1_SELECTED
#define USB2PARALLEL_TEST
#endif // CHANNEL_PARALLEL1_SELECTED



#if defined(__cplusplus)
}
#endif

#endif
