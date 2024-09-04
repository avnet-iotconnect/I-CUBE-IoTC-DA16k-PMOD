################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../iotc_da16k_pmod/Target/da16k_uart.c 

OBJS += \
./iotc_da16k_pmod/Target/da16k_uart.o 

C_DEPS += \
./iotc_da16k_pmod/Target/da16k_uart.d 


# Each subdirectory must supply rules for building sources it contributes
iotc_da16k_pmod/Target/%.o iotc_da16k_pmod/Target/%.su iotc_da16k_pmod/Target/%.cyclo: ../iotc_da16k_pmod/Target/%.c iotc_da16k_pmod/Target/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -g3 -DDEBUG -DUSE_FULL_LL_DRIVER '-DDA16K_CONFIG_FILE="da16k_config.h"' -DUSE_HAL_DRIVER -DSTM32U585xx -c -I../iotc_da16k_pmod/App -I../iotc_da16k_pmod -I../Drivers/BSP/B-U585I-IOT02A -I../Core/Inc -I../Drivers/STM32U5xx_HAL_Driver/Inc -I../Drivers/STM32U5xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32U5xx/Include -I../Drivers/CMSIS/Include -I../Drivers/BSP/iotc_da16k_pmod -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@"  -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-iotc_da16k_pmod-2f-Target

clean-iotc_da16k_pmod-2f-Target:
	-$(RM) ./iotc_da16k_pmod/Target/da16k_uart.cyclo ./iotc_da16k_pmod/Target/da16k_uart.d ./iotc_da16k_pmod/Target/da16k_uart.o ./iotc_da16k_pmod/Target/da16k_uart.su

.PHONY: clean-iotc_da16k_pmod-2f-Target

