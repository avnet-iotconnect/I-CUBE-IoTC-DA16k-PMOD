[#ftl]
/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : ${BoardName}_bus.c
  * @brief          : source file for the BSP BUS IO driver
  ******************************************************************************
[@common.optinclude name=mxTmpFolder+"/license.tmp"/][#--include License text --]
  ******************************************************************************
*/
/* USER CODE END Header */

/* Includes ------------------------------------------------------------------*/
#include "${BoardName}_bus.h"
#include <stdbool.h>
#include <string.h>

[#assign IpName = ""]

[#assign USART = ""]
[#assign UsartIpInstance = ""]
[#assign UsartIpInstanceList = ""]
[#assign USARTDmaIsTrue = false]

[#list BspIpDatas as SWIP]
    [#assign IpName = "?"]
    [#list SWIP.variables as variables]
        [#if variables.name?contains("IpName")]
            [#assign IpName = variables.value]
        [/#if]	
    [/#list]
    [#if SWIP.bsp??]
        [#list SWIP.bsp as bsp]
            [#if IpName??]
                [#switch IpName]
                [#case "USART"]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
                        [#assign USARTDmaIsTrue = bsp.dmaUsed]
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
                    [/#if]
                [#break]
                [#case "UART"]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
                        [#assign USARTDmaIsTrue = bsp.dmaUsed]
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
                    [/#if]
                [#break]
                [#case "LPUART"]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
                        [#assign USARTDmaIsTrue = bsp.dmaUsed]
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
                    [/#if]
                [#break]
                [/#switch]
            [/#if]
        [/#list]
    [/#if]
[/#list]

/** @defgroup ${BoardName?upper_case}_BUS_Exported_Variables BUS Exported Variables
  * @{
  */
[#assign IpName = ""]

[#assign UsartIpInstance = ""]
[#assign UsartIpInstanceList = ""]
[#assign USART = ""]
[#assign USARTisTrue = false]
[#assign USARTInstance = ""]

[#list BspIpDatas as SWIP]
    [#assign IpName = "?"]
    [#list SWIP.variables as variables]
        [#if variables.name?contains("IpName")]
            [#assign IpName = variables.value]
        [/#if]	
    [/#list]
    [#if SWIP.bsp??]
        [#list SWIP.bsp as bsp]
            [#if IpName??]
                [#switch IpName]
                [#case "USART"]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
extern UART_HandleTypeDef h${UsartIpInstance?lower_case?replace("s","")};
UART_HandleTypeDef *da_uart_p=&h${UsartIpInstance?lower_case?replace("s","")};
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
extern UART_HandleTypeDef h${UsartIpInstance?lower_case?replace("s","")};
UART_HandleTypeDef *da_uart_p=&h${UsartIpInstance?lower_case?replace("s","")};
                    [/#if]
                [#break]
                [#case "UART"]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
extern UART_HandleTypeDef h${UsartIpInstance?lower_case};
UART_HandleTypeDef *da_uart_p=&h${UsartIpInstance?lower_case};
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
extern UART_HandleTypeDef h${UsartIpInstance?lower_case};
UART_HandleTypeDef *da_uart_p=&h${UsartIpInstance?lower_case};
                    [/#if]
                [#break]
                [#case "LPUART"]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
extern UART_HandleTypeDef h${UsartIpInstance?lower_case};
UART_HandleTypeDef *da_uart_p=&h${UsartIpInstance?lower_case};
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
extern UART_HandleTypeDef h${UsartIpInstance?lower_case};
UART_HandleTypeDef *da_uart_p=&h${UsartIpInstance?lower_case};
                    [/#if]
                [#break]
                [/#switch]
            [/#if]
        [/#list]
    [/#if]
[/#list]
/**
  * @}
  */

static uint32_t timout;

#define _500MS (50)
#define SET_TIMEOUT() (timout= HAL_GetTick()+_500MS)
#define GET_TIMEOUT() (timout < HAL_GetTick())


static char rxByte;
int uart_init(uint32_t baud, uint32_t bits, uint32_t parity, uint32_t stopbits) {
	HAL_UART_Receive_IT(da_uart_p, (uint8_t *) &rxByte, 1);
	return 0;
}

bool txDmaInUse = false;
void HAL_UART_TxCpltCallback(UART_HandleTypeDef *huart)
{
	if(huart == da_uart_p) {
		txDmaInUse = false;
	}
}

#define TERM_LINE_SIZ (256)
size_t uart_send(const char *src, size_t length) {
	static char txBuf[2][TERM_LINE_SIZ];
	static int bufSelect = 0;
	HAL_StatusTypeDef s;

	if(!src || length==0)
		return 0;

	SET_TIMEOUT();
	while(txDmaInUse){
		if(GET_TIMEOUT())
			return 0;
	}
	txDmaInUse = true;

	memcpy(txBuf[bufSelect], src, length);
	do {
		s = HAL_UART_Transmit_DMA(da_uart_p, (uint8_t*)txBuf[bufSelect], length);
	}while(s != HAL_OK);

	bufSelect = bufSelect ? 0:1;

    return length;
}

static volatile char rxBuf[TERM_LINE_SIZ];
static int head=0, tail=0;
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
	if(huart == da_uart_p) {
		HAL_UART_Receive_IT(da_uart_p, (uint8_t *) &rxByte, 1);
		rxBuf[head] = rxByte;
		if(++head >= TERM_LINE_SIZ)
			head = 0;
	}
}

size_t uart_recv(char *dst, size_t length) {
#ifdef TEST_STRINGS
	size_t return_siz=0;


	if(!dst || length == 0)
		return 0;

	while(tail != head) {
		*dst = rxBuf[tail];
		dst++;
		if(++tail >= TERM_LINE_SIZ)
			tail = 0;
		return_siz++;
	}

	return return_siz;
#else
	static unsigned int s=0;
	const char *cmds[]={
			"+NWICDUID:0\r\n",
			"+NWICCPID:1\r\n",
			"+NWICENV:0\r\n",
			"+NWICAT:0\r\n",
			"+NWICCT:1\r\n",
			"+NWICSK:1\r\n",
			"+NWICSETUP:0\r\n",
			"+NWICSTART:0\r\n",
			"+NWICSTOP:0\r\n",
			"+NWICRESET:0\r\n",
			"+NWICMSG:1\r\n",
			"+NWICVER:1\r\n",
			"+NWICGETCMD:cmd_string,params_str\r\n",
			"+NWICCMDACK:1\r\n",
			"+NWICUSECMDACK:1\r\n",
			"+NWICOTAACK:\r\n",
			"+NWICUSEOTAACK:\r\n"
	};
	size_t l;

	if(!dst || length==0) return 0;

	l = strlen(cmds[s]);

	memcpy(dst, cmds[s], l);

	if(++s>=17) s=0;

	return l;
#endif
}

int uart_close() {
	return 0;
}
