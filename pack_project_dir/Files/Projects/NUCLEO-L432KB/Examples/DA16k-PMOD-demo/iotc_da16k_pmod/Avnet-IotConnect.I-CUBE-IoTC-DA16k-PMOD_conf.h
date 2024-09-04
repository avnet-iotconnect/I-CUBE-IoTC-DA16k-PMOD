/**
  ******************************************************************************
  * File Name          : Avnet-IotConnect.I-CUBE-IoTC-DA16k-PMOD_conf.h
  * Description        : This file provides code for the configuration
  *                      of the Avnet-IotConnect.I-CUBE-IoTC-DA16k-PMOD_conf.h instances.
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
#ifndef __AVNET_IOTCONNECT__I_CUBE_IOTC_DA16K_PMOD_CONF__H__
#define __AVNET_IOTCONNECT__I_CUBE_IOTC_DA16K_PMOD_CONF__H__

#ifdef __cplusplus
 extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/

/**
	MiddleWare name : Avnet-IotConnect.I-CUBE-IoTC-DA16k-PMOD.1.0.0
	MiddleWare fileName : ./Avnet-IotConnect.I-CUBE-IoTC-DA16k-PMOD_conf.h
	MiddleWare version :
*/
#define iotc_mode      DA16K_IOTC_AWS

/*---------- iotc_duid  -----------*/
#define iotc_duid      "pyda16kpmod"

/*---------- iotc_env  -----------*/
#define iotc_env      "poc"

/*---------- iotc_wifi_ssid  -----------*/
#define iotc_wifi_ssid      "TheBatCave"

/*---------- iotc_wifi_passphrase  -----------*/
#define iotc_wifi_passphrase      "r0b1n5ux"

/*---------- iotc_wifi_hidden_network  -----------*/
#define iotc_wifi_hidden_network      false

/*---------- iotc_wifi_connection_timeout  -----------*/
#define iotc_wifi_connection_timeout      150000

/*---------- iotc_cpid  -----------*/
#define iotc_cpid      "97FF86E8728645E9B89F7B07977E4B15"

/*---------- iotc_server_connect_timeout_ms  -----------*/
#define iotc_server_connect_timeout_ms      150000

/*---------- iotc_network_timeout_ms  -----------*/
#define iotc_network_timeout_ms      20000

#ifdef __cplusplus
}
#endif
#endif /*__ AVNET_IOTCONNECT__I_CUBE_IOTC_DA16K_PMOD_CONF__H_H */

/**
  * @}
  */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
