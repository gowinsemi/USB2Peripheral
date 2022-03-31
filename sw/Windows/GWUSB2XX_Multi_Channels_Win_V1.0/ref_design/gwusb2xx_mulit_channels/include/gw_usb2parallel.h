/*
 * *****************************************************************************************
 *
 * 		Copyright (C) 2014-2022 Gowin Semiconductor Technology Co.,Ltd.
 *
 * @file		gw_usb2parallel.h
 * @author		Embedded System R&D Department
 * @version		V1.0.0
 * @date		2021-12-01 09:00:00
 * @brief		Gowin USB2Parallel API.
 ******************************************************************************************
 */

#ifndef GW_USB2PARALLEL_H_
#define GW_USB2PARALLEL_H_


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

#if defined(__cplusplus)
extern "C" {
#endif

/* Definitions ------------------------------------------------------------------------------------------------------------- */


/* Declarations ------------------------------------------------------------------------------------------------------------- */
//USB2Parallel send data
DLLIMPORT int usb2parallel_send_data(libusb_device_handle *devh, ChannelType ch, int DataCnt, unsigned char *TransData,  unsigned int uiTimeout);


#if defined(__cplusplus)
}
#endif

#endif // GW_USB2PARALLEL_H_
