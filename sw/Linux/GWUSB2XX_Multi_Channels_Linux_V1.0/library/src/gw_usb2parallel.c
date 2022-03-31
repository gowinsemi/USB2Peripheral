/*
 * *****************************************************************************************
 *
 * 		Copyright (C) 2014-2022 Gowin Semiconductor Technology Co.,Ltd.
 *
 * @file		gw_usb2parallel.c
 * @author		Embedded System R&D Department
 * @version		V1.0.0
 * @date		2021-12-01 09:00:00
 * @brief		Gowin USB2Parallel API.
 ******************************************************************************************
 */

/* Includes ------------------------------------------------------------------------------------------------------------- */
#include <stdio.h>
#include <stdlib.h>
#include "gw_usb2parallel.h"


/* Definitions ------------------------------------------------------------------------------------------------------------- */
//#define USB2PARALLEL_INTERNAL_TEST
//#define PRINT_ENDPOINT


/* Declarations ------------------------------------------------------------------------------------------------------------- */
static int set_channel_endpoint(ChannelType ch, unsigned char* endpoint_out);
#ifdef PRINT_ENDPOINT
static void print_channel_endpoint(ChannelType ch, unsigned char endpoint_out);
#endif


/* Functions ------------------------------------------------------------------------------------------------------------- */
//USB2Parallel send data synchronously
DLLIMPORT int usb2parallel_send_data(libusb_device_handle *devh, ChannelType ch, int DataCnt, unsigned char *TransData,  unsigned int uiTimeout)
{
    int rc = 0;
    int size = 0;

    unsigned char endpoint_out;

    //Check parameter validity
    if(devh == NULL)
    {
        return LIBUSB_ERROR_INVALID_PARAM;
    }

    //Set endpoint out
    rc = set_channel_endpoint(ch, &endpoint_out);
    if(rc != SUCCESS)
    {
        return rc;
    }

#ifdef PRINT_ENDPOINT
    print_channel_type(ch, endpoint_out);
#endif // PRINT_ENDPOINT

    //send data through usb
    rc = libusb_bulk_transfer(devh, endpoint_out, TransData, DataCnt, &size, uiTimeout);
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

//Set channel endpoint
static int set_channel_endpoint(ChannelType ch, unsigned char* endpoint_out)
{
	int rc = SUCCESS;

	unsigned temp_endpoint_out = 0xFF;

	switch(ch)
	{
		case CH_PARALLEL1:
			temp_endpoint_out = PARALLEL_USB_EP_OUT;
			break;
		break;
		default:
			printf("Error : This is not a right parallel channel type.\n");
			rc = ERROR_OTHER;
			break;
	}

	if(endpoint_out != NULL)
	{
		*endpoint_out = temp_endpoint_out;
	}

	return rc;
}

#ifdef PRINT_ENDPOINT
//Print channel endpoint
static void print_channel_endpoint(ChannelType ch, unsigned char endpoint_out)
{
	printf("Channel type : 0x%x\n", ch);
    printf("Endpoint out : 0x%x\n", endpoint_out);
}
#endif
