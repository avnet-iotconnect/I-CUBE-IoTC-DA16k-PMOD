#include "da16k_uart.h"

int app_da16k_pmod_Init (void) {
	return 0;
}

int app_da16k_pmod_Process (void) {
	return 0;
}

int MX_da16k_pmod_Init(void) {
	int err = 0;

	if(!da16k_uart_init())
		err = -1;

	return err;
}

int MX_da16k_pmod_Process(void) {
	return 0;
}
