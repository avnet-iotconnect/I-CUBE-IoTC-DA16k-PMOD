/*
 * debug_uart.c
 *
 *  Created on: Sep 2, 2024
 *      Author: pyoung
 */

#include "main.h"

#define DEBUG_LINE_SIZE (256)

extern UART_HandleTypeDef huart2;
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
