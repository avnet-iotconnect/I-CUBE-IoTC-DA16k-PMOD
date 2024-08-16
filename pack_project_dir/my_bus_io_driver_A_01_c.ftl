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

extern UART_HandleTypeDef huart2;
static uint32_t timout;

#define _500MS (50)
#define SET_TIMEOUT() (timout= HAL_GetTick()+_500MS)
#define GET_TIMEOUT() (timout < HAL_GetTick())


static char rxByte;
int uart_init(uint32_t baud, uint32_t bits, uint32_t parity, uint32_t stopbits) {
	HAL_UART_Receive_IT(&huart2, (uint8_t *) &rxByte, 1);
	return 0;
}

bool txDmaInUse = false;
void HAL_UART_TxCpltCallback(UART_HandleTypeDef *huart)
{
	if(huart == &huart2) {
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
		s = HAL_UART_Transmit_DMA(&huart2, (uint8_t*)txBuf[bufSelect], length);
	}while(s != HAL_OK);

	bufSelect = bufSelect ? 0:1;

    return length;
}

static volatile char rxBuf[TERM_LINE_SIZ];
static int head=0, tail=0;
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
	if(huart == &huart2) {
		HAL_UART_Receive_IT(&huart2, (uint8_t *) &rxByte, 1);
		rxBuf[head] = rxByte;
		if(++head >= TERM_LINE_SIZ)
			head = 0;
	}
}

