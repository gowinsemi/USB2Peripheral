/*
 * *****************************************************************************************
 *
 * 		Copyright (C) 2014-2022 Gowin Semiconductor Technology Co.,Ltd.
 *
 * @file		gw_usb2uart.c
 * @author		Embedded System R&D Department
 * @version		V1.0.0
 * @date		2021-12-01 09:00:00
 * @brief		Gowin USB2UART API.
 ******************************************************************************************
 */

/* Includes ------------------------------------------------------------------------------------------------------------- */
#include <stdio.h>
#include <stdlib.h>

#include "gw_usb2uart.h"


/* Definitions ------------------------------------------------------------------------------------------------------------- */
//#define USB2UART_INTERNAL_TEST


/* Functions ------------------------------------------------------------------------------------------------------------- */
//Set USB2UART configurations
DLLIMPORT int usb2uart_set_config(libusb_device_handle *devh, usb2uart_config_setting* pusb2uart_config, unsigned int uiTimeout)
{
    int rc = 0;

    //Check parameter validity
    if((devh == NULL) || (pusb2uart_config == NULL))
    {
        return LIBUSB_ERROR_INVALID_PARAM;
    }

    //config usb2uart
    //0x20 : SET_LINE_CODING
    rc = libusb_control_transfer (devh, 0b00100001, 0x20, 0, UART_INTERFACE, (unsigned char *)(pusb2uart_config), sizeof(*pusb2uart_config), uiTimeout);
    if(rc < 0)
    {
        printf("Error : %s\n", libusb_strerror(rc));
        return -1;
    }

#ifdef USB2UART_INTERNAL_TEST
    rc = print_usb2uart_config(pusb2uart_config);
    if(rc != 0)
    {
        return rc;
    }
#endif // USB2UART_INTERNAL_TEST

    return SUCCESS;
}

//Print USB2UART configurations
DLLIMPORT int print_usb2uart_config(usb2uart_config_setting* pusb2uart_config)
{
    //Check parameter validity
    if(pusb2uart_config == NULL)
    {
        return LIBUSB_ERROR_INVALID_PARAM;
    }

    printf("USB2UART configurations : \n");
    printf("BaudRate : %d\n", pusb2uart_config->BaudRate);
    printf("StopBits : %d\n", pusb2uart_config->StopBits);
    printf("Parity : %d\n", pusb2uart_config->Parity);
    printf("DataBits : %d\n", pusb2uart_config->DataBits);

    return SUCCESS;
}

//USB2UART send data synchronously
DLLIMPORT int usb2uart_send_data(libusb_device_handle *devh, int DataCnt, unsigned char *TransData,  unsigned int uiTimeout)
{
    int rc = 0;
    int size = 0;

    //Check parameter validity
    if(devh == NULL)
    {
        return LIBUSB_ERROR_INVALID_PARAM;
    }

    //send data through usb
    rc = libusb_bulk_transfer(devh, UART_ENDPOINT_OUT, TransData, DataCnt, &size, uiTimeout);
    if(rc != LIBUSB_SUCCESS)
    {
        printf("Error: %s\n", libusb_strerror(rc));
        return rc;
    }
    else
    {
        printf("UART send %d bytes data.\n", size);
        size = 0;
    }

    return SUCCESS;
}

//USB2UART receive data synchronously
DLLIMPORT int usbuart_receive_data(libusb_device_handle *devh, int *DataCnt, unsigned char* TransData, unsigned int uiTimeout)
{
    int rc = 0;

    //Check parameter validity
    if(devh == NULL)
    {
        return LIBUSB_ERROR_INVALID_PARAM;
    }

    //receive data through usb
    rc = libusb_bulk_transfer(devh, UART_ENDPOINT_IN, TransData, sizeof(TransData), DataCnt, uiTimeout);
    if(rc != LIBUSB_SUCCESS)
    {
        printf("Error: %s\n", libusb_strerror(rc));
        return rc;
    }
    else
    {
        printf("UART receive %d bytes data.\n", *DataCnt);
    }

    return SUCCESS;
}


//---------------------------------------------------------------------------------//

//USB2UART send/receive data asynchronously, please see reference design and document

//---------------------------------------------------------------------------------//
