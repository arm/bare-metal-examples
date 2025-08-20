#
# SPDX-FileCopyrightText: Copyright 2014-2026 Arm Limited and/or its affiliates <open-source-office@arm.com>
# SPDX-License-Identifier: MIT
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#


# This example is intended to be built with GCC for bare-metal targets
#
# Environment variables for build options that the user might wish to change
#
# Variable     Example Value
# ----------   -------------
# APP          myapp.axf
# QUIET        @ for terse output, or leave blank for detailed output
# OPT_LEVEL    0, 1, 2 or 3
# DEFINES      -D MYDEFINE
# PLATFORM     CORTEXA (adds extra code for initialising Cortex-A34/A35/A53/A57/A72/A73), CORTEXA_FCM (use Armv8.1-A FEAT_LSE atomics), or AEM
# OUTPUTCHAN   UART (a terminal will open in the model), or SEMIHOSTED

APP ?= fireworks_Armv8-A_GCC.axf
QUIET ?= @
OPT_LEVEL ?= 1
DEFINES ?= -D SMP
PLATFORM ?= AEM
OUTPUTCHAN ?= UART

# Other switches the user should not normally need to change:
ARCH = armv8-a
DEBUG_FLAGS = -g


ifeq "$(PLATFORM)" "CORTEXA"
	CPPFLAGS_EXTRA += -D CORTEXA
endif

ifeq "$(PLATFORM)" "CORTEXA_FCM"
	CPPFLAGS_EXTRA += -D USE_LSE_ATOMIC
endif


ifeq "$(OUTPUTCHAN)" "UART"
	CPPFLAGS_EXTRA += -D USE_SERIAL_PORT -D STANDALONE
	LDFLAGS_EXTRA = --specs=nosys.specs
else
	LDFLAGS_EXTRA = --specs=rdimon.specs
endif


ifeq ($(QUIET),@)
PROGRESS = @echo Compiling $<...
endif


CC = aarch64-none-elf-gcc
SRC_DIR = src
ASM_DIR = asm
OBJ_DIR = obj

INCLUDES = -I$(SRC_DIR)

define EOL =


endef

ifeq ($(OS),Windows_NT)
SHELL=$(windir)\system32\cmd.exe
RM_FILES = $(foreach file,$(1),if exist $(file) del /q $(file)$(EOL))
RM_DIRS = $(foreach dir,$(1),if exist $(dir) rmdir /s /q $(dir)$(EOL))
else
RM_FILES = $(foreach file,$(1),rm -f $(file)$(EOL))
RM_DIRS = $(foreach dir,$(1),rm -rf $(dir)$(EOL))
endif

DEPEND_FLAGS = -MD -MF $@.d
CPPFLAGS = $(DEFINES) $(INCLUDES) $(DEPEND_FLAGS) $(CPPFLAGS_EXTRA)
CFLAGS = $(DEBUG_FLAGS) -O$(OPT_LEVEL)
ASFLAGS = $(DEBUG_FLAGS)
LDFLAGS = -T linker.ld -Wl,-Map=linkmap.txt $(LDFLAGS_EXTRA)
TARGET_ARCH = -march=$(ARCH)

APP_C_SRC := $(wildcard $(SRC_DIR)/*.c)
APP_S_SRC := $(wildcard $(ASM_DIR)/*.S)
OBJ_FILES := $(APP_C_SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o) \
             $(APP_S_SRC:$(ASM_DIR)/%.S=$(OBJ_DIR)/%.o)
DEP_FILES := $(OBJ_FILES:%=%.d)

.phony: all clean

all: $(APP)

$(APP): $(OBJ_FILES) linker.ld
	@echo Linking $@
	$(QUIET) $(CC) $(TARGET_ARCH) $(LDFLAGS) --output $@ $(OBJ_FILES)
	@echo Done.

clean:
	$(call RM_DIRS,$(OBJ_DIR))
	$(call RM_FILES,$(APP) linkmap.txt)

$(OBJ_DIR):
	mkdir $@

$(OBJ_DIR)/%.o : $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(PROGRESS)
	$(QUIET) $(CC) -c $(TARGET_ARCH) $(CPPFLAGS) $(CFLAGS) -o $@ $<

$(OBJ_DIR)/%.o : $(ASM_DIR)/%.S | $(OBJ_DIR)
	$(PROGRESS)
	$(QUIET) $(CC) -c $(TARGET_ARCH) $(CPPFLAGS) $(ASFLAGS) -o $@ $<

# Make sure everything is rebuilt if this makefile is changed
$(OBJ_FILES) $(APP): makefile

-include $(DEP_FILES)

help:
	@echo make [OPTIONS]
	@echo 'PLATFORM= [CORTEXA/CORTEXA_FCM/AEM]  CORTEXA (adds extra code for initialising Cortex-A34/A35/A53/A57/A72/A73), CORTEXA_FCM (use Armv8.1-A FEAT_LSE atomics), or AEM'
	@echo 'OUTPUTCHAN= [UART/SEMIHOSTED]   Select semihosted or PL011 UART for output'
	@echo ''
	@echo 'NOTE: The first value in the options indicates the default setting.'
