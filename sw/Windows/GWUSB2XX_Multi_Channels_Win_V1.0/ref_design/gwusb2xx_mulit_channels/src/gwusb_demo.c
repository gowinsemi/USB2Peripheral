
/*
 * *********************************************************************************************
 *
 * 		Copyright (C) 2014-2022 Gowin Semiconductor Technology Co.,Ltd.
 *
 * @file        main.c
 * @author      Embedded System R&D Department
 * @version     V1.0.0
 * @date        2021-12-01 09:00:00
 * @brief       GWU2U uart API
 ***********************************************************************************************
 */

/* Includes ------------------------------------------------------------------------------------------------------------- */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#include "libusb.h"
#include "gw_usb2uart.h"
#include "gw_usb2iic.h"
#include "gw_usb2parallel.h"
#include "gwusb_demo.h"


/* Definitions ------------------------------------------------------------------------------------------------------------- */
static struct libusb_device_handle *devh = NULL;


//----------- USB2UART ----------//
#ifdef USB2UART_TEST
unsigned char tx_data[] = "this is a usb2uart test string sent through usb...\r\n";
unsigned int rd_cnt = 0;
usb2uart_config_setting usb2uart_config;
#endif // USB2UART_TEST

//----------- USB2IIC ----------//
#ifdef USB2IIC_TEST
static USB2IIC_Config  usb2iic_config;
USB2IIC_Config *pusb2iic_config = &usb2iic_config;

unsigned char WData[20] = {1,2,3,4,5,6,7,8,9,10,11,12, 13, 14, 15, 16, 17, 18, 19, 20};
unsigned char RData[256];
#endif // USB2IIC_TEST

//----------- USB2PARALLEL -----------//
#ifdef USB2PARALLEL_TEST
unsigned char tx_pdata[20] = {1,2,3,4,5,6,7,8,9,10,11,12, 13, 14, 15, 16, 17, 18, 19, 20};
#endif // USB2PARALLEL_TEST




/* Declarations --------------------------------------------------------------------------------------------------------- */
//usb2iic test
#ifdef USB2IIC_TEST
int usb2iic_test(libusb_device_handle *devh, USB2IIC_Config *pusb2iic_config);
#ifdef I2C_CONFIG_SETTING_TEST
int iic_config_set_test(libusb_device_handle *devh, ChannelType ch, USB2IIC_Config *pusb2iic_config);
#endif // I2C_CONFIG_SETTING_TEST
#ifdef I2C_MASTER_WRITE_TEST
int iic_master_write_test(libusb_device_handle *devh, ChannelType ch, USB2IIC_Config *pusb2iic_config);
#endif // I2C_MASTER_WRITE_TEST
#ifdef I2C_MASTER_READ_TEST
int iic_master_read_test(libusb_device_handle *devh, ChannelType ch, USB2IIC_Config *pusb2iic_config);
#endif // I2C_MASTER_READ_TEST
#ifdef I2C_SLAVE_WRITE_TEST
int iic_slave_write_test(libusb_device_handle *devh, ChannelType ch, USB2IIC_Config *pusb2iic_config);
#endif // I2C_SLAVE_WRITE_TEST
#ifdef I2C_SLAVE_READ_TEST
int iic_slave_read_test(libusb_device_handle *devh, ChannelType ch, USB2IIC_Config *pusb2iic_config);
#endif // I2C_SLAVE_READ_TEST
#endif // USB2IIC_TEST

//usb2uart test
#ifdef USB2UART_TEST
int usb2uart_test();
#endif // USB2UART_TEST

//usb2parallel test
#ifdef USB2PARALLEL_TEST
int usb2parallel_test();
#endif // USB2PARALLEL_TEST

void print_channel_type(ChannelType ch, int interface_number);





/* Functions ------------------------------------------------------------------------------------------------------------- */

// ---------------------------------------- USB2UART ----------------------------------------//
#ifdef USB2UART_TEST

