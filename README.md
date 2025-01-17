# DA16k PMOD Firmware
To ensure compatability with this X-CUBE pack, matching DA16k-PMOD firmware has been included within it.

The image files can be found in the Repository e.g.

```
https://github.com/avnet-iotconnect/iotc-dialog-da16k-sdk/tree/main/images
```

Follow the instructions in the [QuickStart Guide](https://github.com/avnet-iotconnect/iotc-dialog-da16k-sdk/blob/main/doc/QUICKSTART.md) to flash the DA16k PMOD.

# Supported Boards
The following boards are supported by this repository:

* ST [STM32H573I-DK](https://www.st.com/en/evaluation-tools/stm32h573i-dk.html)
* ST [STM32 B-U585I-IOT02A](https://www.st.com/en/evaluation-tools/b-u585i-iot02a.html)
* ST [STM32N6570-DK](https://www.st.com/en/evaluation-tools/stm32n6570-dk.html)

> [!NOTE]
> Use the FW bundled with the X-CUBE .pack file in ***/pack_project_dir/Files*** instead of what is on Github.
> 
> For STM32N6570-DK board, please follow the [instructions](./doc/n6_quickstart.md) in the /doc folder.


# Usage
1. Download the [Avnet-IOTCONNECT.X-CUBE-IoTC-DA16k-PMOD.1.0.0.pack](https://github.com/avnet-iotconnect/I-CUBE-IoTC-DA16k-PMOD/tree/main/pack_project_dir/Files)
1. Download and Launch [STM32CubeIDE](https://www.st.com/en/development-tools/stm32cubeide.html)
1. Create a **CubeMX** project
      * Select New project by MCU
      * Select the MCU part number from the drop-down list
      * Click Create Project at the top corner
1. Click "Software Packs" in the "Pinout & Configuration" view and click “Manage Software Packs”
1. Click on "From Local ..."
1. Navigate to and select the .pack file
1. Accept the license
1. Close the window
1. Now go to "Select Components"
1. Check the box beside "_Extension Board_/iotc_da16k_pmod / subgroup"
1. Select “single_thread” from the "_Device_ Application" pull-down menu.
1. Click "OK".
1. Click "Connectivity" and select "USART3" (This is the Arduino connector)
 - Parameter Settings:
   - Mode: Asynchronous
   - Baud: 115200
   - Word Length: 8 bits (including Parity)
   - Parity: None
   - Stop Bits: 1
 - NVIC Settings:
   - Global Interrupt enabled
 - _Optional DMA Settings:_
   1. _Click "Add"._
   1. _Select the "*TX" option from the "DMA Request" column._
 - GPIO Settings
   - Make sure the GPIO settings are correct for your board (TX and RX pins)
14. In the "Pinout & Configutation" tab of the CubeMX view, select "I-CUBE-IoTC-DA16k-PMOD" from "Middlewares & Software Packs" on the left hand side.
1. Check both the "Extension Board iotc da16k pmod" & "Device Application" boxes. This will make the "Platform Settings" tab available below.
1. CubeMX will query the current setup and find the suitable serial ports that can be used with the pack. In "IPs or Components" select the type of serial port configured previously.
1. Select the serial port previously configured from the "Found Solutions" pull-down menu.
2. Enter the device and wifi credentials in the "Parameter Settings" tab.
3. At the top of the CubeMX window click on the "Project Manager" tab.
4. On the left hand side, click on the "Advanced Settings"
5. On the right hand side, within the "Register Callback" pane, find the **UART/USART/LPUART** section to use and set the register callbacks to "ENABLE".
6. Click "Project Manager" and Find the Drop-down next to "Toolchain / IDE" ensure it matches your IDE (e.g. Change this to "STM32CubeIDE" for STM boards)
1. Save the setting ("Ctrl + s") and generate the code.
2. Close the CubeMX

Open The Project from the CubeIDE
4. If you intend to send telemetry open up the project properties:
   - Navigate to C/C++ Build -> Settings
   - Set the "Runtime Library" to "Standard C"
5. Upload the device certificate and key using the console port on the da16k:
   - Enter `net` into the terminal to switch to the network commands context.
   - Enter `cert write cert1`.
   - Paste the certificate into the terminal.
   - As instructed on the terminal enter CTRL+C to complete the process.
   - Enter `cert write key1`.
   - Paste the key into the terminal.
   - As instructed on the terminal enter CTRL+C to complete the process.

# Next Steps
Once the code has been generated the next steps are:
## Setup the debug console/uart for the host
Here are code snippets that may be present in a future version of the pack as an example. These will help setup a debug serial port.
You can use the `/* USER CODE BEGIN ... */` comments as locations to insert these snippets.

In main.c:
```C
/* USER CODE BEGIN Includes */
#include <stdio.h>
#include <stdbool.h>
/* USER CODE END Includes */
```
 and
```C
/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */
#define DEBUG_LINE_SIZE (256)
#define DEBUG_UART_P (&huart2)

typedef struct HEAD_TO_TAIL_BUF {
	volatile char buf[DEBUG_LINE_SIZE];
	int head, tail;
}headToTailBuf_t;

static struct HEAD_TO_TAIL_BUF rx_buf = {{0},0,0};

int head_to_tail_buf_write (struct HEAD_TO_TAIL_BUF * b, char data) {
	b->buf[b->head] = data;
		if(++b->head >= DEBUG_LINE_SIZE)
			b->head = 0;
	return 0;
}

int head_to_tail_buf_read (struct HEAD_TO_TAIL_BUF * b, char * data) {

	if(b->tail != b->head) {
		*data = (int)b->buf[b->tail];
		if(++b->tail >= DEBUG_LINE_SIZE)
			b->tail = 0;
		return 0;
	}
	else {
		return -1;
	}
}

static char rx_byte;

/*
 * Callback that occurs at the end of a transmission. Clears the txDmaInUse flag to allow subsequent transmissions.
 */
void HAL_DEBUG_UART_TxCpltCallback(UART_HandleTypeDef *huart) {
	;
}

/*
 * Callback that happens when characters are received via interrupt one at a time. The function places each byte in a
 * buffer to be processed when the system can.
 */
void HAL_DEBUG_UART_RxCpltCallback(UART_HandleTypeDef *huart) {
	if(huart == DEBUG_UART_P) {
		HAL_UART_Receive_IT(DEBUG_UART_P, (uint8_t *) &rx_byte, 1);
		head_to_tail_buf_write(&rx_buf, rx_byte);
	}
}

int __io_putchar(int ch) {
	int err=0;
	HAL_StatusTypeDef s;
	do
		s = HAL_UART_Transmit_IT(DEBUG_UART_P, (uint8_t *)&ch, 1);
	while(s != HAL_OK);

	return err;
}

int __io_getchar(void) {
	char c;

	while(0 != head_to_tail_buf_read(&rx_buf, &c));

	return (int)c;
}
/* USER CODE END 0 */
```
Within the code generated by CubeMX for your debug serial port, also in main.c:
```C
  /* USER CODE BEGIN USART2_Init 2 */
#if (USE_HAL_UART_REGISTER_CALLBACKS == 1)
    if(HAL_OK != HAL_UART_RegisterCallback(DEBUG_UART_P, HAL_UART_TX_COMPLETE_CB_ID,
        &HAL_DEBUG_UART_TxCpltCallback) ) {
        return false;
    }

    if(HAL_OK != HAL_UART_RegisterCallback(DEBUG_UART_P, HAL_UART_RX_COMPLETE_CB_ID,
        &HAL_DEBUG_UART_RxCpltCallback) ) {
        return false;
    }
#endif
    printf("\f\n\rPMOD Host Demo Start...\n\r");
  /* USER CODE END USART2_Init 2 */
```

## Send Telemetry.
The user should be able to send telemetry by following the usual process of calling `da16_create/send_msg*`.
## React to C2D commands
By default the code will output received commands to a debug output. This can be redirected by provided a "strong" version of the `void da16k_cmd_handler(da16k_cmd_t * cmd)
` function.