size_t uart_recv(char *dst, size_t length) {
#if 0
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
[#-- extern UART_HandleTypeDef h${UsartIpInstance?lower_case};  --]
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
[#-- extern UART_HandleTypeDef h${UsartIpInstance?lower_case}; --]
                    [/#if]
                [#break]
                [#case "UART"]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
                        [#assign USARTDmaIsTrue = bsp.dmaUsed]
[#-- extern UART_HandleTypeDef h${UsartIpInstance?lower_case};  --]
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
[#-- extern UART_HandleTypeDef h${UsartIpInstance?lower_case}; --]
                    [/#if]
                [#break]
                [#case "LPUART"]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
                        [#assign USARTDmaIsTrue = bsp.dmaUsed]
[#-- extern UART_HandleTypeDef h${UsartIpInstance?lower_case};  --]
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
[#-- extern UART_HandleTypeDef h${UsartIpInstance?lower_case}; --]
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
[#-- A.T MX_PPPx_Init prototype updated after review with Maher --]
__weak HAL_StatusTypeDef MX_${UsartIpInstance}_UART_Init(UART_HandleTypeDef* huart);
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
[#-- A.T MX_PPPx_Init prototype updated after review with Maher --]
__weak HAL_StatusTypeDef MX_${UsartIpInstance}_UART_Init(UART_HandleTypeDef* huart);
                    [/#if]
                [#break]
                [#case "UART"]
                    [#assign USARTisTrue = true]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
[#-- A.T MX_PPPx_Init prototype updated after review with Maher --]
__weak HAL_StatusTypeDef MX_${UsartIpInstance}_UART_Init(UART_HandleTypeDef* huart);
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
[#-- A.T MX_PPPx_Init prototype updated after review with Maher --]
__weak HAL_StatusTypeDef MX_${UsartIpInstance}_UART_Init(UART_HandleTypeDef* huart);
                    [/#if]
                [#break]
                [#case "LPUART"]
                    [#assign USARTisTrue = true]
                    [#if UsartIpInstanceList == ""]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = bsp.solution]
[#-- A.T MX_PPPx_Init prototype updated after review with Maher --]
__weak HAL_StatusTypeDef MX_${UsartIpInstance}_UART_Init(UART_HandleTypeDef* huart);
                    [#elseif !UsartIpInstanceList?contains(bsp.solution)]
                        [#assign UsartIpInstance = bsp.solution]
                        [#assign UsartIpInstanceList = UsartIpInstanceList + "," + bsp.solution]
[#-- A.T MX_PPPx_Init prototype updated after review with Maher --]
__weak HAL_StatusTypeDef MX_${UsartIpInstance}_UART_Init(UART_HandleTypeDef* huart);
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
/*******************************************************************************
                            BUS OPERATIONS OVER USART
*******************************************************************************/
/**
  * @brief  Initializes USART HAL.
  * @param  Init : UART initialization parameters
  * @retval BSP status
  */
int32_t BSP_${IpInstance}_Init(void)
{
  int32_t ret = BSP_ERROR_NONE;

  h${IpInstance?lower_case?replace("s","")}.Instance  = ${IpInstance?upper_case};

  if(${UsartIpInstance}InitCounter++ == 0)
  {
    if (HAL_UART_GetState(&h${IpInstance?lower_case?replace("s","")}) == HAL_UART_STATE_RESET)
    {
#if (USE_HAL_UART_REGISTER_CALLBACKS == 0U)
      /* Init the UART Msp */
      ${IpInstance?upper_case}_MspInit(&h${IpInstance?lower_case?replace("s","")});
#else
      if(Is${UsartIpInstance}MspCbValid == 0U)
      {
        if(BSP_${IpInstance?upper_case?replace("s","")}_RegisterDefaultMspCallbacks() != BSP_ERROR_NONE)
        {
          return BSP_ERROR_MSP_FAILURE;
        }
      }
#endif
      if(ret == BSP_ERROR_NONE)
      {
        /* Init the UART */
        [#if halMode]
        if (MX_${IpInstance}_Init(&h${IpInstance?lower_case?replace("s","")}) != HAL_OK)
        [#else]
        if (MX_${IpInstance}_UART_Init(&h${IpInstance?lower_case?replace("s","")}) != HAL_OK)
        [/#if]
        {
          ret = BSP_ERROR_BUS_FAILURE;
        }
      }
    }
  }
  return ret;
}


/**
  * @brief  DeInitializes UART HAL.
  * @retval None
  * @retval BSP status
  */
int32_t BSP_${IpInstance}_DeInit(void)
{
  int32_t ret = BSP_ERROR_BUS_FAILURE;

  if (${UsartIpInstance}InitCounter > 0)
  {
    if (--${UsartIpInstance}InitCounter == 0)
    {
#if (USE_HAL_UART_REGISTER_CALLBACKS == 0U)
      ${IpInstance?upper_case}_MspDeInit(&h${IpInstance?lower_case?replace("s","")});
#endif
      /* DeInit the UART*/
      if (HAL_UART_DeInit(&h${IpInstance?lower_case?replace("s","")}) == HAL_OK)
      {
        ret = BSP_ERROR_NONE;
      }
    }
  }
  return ret;
}


/**
  * @brief  Write Data through UART BUS.
  * @param  pData: Pointer to data buffer to send
  * @param  Length: Length of data in byte
  * @retval BSP status
  */
int32_t BSP_${IpInstance}_Send(uint8_t *pData, uint16_t Length)
{
  int32_t ret = BSP_ERROR_UNKNOWN_FAILURE;

  if(HAL_UART_Transmit(&h${IpInstance?lower_case?replace("s","")}, pData, Length, BUS_${UsartIpInstance}_POLL_TIMEOUT) == HAL_OK)
  {
      ret = BSP_ERROR_NONE;
  }
  return ret;
}


/**
  * @brief  Receive Data from UART BUS
  * @param  pData: Pointer to data buffer to receive
  * @param  Length: Length of data in byte
  * @retval BSP status
  */
int32_t  BSP_${IpInstance}_Recv(uint8_t *pData, uint16_t Length)
{
  int32_t ret = BSP_ERROR_UNKNOWN_FAILURE;

  if(HAL_UART_Receive(&h${IpInstance?lower_case?replace("s","")}, pData, Length, BUS_${UsartIpInstance}_POLL_TIMEOUT) == HAL_OK)
  {
      ret = BSP_ERROR_NONE;
  }
  return ret;
}
[#if bsp.dmaTx]
/**
  * @brief  Write Data through USART BUS with DMA.
  * @param  pData: Pointer to data buffer to send
  * @param  Length: Length of data in byte
  * @retval BSP status
  */
int32_t BSP_${IpInstance}_Send_DMA(uint8_t *pData, uint16_t Length)
{
  int32_t ret = BSP_ERROR_NONE;

  if(HAL_UART_Transmit_DMA(&h${IpInstance?lower_case?replace("s","")}, pData, Length) != HAL_OK)
  {
      ret = BSP_ERROR_UNKNOWN_FAILURE;
  }
  return ret;
}
[/#if]

[#if bsp.dmaRx]
/**
  * @brief  Receive Data from USART BUS with DMA
  * @param  pData: Pointer to data buffer to receive
  * @param  Length: Length of data in byte
  * @retval BSP status
  */
int32_t  BSP_${IpInstance}_Recv_DMA(uint8_t *pData, uint16_t Length)
{
  int32_t ret = BSP_ERROR_NONE;

  if(HAL_UART_Receive_DMA(&h${IpInstance?lower_case?replace("s","")}, pData, Length) != HAL_OK)
  {
      ret = BSP_ERROR_UNKNOWN_FAILURE;
  }
  return ret;
}
[/#if]
[#-- //LC: comment... this is an open point to me... also how UART is implemented. USART has a transmitreceive method, other functions no...

/**
  * @brief  Send and Receive data to/from USART BUS (Full duplex) with DMA
  * @param  pData: Pointer to data buffer to send/receive
  * @param  Length: Length of data in byte
  * @retval BSP status
  */
int32_t BSP_${IpInstance}_SendRecv_DMA(uint8_t *pTxData, uint8_t *pRxData, uint16_t Length)
{
  int32_t ret = BSP_ERROR_NONE;

  //if(HAL_USART_TransmitReceive_DMA(&h${IpInstance?lower_case}, pTxData, pRxData, Length) != HAL_OK)
  //{
      ret = BSP_ERROR_UNKNOWN_FAILURE;
  //}
  return ret;
}

 --]


[/#macro]
[#-- End macro generateBspSPI_Driver --]

/**
  * @brief  Return system tick in ms
  * @retval Current HAL time base time stamp
  */
int32_t BSP_GetTick(void) {
  return HAL_GetTick();
}

[#if UsartIpInstanceList??]
    [#assign usartInsts = UsartIpInstanceList?split(",")]
    [#list usartInsts as UsartIpInst]
        [#if UsartIpInst??]
            [@common.optinclude name=mxTmpFolder+"/${UsartIpInst?lower_case}_IOBus_HalInit.tmp"/]
            [@common.optinclude name=mxTmpFolder+"/${UsartIpInst?lower_case}_IOBus_Msp.tmp"/]
        [/#if]
    [/#list]
[/#if]

/**
  * @}
  */

/**
  * @}
  */

/**
  * @}
  */

/**
  * @}
  */

