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
                    [#assign USARTisTrue = true]
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
                    [#assign USARTisTrue = true]
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
                [#case "LPUART"]
                    [#assign USARTisTrue = true]
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
                [/#switch]
            [/#if]
        [/#list]
    [/#if]
[/#list]

/** @addtogroup BSP
  * @{
  */

/** @addtogroup ${BoardName?upper_case}
  * @{
  */

/** @defgroup ${BoardName?upper_case}_BUS ${BoardName?upper_case} BUS
  * @{
  */

[#if USARTDmaIsTrue]
extern void Error_Handler(void);
[/#if]

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
[#-- extern : A.T removed after review with Maher --]
UART_HandleTypeDef h${UsartIpInstance?lower_case?replace("s","")};
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
[#-- extern : A.T removed after review with Maher --]
UART_HandleTypeDef h${UsartIpInstance?lower_case?replace("s","")};
                    [/#if]
                [#break]
                [#case "UART"]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
[#-- extern : A.T removed after review with Maher --]
UART_HandleTypeDef h${UsartIpInstance?lower_case};
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
[#-- extern : A.T removed after review with Maher --]
UART_HandleTypeDef h${UsartIpInstance?lower_case};
                    [/#if]
                [#break]
                [#case "LPUART"]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
[#-- extern : A.T removed after review with Maher --]
UART_HandleTypeDef h${UsartIpInstance?lower_case};
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
[#-- extern : A.T removed after review with Maher --]
UART_HandleTypeDef h${UsartIpInstance?lower_case};
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

/** @defgroup ${BoardName?upper_case}_BUS_Private_Variables BUS Private Variables
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
                [#case "UART"]
                [#assign USARTisTrue = true]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
#if (USE_HAL_UART_REGISTER_CALLBACKS == 1U)
static uint32_t Is${UsartIpInstance}MspCbValid = 0;
#endif /* USE_HAL_UART_REGISTER_CALLBACKS */
static uint32_t ${UsartIpInstance}InitCounter = 0;
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
#if (USE_HAL_UART_REGISTER_CALLBACKS == 1U)
static uint32_t Is${UsartIpInstance}MspCbValid = 0;
#endif /* USE_HAL_UART_REGISTER_CALLBACKS */
static uint32_t ${UsartIpInstance}InitCounter = 0;
                    [/#if]
                [#break]
                [#case "USART"]
                [#assign USARTisTrue = true]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
#if (USE_HAL_UART_REGISTER_CALLBACKS == 1U)
static uint32_t Is${UsartIpInstance}MspCbValid = 0;
#endif /* USE_HAL_UART_REGISTER_CALLBACKS */
static uint32_t ${UsartIpInstance}InitCounter = 0;
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
#if (USE_HAL_UART_REGISTER_CALLBACKS == 1U)
static uint32_t Is${UsartIpInstance}MspCbValid = 0;
#endif /* USE_HAL_UART_REGISTER_CALLBACKS */
static uint32_t ${UsartIpInstance}InitCounter = 0;
                    [/#if]
                [#break]
                [#case "LPUART"]
                [#assign USARTisTrue = true]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
#if (USE_HAL_UART_REGISTER_CALLBACKS == 1U)
static uint32_t Is${UsartIpInstance}MspCbValid = 0;
#endif /* USE_HAL_UART_REGISTER_CALLBACKS */
static uint32_t ${UsartIpInstance}InitCounter = 0;
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
#if (USE_HAL_UART_REGISTER_CALLBACKS == 1U)
static uint32_t Is${UsartIpInstance}MspCbValid = 0;
#endif /* USE_HAL_UART_REGISTER_CALLBACKS */
static uint32_t ${UsartIpInstance}InitCounter = 0;
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


/** @defgroup ${BoardName?upper_case}_BUS_Private_FunctionPrototypes  BUS Private Function
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
                    [#case "UART"]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
static void ${UsartIpInstance}_MspInit(UART_HandleTypeDef* huart);
static void ${UsartIpInstance}_MspDeInit(UART_HandleTypeDef* huart);
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
static void ${UsartIpInstance}_MspInit(UART_HandleTypeDef* huart);
static void ${UsartIpInstance}_MspDeInit(UART_HandleTypeDef* huart);
                    [/#if]
                [#break]
                [#case "USART"]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
static void ${UsartIpInstance}_MspInit(UART_HandleTypeDef* huart);
static void ${UsartIpInstance}_MspDeInit(UART_HandleTypeDef* huart);
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
static void ${UsartIpInstance}_MspInit(UART_HandleTypeDef* huart);
static void ${UsartIpInstance}_MspDeInit(UART_HandleTypeDef* huart);
                    [/#if]
                [#break]
                [#case "LPUART"]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
static void ${UsartIpInstance}_MspInit(UART_HandleTypeDef* huart);
static void ${UsartIpInstance}_MspDeInit(UART_HandleTypeDef* huart);
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
static void ${UsartIpInstance}_MspInit(UART_HandleTypeDef* huart);
static void ${UsartIpInstance}_MspDeInit(UART_HandleTypeDef* huart);
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

/** @defgroup ${BoardName?upper_case}_LOW_LEVEL_Private_Functions ${BoardName?upper_case} LOW LEVEL Private Functions
  * @{
  */

/** @defgroup ${BoardName?upper_case}_BUS_Exported_Functions ${BoardName?upper_case}_BUS Exported Functions
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
/* BUS IO driver over USART Peripheral */
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
                        [@generateBspUSART_Driver UsartIpInstance bsp/]
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
                        [@generateBspUSART_Driver UsartIpInstance bsp/]
                    [/#if]
                [#break]
                [#case "UART"]
                    [#if UsartIpInstanceList == ""]
/* BUS IO driver over UART Peripheral */
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
                        [@generateBspUSART_Driver UsartIpInstance bsp/]
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
                        [@generateBspUSART_Driver UsartIpInstance bsp/]
                    [/#if]
                [#break]
                [#case "LPUART"]
                    [#if UsartIpInstanceList == ""]
/* BUS IO driver over UART Peripheral */
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
                        [@generateBspUSART_Driver UsartIpInstance bsp/]
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
                        [@generateBspUSART_Driver UsartIpInstance bsp/]
                    [/#if]
                [#break]
                [/#switch]
            [/#if]
        [/#list]
    [/#if]
[/#list]

[#-- macro generateBspUSART_Driver --]
[#macro generateBspUSART_Driver IpInstance bsp]
[#assign ipName = bsp.ipNameUsed]
[#assign halMode = false]
[#if bsp.halMode == ipName]
    [#assign halMode = true]
[#else]	  
	[#assign halModeName = bsp.halMode]	
[/#if]

static uint32_t timout;

#define _500MS (50)
#define SET_TIMEOUT() (timout= HAL_GetTick()+_500MS)
#define GET_TIMEOUT() (timout < HAL_GetTick())
#define TERM_LINE_SIZ (256)
[#if bsp.dmaTx]
bool tx_dma_busy = false;
[/#if]
static volatile char rx_buf[TERM_LINE_SIZ];
static int head=0, tail=0;

static char rx_byte;

#if (USE_HAL_UART_REGISTER_CALLBACKS == 1)
/*
 * Callback that occurs at the end of a transmission. Clears the tx_dma_busy flag to allow subsequent transmissions.
 */
void HAL_DA16K_UART_TxCpltCallback(UART_HandleTypeDef *huart) {
[#if bsp.dmaTx]
    if(huart == da_uart_p) {
        tx_dma_busy = false;
    }
[/#if]
}

/*
 * Callback that happens when characters are received via interrupt one at a time. The function places each byte in a
 * buffer to be processed when the system can.
 */
void HAL_DA16K_UART_RxCpltCallback(UART_HandleTypeDef *huart) {
    if(huart == da_uart_p) {
        HAL_UART_Receive_IT(da_uart_p, (uint8_t *) &rx_byte, 1);
        rx_buf[head] = rx_byte;
        if(++head >= TERM_LINE_SIZ) {
            head = 0;
        }
    }
}
#else
/* 
 * Callback that occurs at the end of a transmission. Clears the tx_dma_busy flag to allow subsequent transmissions.
 */
void HAL_UART_TxCpltCallback(UART_HandleTypeDef *huart) {
[#if bsp.dmaTx]
    if(huart == da_uart_p) {
        tx_dma_busy = false;
    }
[/#if]
}
/* 
 * Callback that happens when characters are received via interrupt one at a time. The function places each byte in a
 * buffer to be processed when the system can.
 */
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart) {
    if(huart == da_uart_p) {
        HAL_UART_Receive_IT(da_uart_p, (uint8_t *) &rx_byte, 1);
        rx_buf[head] = rx_byte;
        if(++head >= TERM_LINE_SIZ) {
            head = 0;
        }
    }
}
#endif

/* 
 * Function required by the AT cmd lib. This initialises the serial port so it's ready to place received bytes via
 * interrupt into a buffer. It also sets the serial port hardware ready to transmit strings, via DMA preferably.
 */
bool da16k_uart_init(void) {

    if(BSP_${IpInstance}_Init()) {
        return false;
    }

#if (USE_HAL_UART_REGISTER_CALLBACKS == 1)
    if(HAL_OK != HAL_UART_RegisterCallback(da_uart_p, HAL_UART_TX_COMPLETE_CB_ID,
        &HAL_DA16K_UART_TxCpltCallback) ) {
        return false;
    }

    if(HAL_OK != HAL_UART_RegisterCallback(da_uart_p, HAL_UART_RX_COMPLETE_CB_ID,
        &HAL_DA16K_UART_RxCpltCallback) ) {
        return false;
    }
#endif

    HAL_UART_Receive_IT(da_uart_p, (uint8_t *) &rx_byte, 1);
    return true;
}

/* 
 * Function required by the AT cmd lib. This function sends strings of known length via serial port. Should a 2nd
 * call occur before the 1st transmission has completed it will block here until the transfer is complete or a timeout
 * of 500ms expires.
 */
bool da16k_uart_send(const char *src, size_t length) {
    static char tx_buf[2][TERM_LINE_SIZ];
    static int buf_select = 0;
    HAL_StatusTypeDef s;

    if(!src || length==0) {
        return false;
    }

[#if bsp.dmaTx]
    SET_TIMEOUT();
    while(tx_dma_busy){
        if(GET_TIMEOUT()) {
            return false;
        }
    }
    tx_dma_busy = true;
[/#if]

    memcpy(tx_buf[buf_select], src, length);
    do {
[#if bsp.dmaTx]
        s = HAL_UART_Transmit_DMA(da_uart_p, (uint8_t*)tx_buf[buf_select], length);
[#else]
        s = HAL_UART_Transmit(da_uart_p, (uint8_t*)tx_buf[buf_select], length, _500MS);
[/#if]
    }while(s != HAL_OK);

    buf_select = buf_select ? 0:1;

    return true;
}

/* 
 * Function required by the AT cmd lib. This function reads character from the receive buffer of the serial port. If
 * there are no characters to be read the code will block here for the specified timeout length.
 */
da16k_err_t da16k_uart_get_char(char *dst, uint32_t timeout_ms) {
    if(!dst) {
        return DA16K_INVALID_PARAMETER;
    }

    uint32_t expiry = HAL_GetTick() + timeout_ms;
    
    do {
        if(tail != head) {
            *dst = rx_buf[tail];
            if(++tail >= TERM_LINE_SIZ) {
                tail = 0;
            }
            return DA16K_SUCCESS;
        }           
    }while(HAL_GetTick() < expiry);     
    
    return DA16K_TIMEOUT;
}

/* 
 * Function required by the AT cmd lib. This function de-initialises the serial port.
 */
void da16k_uart_close(void) {
    
    BSP_${IpInstance}_DeInit();
    
    return;
}
[/#macro]
[#-- End macro generateBspSPI_Driver --]
