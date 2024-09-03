/**
  ******************************************************************************
  * File Name          : App/da16k_config.h
  * Description        : This file provides code for the configuration
  *                      of the App/da16k_config.h instances.
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
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __APP_DA16K_CONFIG__H__
#define __APP_DA16K_CONFIG__H__

#ifdef __cplusplus
 extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/

/**
	MiddleWare name : Avnet-IotConnect.I-CUBE-IoTC-DA16k-PMOD.1.0.0
	MiddleWare fileName : App/da16k_config.h
	MiddleWare version :
*/

/* Define a custom printf-style print function for debug messages (default is printf) */
#ifdef NEEDS_A_CUSTOM_PRINTF
#define DA16K_PRINT DebugPrint
#endif

/* Default allocator functions are malloc and free, however... */

#ifdef ADDED_AN_RTOS_VARIANT
/* This enables vpPortMalloc and vPortFree */
#define DA16K_CONFIG_FREERTOS

/* Soon there might be further (RT)OSs supported here */

/* This overrides any implied alloc functions */
#define DA16K_MALLOC_FN     MyMalloc
#define DA16K_FREE_FN       MyFree
#endif
#ifdef __cplusplus
}
#endif
#endif /*__ APP_DA16K_CONFIG__H_H */

/**
  * @}
  */

/************************ (C) COPYRIGHT Avnet *****END OF FILE****/