//Call back funtions of asynchronous received, output to console by string
void LIBUSB_CALL cb_xfr_in(struct libusb_transfer *xfr)
{
	int i;

	rd_cnt++;

	if (xfr->status != LIBUSB_TRANSFER_COMPLETED)
    {
		fprintf(stderr, "transfer status %d\n", xfr->status);
		libusb_free_transfer(xfr);
		exit(3);
	}

	for (i = 0; i < xfr->actual_length; i++)
    {
		printf("%c", xfr->buffer[i]);
	}

     //After received data this time, request to transmit again, and wait next event
	if(libusb_submit_transfer(xfr) < 0)
	{
		libusb_free_transfer(xfr);
	}
}

static int benchmark_in(uint8_t ep)
{
	static uint8_t buf[PACK_SIZE];
	static struct libusb_transfer *xfr;

	printf("(SUBMIT FUNC) Starting a new asynchronous bulk transfer\n");
	printf("Received data :\n");

	xfr = libusb_alloc_transfer(0);
	if (!xfr)
    {
		return -ENOMEM;
	}

	libusb_fill_bulk_transfer (
		xfr,
		devh,
		ep,
		buf,
		sizeof(buf),
		cb_xfr_in,
		NULL,
		0
	);

	return libusb_submit_transfer(xfr);
}

//Test USB2UART
int usb2uart_test()
{
    int rc = 0;

    rc = libusb_claim_interface(devh, UART_INTERFACE);
	if (rc != LIBUSB_SUCCESS)
    {
		printf("Error claiming interface: %s\n", libusb_error_name(rc));
		return rc;
	}
	else
    {
        printf("Claiming interface\n");
    }

	printf("DEVICE READY...\n\n");

	print_channel_type(CH_UART, UART_INTERFACE);

	//Configurations settings
	usb2uart_config.BaudRate  = 115200;
	usb2uart_config.Parity    = GW_PARITY_NONE;
	usb2uart_config.StopBits  = STOPBITS_1;
	usb2uart_config.DataBits  = 8;

	//Set configurations
	rc = usb2uart_set_config(devh, &usb2uart_config, 0);
	if(rc != SUCCESS)
	{
		printf("Error: %s", libusb_strerror(rc));
		return -1;
	}

    //Send data synchronously
	rc = usb2uart_send_data(devh, sizeof(tx_data), tx_data,  1000);
	if(rc != SUCCESS)
    {
		printf("Error: %s", libusb_strerror(rc));
	}
	else
	{
		printf("Send %d bytes, return code : %d\n", (int)sizeof(tx_data), rc);
	}

	benchmark_in(UART_ENDPOINT_IN);

	while(1)
    {
		rc = libusb_handle_events(NULL);
	}

	libusb_release_interface(devh, UART_INTERFACE);

    return SUCCESS;
}
#endif // USB2UART_TEST
// ---------------------------------------- USB2UART ----------------------------------------//



// ---------------------------------------- USB2I2C ----------------------------------------//
#ifdef USB2IIC_TEST

