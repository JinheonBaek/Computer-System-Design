################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/temp/lscript.ld 

S_SRCS += \
../src/temp/csd_translation_table.s 

S_UPPER_SRCS += \
../src/temp/csd_asm.S 

OBJS += \
./src/temp/csd_asm.o \
./src/temp/csd_translation_table.o 

S_UPPER_DEPS += \
./src/temp/csd_asm.d 


# Each subdirectory must supply rules for building sources it contributes
src/temp/%.o: ../src/temp/%.S
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I../../csd_lab_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/temp/%.o: ../src/temp/%.s
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc assembler'
	arm-none-eabi-gcc -c  -o"$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


