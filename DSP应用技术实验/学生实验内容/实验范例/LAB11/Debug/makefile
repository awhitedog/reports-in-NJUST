################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL = cmd.exe

CG_TOOL_ROOT := D:/ti/ccsv5/tools/compiler/c2000_6.1.0

ORDERED_OBJS += \
$(GEN_CMDS__FLAG) \
"./source/DSP2833x_usDelay.obj" \
"./source/DSP2833x_Xintf.obj" \
"./source/DSP2833x_SysCtrl.obj" \
"./source/DSP2833x_Spi.obj" \
"./source/DSP2833x_Sci.obj" \
"./source/DSP2833x_PieVect.obj" \
"./source/DSP2833x_PieCtrl.obj" \
"./source/DSP2833x_MemCopy.obj" \
"./source/DSP2833x_Mcbsp.obj" \
"./source/DSP2833x_Lcd.obj" \
"./source/DSP2833x_I2C.obj" \
"./source/DSP2833x_Gpio.obj" \
"./source/DSP2833x_GlobalVariableDefs.obj" \
"./source/DSP2833x_EQep.obj" \
"./source/DSP2833x_EPwm.obj" \
"./source/DSP2833x_ECap.obj" \
"./source/DSP2833x_ECan.obj" \
"./source/DSP2833x_DisInt.obj" \
"./source/DSP2833x_DefaultIsr.obj" \
"./source/DSP2833x_DMA.obj" \
"./source/DSP2833x_DBGIER.obj" \
"./source/DSP2833x_CpuTimers.obj" \
"./source/DSP2833x_CodeStartBranch.obj" \
"./source/DSP2833x_CSMPasswords.obj" \
"./source/DSP2833x_Adc.obj" \
"./source/DSP2833x_ADC_cal.obj" \
"./LAB11_main.obj" \
-l"libc.a" \
"../28335_RAM_lnk.cmd" \
"../DSP2833x_Headers_nonBIOS.cmd" \

-include ../makefile.init

RM := DEL /F
RMDIR := RMDIR /S/Q

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir_vars.mk
-include source/subdir_vars.mk
-include subdir_rules.mk
-include source/subdir_rules.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(S62_DEPS)),)
-include $(S62_DEPS)
endif
ifneq ($(strip $(C64_DEPS)),)
-include $(C64_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(S55_DEPS)),)
-include $(S55_DEPS)
endif
ifneq ($(strip $(C67_DEPS)),)
-include $(C67_DEPS)
endif
ifneq ($(strip $(C??_DEPS)),)
-include $(C??_DEPS)
endif
ifneq ($(strip $(CLA_DEPS)),)
-include $(CLA_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(S??_DEPS)),)
-include $(S??_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(C62_DEPS)),)
-include $(C62_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(ASM_UPPER_DEPS)),)
-include $(ASM_UPPER_DEPS)
endif
ifneq ($(strip $(K_DEPS)),)
-include $(K_DEPS)
endif
ifneq ($(strip $(C43_DEPS)),)
-include $(C43_DEPS)
endif
ifneq ($(strip $(S67_DEPS)),)
-include $(S67_DEPS)
endif
ifneq ($(strip $(SA_DEPS)),)
-include $(SA_DEPS)
endif
ifneq ($(strip $(S43_DEPS)),)
-include $(S43_DEPS)
endif
ifneq ($(strip $(OPT_DEPS)),)
-include $(OPT_DEPS)
endif
ifneq ($(strip $(S64_DEPS)),)
-include $(S64_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(C55_DEPS)),)
-include $(C55_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 

# All Target
all: LAB11_WN.out

# Tool invocations
LAB11_WN.out: $(OBJS) $(CMD_SRCS) $(GEN_CMDS)
	@echo 'Building target: $@'
	@echo 'Invoking: C2000 Linker'
	"D:/ti/ccsv5/tools/compiler/c2000_6.1.0/bin/cl2000" -v28 -ml -mt --float_support=fpu32 -g --diag_warning=225 --display_error_number --diag_wrap=off -z --stack_size=0x300 -m"LAB11_WN.map" --warn_sections -i"D:/ti/ccsv5/tools/compiler/c2000_6.1.0/lib" -i"D:/ti/ccsv5/tools/compiler/c2000_6.1.0/include" --reread_libs --display_error_number --diag_wrap=off --rom_model -o "LAB11_WN.out" $(ORDERED_OBJS)
	@echo 'Finished building target: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(C2000_EXECUTABLE_OUTPUTS__QUOTED) "LAB11_WN.out"
	-$(RM) "LAB11_main.pp" "source\DSP2833x_Adc.pp" "source\DSP2833x_CpuTimers.pp" "source\DSP2833x_DMA.pp" "source\DSP2833x_DefaultIsr.pp" "source\DSP2833x_ECan.pp" "source\DSP2833x_ECap.pp" "source\DSP2833x_EPwm.pp" "source\DSP2833x_EQep.pp" "source\DSP2833x_GlobalVariableDefs.pp" "source\DSP2833x_Gpio.pp" "source\DSP2833x_I2C.pp" "source\DSP2833x_Lcd.pp" "source\DSP2833x_Mcbsp.pp" "source\DSP2833x_MemCopy.pp" "source\DSP2833x_PieCtrl.pp" "source\DSP2833x_PieVect.pp" "source\DSP2833x_Sci.pp" "source\DSP2833x_Spi.pp" "source\DSP2833x_SysCtrl.pp" "source\DSP2833x_Xintf.pp" 
	-$(RM) "LAB11_main.obj" "source\DSP2833x_ADC_cal.obj" "source\DSP2833x_Adc.obj" "source\DSP2833x_CSMPasswords.obj" "source\DSP2833x_CodeStartBranch.obj" "source\DSP2833x_CpuTimers.obj" "source\DSP2833x_DBGIER.obj" "source\DSP2833x_DMA.obj" "source\DSP2833x_DefaultIsr.obj" "source\DSP2833x_DisInt.obj" "source\DSP2833x_ECan.obj" "source\DSP2833x_ECap.obj" "source\DSP2833x_EPwm.obj" "source\DSP2833x_EQep.obj" "source\DSP2833x_GlobalVariableDefs.obj" "source\DSP2833x_Gpio.obj" "source\DSP2833x_I2C.obj" "source\DSP2833x_Lcd.obj" "source\DSP2833x_Mcbsp.obj" "source\DSP2833x_MemCopy.obj" "source\DSP2833x_PieCtrl.obj" "source\DSP2833x_PieVect.obj" "source\DSP2833x_Sci.obj" "source\DSP2833x_Spi.obj" "source\DSP2833x_SysCtrl.obj" "source\DSP2833x_Xintf.obj" "source\DSP2833x_usDelay.obj" 
	-$(RM) "source\DSP2833x_ADC_cal.pp" "source\DSP2833x_CSMPasswords.pp" "source\DSP2833x_CodeStartBranch.pp" "source\DSP2833x_DBGIER.pp" "source\DSP2833x_DisInt.pp" "source\DSP2833x_usDelay.pp" 
	-@echo 'Finished clean'
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