//usb2iic test
int usb2iic_test(libusb_device_handle *devh, USB2IIC_Config *pusb2iic_config)
{
    int rc = 0;

    ChannelType ch;
    int interface_number;

    //Select I2C channel and interface
#ifdef CHANNEL_I2C1_SELECTED
    ch = CH_I2C1;
    interface_number = I2C1_USB_INTERFACE;
#endif // CHANNEL_I2C1_SELECTED
#ifdef CHANNEL_I2C2_SELECTED
    ch = CH_I2C2;
    interface_number = I2C2_USB_INTERFACE;
#endif // CHANNEL_I2C2_SELECTED
#ifdef CHANNEL_I2C3_SELECTED
    ch = CH_I2C3;
    interface_number = I2C3_USB_INTERFACE;
#endif // CHANNEL_I2C3_SELECTED
#ifdef CHANNEL_I2C4_SELECTED
    ch = CH_I2C4;
    interface_number = I2C4_USB_INTERFACE;
#endif // CHANNEL_I2C4_SELECTED

    print_channel_type(ch, interface_number);

    //Claim interface
    rc = libusb_claim_interface(devh, interface_number);
	if (rc != SUCCESS)
	{
		printf("Error claiming interface %d : %s\n", interface_number, libusb_error_name(rc));
		return rc;
	}
	else
    {
        printf("Claiming interface successfully.\n");
    }

    printf("\nDEVICE READY...\n\n");

#ifdef I2C_CONFIG_SETTING_TEST
    //Test configurations setting
    rc = iic_config_set_test(devh, ch, pusb2iic_config);
    if(rc != SUCCESS)
    {
        goto out;
    }
#endif // I2C_CONFIG_SETTING_TEST

    //Run USB2IIC, then PC read data in Software "USB2XXX"(test box)
	//test box is slave
#ifdef I2C_MASTER_WRITE_TEST
	rc = iic_master_write_test(devh, ch, pusb2iic_config);
	if(rc != SUCCESS)
    {
        goto out;
    }
#endif // I2C_MASTER_WRITE_TEST

#ifdef I2C_MASTER_READ_TEST
	//PC write data in Software "USB2XXX"(test box), then run USB2IIC
	// test box is slave
    rc = iic_master_read_test(devh, ch, pusb2iic_config);
    if(rc != SUCCESS)
    {
        goto out;
    }
#endif // I2C_MASTER_READ_TEST

#ifdef I2C_SLAVE_WRITE_TEST
	//Run USB2IIC, then PC read data in Software "USB2XXX"(test box)
	//test box is master
	rc = iic_slave_write_test(devh, ch, pusb2iic_config);
	if(rc != SUCCESS)
    {
        goto out;
    }
#endif // I2C_SLAVE_WRITE_TEST

#ifdef I2C_SLAVE_READ_TEST
	//Run USB2IIC, then PC write data in Software "USB2XXX"(test box)
	//test box is master
	rc = iic_slave_read_test(devh, ch, pusb2iic_config);
	if(rc != SUCCESS)
    {
        goto out;
    }
#endif // I2C_SLAVE_READ_TEST

out:
	libusb_release_interface(devh, interface_number);

    return rc;
}


#ifdef I2C_CONFIG_SETTING_TEST
//USB2IIC configurations setting test
int iic_config_set_test(libusb_device_handle *devh, ChannelType ch, USB2IIC_Config *pusb2iic_config)
{
    int rc = 0;

    rc = iic_get_config(devh, ch, pusb2iic_config, 1000);
    if(rc != SUCCESS)
    {
        return rc;
    }
	printf("\niic config before setting: \n");

	rc = print_iic_config(pusb2iic_config);
	if(rc != SUCCESS)
    {
        return rc;
    }

	/* standard mode, 100KHz*/
	pusb2iic_config->SpikePulse = 3;
	pusb2iic_config->SetupDat  = 8;
	pusb2iic_config->HoldDat = 11;
	pusb2iic_config->SclRatio = 0;
	pusb2iic_config->SclHi = 293;
	pusb2iic_config->TParam = 0;

	pusb2iic_config->Addr = 0x50;
	pusb2iic_config->PhaseStart = 1;
	pusb2iic_config->PhaseAddr = 1;
	pusb2iic_config->PhaseData = 1;
	pusb2iic_config->PhaseStop = 1;
	pusb2iic_config->Master = 1;
	pusb2iic_config->Addressing = 0;
	pusb2iic_config->IICEnable = 1;

	printf("\niic config set to: \n");

	rc = print_iic_config(pusb2iic_config);
	if(rc != SUCCESS)
    {
        return rc;
    }

	rc = iic_set_config(devh, ch, pusb2iic_config, 1000);
	if(rc != SUCCESS)
    {
        return rc;
    }

	rc = iic_get_config(devh, ch, pusb2iic_config, 1000);
	if(rc != SUCCESS)
    {
        return rc;
    }

	printf("\niic config after setting: \n");

	rc = print_iic_config(pusb2iic_config);
	if(rc != SUCCESS)
    {
        return rc;
    }

    return SUCCESS;
}
#endif // I2C_CONFIG_SETTING_TEST


