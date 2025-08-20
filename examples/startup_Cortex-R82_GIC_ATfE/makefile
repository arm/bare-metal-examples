#
# SPDX-FileCopyrightText: Copyright 2007-2026 Arm Limited and/or its affiliates <open-source-office@arm.com>
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


# This makefile is intended for use with GNU make
# This example is intended to be built with Arm Toolchain for Embedded
#
# Environment variables for build options that the user might wish to change
#
# Variable     Example Value
# ----------   -------------
# APP          myapp.axf
# OPT_LEVEL    0, 1, 2 or 3
# DEFINES      -D MYDEFINE

APP ?= startup_Cortex-R82_GIC_ATfE.axf
OPT_LEVEL ?= 1

# Other switches the user should not normally need to change:
CPU = cortex-r82
DEBUG_FLAGS = -g

CC = clang

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

DEPEND_FLAGS = -MD

CPPFLAGS = $(DEFINES) $(INCLUDES) $(DEPEND_FLAGS)
CFLAGS = $(DEBUG_FLAGS) -O$(OPT_LEVEL) # -ffunction-sections -fdata-sections can help to remove more unused code/data, but at the cost of a poor debug illusion around address 0x0
ASFLAGS = $(DEBUG_FLAGS)
LDFLAGS = -T linker.ld -Wl,-Map=linkmap.txt,--gc-sections -nostartfiles -lsemihost -fno-exceptions -fno-rtti -Wl,--entry=Start
TARGET_ARCH = --target=aarch64-none-elf -mcpu=$(CPU) # Used for .c
TARGET_MACH = $(TARGET_ARCH) # Used for .S

APP_C_SRC := $(wildcard *.c)
APP_ASM_SRC := $(wildcard *.S)
OBJ_FILES := $(APP_C_SRC:%.c=%.o) $(APP_ASM_SRC:%.S=%.o)
DEP_FILES := $(OBJ_FILES:%.o=%.d)

.phony: all clean

all: $(APP)

$(APP): $(OBJ_FILES) linker.ld
	$(CC) $(TARGET_ARCH) $(LDFLAGS) -o $@ $(OBJ_FILES)

clean:
	$(call RM_FILES,$(APP) $(OBJ_FILES) $(DEP_FILES) linkmap.txt)

# Make sure everything is rebuilt if this makefile is changed
$(OBJ_FILES) $(APP): makefile

-include $(DEP_FILES)

