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
#include "da16k_uart.h"
#include "da16k_comm.h"

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
bool da16k_uart_init(void) {

	if(BSP_${IpInstance}_Init())
		return false;

	HAL_UART_Receive_IT(da_uart_p, (uint8_t *) &rxByte, 1);
	return true;
}

bool txDmaInUse = false;
void HAL_UART_TxCpltCallback(UART_HandleTypeDef *huart) {
	if(huart == da_uart_p) {
		txDmaInUse = false;
	}
}

#define TERM_LINE_SIZ (256)
bool da16k_uart_send(const char *src, size_t length) {
	static char txBuf[2][TERM_LINE_SIZ];
	static int bufSelect = 0;
	HAL_StatusTypeDef s;

	if(!src || length==0)
		return false;

	SET_TIMEOUT();
	while(txDmaInUse){
		if(GET_TIMEOUT())
			return false;
	}
	txDmaInUse = true;

	memcpy(txBuf[bufSelect], src, length);
	do {
		s = HAL_UART_Transmit_DMA(da_uart_p, (uint8_t*)txBuf[bufSelect], length);
	}while(s != HAL_OK);

	bufSelect = bufSelect ? 0:1;

    return true;
}

static volatile char rxBuf[TERM_LINE_SIZ];
static int head=0, tail=0;
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart) {
	if(huart == da_uart_p) {
		HAL_UART_Receive_IT(da_uart_p, (uint8_t *) &rxByte, 1);
		rxBuf[head] = rxByte;
		if(++head >= TERM_LINE_SIZ)
			head = 0;
	}
}

da16k_err_t da16k_uart_get_char(char *dst, uint32_t timeout_ms) {
	if(!dst)
		return DA16K_INVALID_PARAMETER;

	uint32_t expiry = HAL_GetTick() + timeout_ms;
	
	do {
		if(tail != head) {
			*dst = rxBuf[tail];
			if(++tail >= TERM_LINE_SIZ)
				tail = 0;
			return DA16K_SUCCESS;
		}			
	}while(HAL_GetTick() < expiry);		
	
	return DA16K_TIMEOUT;
}

void da16k_uart_close(void) {
	return;
}