#ifdef I2C_MASTER_WRITE_TEST
//USB2IIC as master, test write data to slave
int iic_master_write_test(libusb_device_handle *devh, ChannelType ch, USB2IIC_Config *pusb2iic_config)
{
    int rc = 0;

	//set iic configurations
	/* standard mode, 100KHz*/
#if 1
	pusb2iic_config->SpikePulse = 3;
	pusb2iic_config->SetupDat  = 8;
	pusb2iic_config->HoldDat = 11;
	pusb2iic_config->SclRatio = 0;
	pusb2iic_config->SclHi = 275;
	pusb2iic_config->TParam = 0;
#endif

#if 0
	pusb2iic_config->SpikePulse = 0;
	pusb2iic_config->SetupDat  = 0;
	pusb2iic_config->HoldDat = 0;
	pusb2iic_config->SclRatio = 0;
	pusb2iic_config->SclHi = 50;
	pusb2iic_config->TParam = 0;
#endif

// fast mode: 400KHz
#if 0
	pusb2iic_config->SpikePulse = 3;
	pusb2iic_config->SetupDat  = 2;
	pusb2iic_config->HoldDat = 5;
	pusb2iic_config->SclRatio = 0;
	pusb2iic_config->SclHi = 45;
	pusb2iic_config->TParam = 0;
#endif

// fast plus mode: 1000KHz
#if 0
	pusb2iic_config->SpikePulse = 3;
	pusb2iic_config->SetupDat  = 2;
	pusb2iic_config->HoldDat = 2;
	pusb2iic_config->SclRatio = 1;
	pusb2iic_config->SclHi = 12;
	pusb2iic_config->TParam = 0;
#endif

	pusb2iic_config->Addr = 0x50;
	pusb2iic_config->PhaseStart = 1;
	pusb2iic_config->PhaseAddr = 1;
	pusb2iic_config->PhaseData = 1;
	pusb2iic_config->PhaseStop = 1;
	pusb2iic_config->Master = 1;
	pusb2iic_config->Addressing = 0;
	pusb2iic_config->IICEnable = 1;

	rc = iic_set_config(devh, ch, pusb2iic_config, 1000);
	if(rc != SUCCESS)
    {
        printf("usb2iic master set configurations failed.\n");
        return rc;
    }
    else
    {
        printf("usb2iic master set configurations successfully.\n");
    }

	printf("usb2iic master write demo, send %lu bytes to iic slave device\n", (long unsigned int)(sizeof(WData)));
	rc = usb2iic_master_write(devh, ch, sizeof(WData), WData, 5000);
	if(rc != SUCCESS) {
		printf("usb2iic master write data failed.\n");
		return rc;
	}
	else
    {
        printf("usb2iic master write data successfully.\n");
    }

	rc = iic_get_config(devh, ch, pusb2iic_config, 1000);
	if(rc != SUCCESS)
	{
        printf("usb2iic master get configurations failed.\n");
        return rc;
    }
    else
    {
        printf("usb2iic master get configurations successfully.\n");
    }

	printf("\nusb2iic config after master write: \n");

	rc = print_iic_config(pusb2iic_config);
	if(rc != SUCCESS)
    {
        return rc;
    }

    return SUCCESS;
}
#endif // I2C_MASTER_WRITE_TEST


