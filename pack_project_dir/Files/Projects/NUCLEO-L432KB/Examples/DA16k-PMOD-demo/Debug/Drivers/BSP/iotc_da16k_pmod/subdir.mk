################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Drivers/BSP/iotc_da16k_pmod/da16k_at.c \
../Drivers/BSP/iotc_da16k_pmod/da16k_comm.c \
../Drivers/BSP/iotc_da16k_pmod/da16k_sys.c 

OBJS += \
./Drivers/BSP/iotc_da16k_pmod/da16k_at.o \
./Drivers/BSP/iotc_da16k_pmod/da16k_comm.o \
./Drivers/BSP/iotc_da16k_pmod/da16k_sys.o 

C_DEPS += \
./Drivers/BSP/iotc_da16k_pmod/da16k_at.d \
./Drivers/BSP/iotc_da16k_pmod/da16k_comm.d \
./Drivers/BSP/iotc_da16k_pmod/da16k_sys.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/BSP/iotc_da16k_pmod/%.o Drivers/BSP/iotc_da16k_pmod/%.su Drivers/BSP/iotc_da16k_pmod/%.cyclo: ../Drivers/BSP/iotc_da16k_pmod/%.c Drivers/BSP/iotc_da16k_pmod/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32L432xx '-DDA16K_CONFIG_FILE="da16k_config.h"' -c -I../Core/Inc -I../Drivers/STM32L4xx_HAL_Driver/Inc -I../Drivers/STM32L4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32L4xx/Include -I../Drivers/CMSIS/Include -I../iotc_da16k_pmod/App -I../iotc_da16k_pmod -I../Drivers/BSP/iotc_da16k_pmod -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@"  -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-BSP-2f-iotc_da16k_pmod

clean-Drivers-2f-BSP-2f-iotc_da16k_pmod:
	-$(RM) ./Drivers/BSP/iotc_da16k_pmod/da16k_at.cyclo ./Drivers/BSP/iotc_da16k_pmod/da16k_at.d ./Drivers/BSP/iotc_da16k_pmod/da16k_at.o ./Drivers/BSP/iotc_da16k_pmod/da16k_at.su ./Drivers/BSP/iotc_da16k_pmod/da16k_comm.cyclo ./Drivers/BSP/iotc_da16k_pmod/da16k_comm.d ./Drivers/BSP/iotc_da16k_pmod/da16k_comm.o ./Drivers/BSP/iotc_da16k_pmod/da16k_comm.su ./Drivers/BSP/iotc_da16k_pmod/da16k_sys.cyclo ./Drivers/BSP/iotc_da16k_pmod/da16k_sys.d ./Drivers/BSP/iotc_da16k_pmod/da16k_sys.o ./Drivers/BSP/iotc_da16k_pmod/da16k_sys.su

.PHONY: clean-Drivers-2f-BSP-2f-iotc_da16k_pmod

