/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : stm32l4xx_nucleo_bus.c
  * @brief          : source file for the BSP BUS IO driver
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
*/
/* USER CODE END Header */

/* Includes ------------------------------------------------------------------*/
#include "stm32l4xx_nucleo_bus.h"
#include <stdbool.h>
#include <string.h>
#include "da16k_uart.h"
#include "da16k_comm.h"

extern UART_HandleTypeDef huart1;
UART_HandleTypeDef *da_uart_p=&huart1;

/** @addtogroup BSP
  * @{
  */

/** @addtogroup STM32L4XX_NUCLEO
  * @{
  */

/** @defgroup STM32L4XX_NUCLEO_BUS STM32L4XX_NUCLEO BUS
  * @{
  */

/** @defgroup STM32L4XX_NUCLEO_BUS_Exported_Variables BUS Exported Variables
  * @{
  */

/**
  * @}
  */

/** @defgroup STM32L4XX_NUCLEO_BUS_Private_Variables BUS Private Variables
  * @{
  */

/**
  * @}
  */

/** @defgroup STM32L4XX_NUCLEO_BUS_Private_FunctionPrototypes  BUS Private Function
  * @{
  */

/**
  * @}
  */

/** @defgroup STM32L4XX_NUCLEO_LOW_LEVEL_Private_Functions STM32L4XX_NUCLEO LOW LEVEL Private Functions
  * @{
  */

/** @defgroup STM32L4XX_NUCLEO_BUS_Exported_Functions STM32L4XX_NUCLEO_BUS Exported Functions
  * @{
  */

/* BUS IO driver over USART Peripheral */

static uint32_t timout;

#define _500MS (50)
#define SET_TIMEOUT() (timout= HAL_GetTick()+_500MS)
#define GET_TIMEOUT() (timout < HAL_GetTick())
#define TERM_LINE_SIZ (256)
static volatile char rx_buf[TERM_LINE_SIZ];
static int head=0, tail=0;

static char rx_byte;

#if (USE_HAL_UART_REGISTER_CALLBACKS == 1)
/*
 * Callback that occurs at the end of a transmission. Clears the tx_dma_busy flag to allow subsequent transmissions.
 */
void HAL_DA16K_UART_TxCpltCallback(UART_HandleTypeDef *huart) {
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

    if(BSP_USART1_Init()) {
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

    memcpy(tx_buf[buf_select], src, length);
    do {
        s = HAL_UART_Transmit(da_uart_p, (uint8_t*)tx_buf[buf_select], length, _500MS);
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

    BSP_USART1_DeInit();

    return;
}