#ifdef I2C_MASTER_READ_TEST
//USB2IIC as master, test read data from slave
int iic_master_read_test(libusb_device_handle *devh, ChannelType ch, USB2IIC_Config *pusb2iic_config)
{
    int rc = 0;
	int i = 0;

	/* standard mode, 100KHz*/
	pusb2iic_config->SpikePulse = 3;
	pusb2iic_config->SetupDat  = 8;
	pusb2iic_config->HoldDat = 11;
	pusb2iic_config->SclRatio = 0;
	pusb2iic_config->SclHi = 293;
	pusb2iic_config->TParam = 0;

	pusb2iic_config->Addr = 0x50;
	pusb2iic_config->PhaseStart = 1;
	pusb2iic_config->PhaseAddr = 1;
	pusb2iic_config->PhaseData = 1;
	pusb2iic_config->PhaseStop = 1;
	pusb2iic_config->Master = 1;
	pusb2iic_config->Addressing = 0;
	pusb2iic_config->IICEnable = 1;

	rc = iic_set_config(devh, ch, pusb2iic_config, 1000);
	if(rc != SUCCESS)
    {
        return rc;
    }

	printf("usb2iic master read demo:\n");

	rc = usb2iic_master_read(devh, ch, 9, RData, 0);
	if(rc != SUCCESS)
    {
		printf("usb2iic master read data failed.\n");
		return rc;
	}

	printf("data read by usb2iic master:\n");
	for(i = 0; i < 9; i++)
	{
		printf("%02x ", RData[i]);
		if((i + 1) % 4 == 0)
        {
			printf(" ");
		}
	}
	printf("\n");

    return SUCCESS;
}
#endif // I2C_MASTER_READ_TEST


#ifdef I2C_SLAVE_WRITE_TEST
//USB2IIC as slave, test write data to slave
int iic_slave_write_test(libusb_device_handle *devh, ChannelType ch, USB2IIC_Config *pusb2iic_config)
{
    unsigned char TransData[256];
	int DataCnt = 8;

	int dataTransed = 0;

	int i = 0;
	int rc = 0;

	for(i = 0; i < DataCnt; i++)
    {
		TransData[i] = (i + 1) * 2;
	}

	/* standard mode, 100KHz*/
	pusb2iic_config->SpikePulse = 3;
	pusb2iic_config->SetupDat  = 8;
	pusb2iic_config->HoldDat = 11;
	pusb2iic_config->SclRatio = 0;
	pusb2iic_config->SclHi = 293;
	pusb2iic_config->TParam = 0;

	pusb2iic_config->Addr = 0x50;
	pusb2iic_config->PhaseStart = 1;
	pusb2iic_config->PhaseAddr = 1;
	pusb2iic_config->PhaseData = 1;
	pusb2iic_config->PhaseStop = 1;
	pusb2iic_config->Master = 0;
	pusb2iic_config->Addressing = 0;
	pusb2iic_config->IICEnable = 1;

	rc = iic_set_config(devh, ch, pusb2iic_config, 1000);
	if(rc != SUCCESS)
    {
        return rc;
    }

	rc = usb2iic_slave_write(devh, ch, DataCnt, TransData, &dataTransed, 0);
	if(rc != SUCCESS)
    {
		printf("iic slave write test failed.\n");
		return rc;
	}

	printf("iic slave send bytes: %d\n", dataTransed);

    return SUCCESS;
}
#endif // I2C_SLAVE_WRITE_TEST


#ifdef I2C_SLAVE_READ_TEST
//USB2IIC as slave, test read data from slave
int iic_slave_read_test(libusb_device_handle *devh, ChannelType ch, USB2IIC_Config *pusb2iic_config)
{
    unsigned char RcvData[256];
	int DataCnt;

	int i = 0;
	int rc = 0;

	/* standard mode, 100KHz*/
	pusb2iic_config->SpikePulse = 3;
	pusb2iic_config->SetupDat  = 8;
	pusb2iic_config->HoldDat = 11;
	pusb2iic_config->SclRatio = 0;
	pusb2iic_config->SclHi = 293;
	pusb2iic_config->TParam = 0;

	pusb2iic_config->Addr = 0x50;
	pusb2iic_config->PhaseStart = 1;
	pusb2iic_config->PhaseAddr = 1;
	pusb2iic_config->PhaseData = 1;
	pusb2iic_config->PhaseStop = 1;
	pusb2iic_config->Master = 0;
	pusb2iic_config->Addressing = 0;
	pusb2iic_config->IICEnable = 1;

	rc = usb2iic_reset(devh, ch, 1000);
	if(rc != SUCCESS)
    {
        return rc;
    }

	rc = iic_set_config(devh, ch, pusb2iic_config, 1000);
	if(rc != SUCCESS)
    {
        return rc;
    }

	rc = usb2iic_slave_read(devh, ch, RcvData, &DataCnt, 0);
	if(rc != SUCCESS)
    {
		printf("iic slave read test failed.\n");
		return rc;
	}

	printf("USB2IIC: %d bytes received\n", DataCnt);
	for(i = 0; i < DataCnt; i++)
	{
		printf("%02x ", RcvData[i]);
		if((i + 1) % 4 == 0)
        {
			printf("  ");
		}
		else if((i + 1) % 32 == 0)
		{
			printf("\n");
		}
	}
	printf("\n");

    return SUCCESS;
}
#endif // I2C_SLAVE_READ_TEST

