[#ftl]
/**
  ******************************************************************************
  * File Name          : ${name}
  * Description        : This file provides code for the configuration
  *                      of the ${name} instances.
  ******************************************************************************
[@common.optinclude name=mxTmpFolder+"/license.tmp"/][#--include License text --]
  ******************************************************************************
  */
[#assign s = name]
[#assign toto = s?replace(".","__","/")]
[#assign dashReplace = toto?replace("-","_","/")]
[#assign inclusion_protection = dashReplace?upper_case]
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __${inclusion_protection}__
#define __${inclusion_protection}__

#ifdef __cplusplus
 extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
[#if includes??]
[#list includes as include]
#include "${include}"
[/#list]
[/#if]

[#-- SWIPdatas is a list of SWIPconfigModel --]  
[#list SWIPdatas as SWIP]  
[#-- Global variables --]
[#if SWIP.variables??]
	[#list SWIP.variables as variable]
extern ${variable.value} ${variable.name};
	[/#list]
[/#if]

[#-- Global variables --]

[#assign instName = SWIP.ipName]   
[#assign fileName = SWIP.fileName]   
[#assign version = SWIP.version]   

/**
	MiddleWare name : ${instName}
	MiddleWare fileName : ${fileName}
	MiddleWare version : ${version}
*/
[#if SWIP.defines??]
	[#list SWIP.defines as definition]	
/*---------- [#if definition.comments??]${definition.comments} [/#if] -----------*/
#define ${definition.name} #t#t ${definition.value} 
[#if definition.description??]${definition.description} [/#if]
	[/#list]
[/#if]



[/#list]

/* Define a custom printf-style print function for debug messages (default is printf) */
#ifdef NEEDS_A_CUSTOM_PRINTF
#define DA16K_PRINT DebugPrint
#endif ADDED_AN_RTOS_VARIANT

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
#endif /*__ ${inclusion_protection}_H */

/**
  * @}
  */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