#endif // USB2IIC_TEST
// ---------------------------------------- USB2I2C ----------------------------------------//



// ---------------------------------------- USB2Parallel ----------------------------------------//
#ifdef USB2PARALLEL_TEST

//usb2parallel test
int usb2parallel_test()        //TBD
{
    int rc = 0;
    ChannelType ch;
    int interface_number;

    //Select channel and interface
#ifdef CHANNEL_PARALLEL1_SELECTED
    ch = CH_PARALLEL1;
    interface_number = PARALLEL_USB_INTERFACE;
#endif // CHANNEL_PARALLEL1_TEST

    print_channel_type(ch, interface_number);

    //Claim interface
    rc = libusb_claim_interface(devh, interface_number);
	if (rc != SUCCESS)
    {
		printf("Claiming interface %d failed.\n", interface_number);
		return rc;
	}

	printf("DEVICE READY...\n\n");

	rc = usb2parallel_send_data(devh, ch, sizeof(tx_pdata), tx_pdata,  1000);
	if(rc != SUCCESS)
    {
        goto out;
    }

out:
	libusb_release_interface(devh, interface_number);

    return rc;
}

#endif
// ---------------------------------------- USB2Parallel ----------------------------------------//


//Print channel and interface
void print_channel_type(ChannelType ch, int interface_number)
{
    switch(ch)
    {
    case CH_I2C1:
        printf("This is USB to I2C1 channel.\n");
        break;
    case CH_I2C2:
        printf("This is USB to I2C2 channel.\n");
        break;
    case CH_I2C3:
        printf("This is USB to I2C3 channel.\n");
        break;
    case CH_I2C4:
        printf("This is USB to I2C4 channel.\n");
        break;
    case CH_UART1:
        printf("This is USB to UART1 channel.\n");
        break;
    case CH_UART2:
        printf("This is USB to UART2 channel.\n");
        break;
    case CH_UART3:
        printf("This is USB to UART3 channel.\n");
        break;
    case CH_PARALLEL1:
        printf("This is USB to Parallel channel.\n");
        break;
    default:
        printf("This is unknown channel, please check!!!\n");
        break;
    }

    printf("The interface is %d\n", interface_number);
    printf("\n");
}



//main
int main(int argc, char *argv[])
{
	int rc = 0;

	//Initializes libusb
	rc = libusb_init(NULL);
	if (rc != LIBUSB_SUCCESS)
    {
		return rc;
    }

    //Open USB device
	devh = libusb_open_device_with_vid_pid(NULL, VENDOR_ID, PRODUCT_ID);
	if(NULL == devh)
	{
		printf("Open USB device failed\n");
		goto out;
	}
	else
    {
        printf("Open USB device\n");
    }

#ifdef USB2UART_TEST
	rc = usb2uart_test();
#endif // USB2UART_TEST

#ifdef USB2IIC_TEST
	rc = usb2iic_test(devh, pusb2iic_config);;
#endif // USB2IIC_TEST

#ifdef USB2PARALLEL_TEST
	rc = usb2parallel_test();
#endif // USB2PARALLEL_TEST

	if(rc != SUCCESS)
    {
        goto out;
    }

out:
	if(devh)
    {
		libusb_close(devh);
    }

	libusb_exit(NULL);

	return 0;
}
