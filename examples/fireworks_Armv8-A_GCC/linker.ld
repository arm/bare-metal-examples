/*
 * SPDX-FileCopyrightText: Copyright 2016-2025 Arm Limited and/or its affiliates <open-source-office@arm.com>
 * SPDX-License-Identifier: MIT
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 * and associated documentation files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or
 * substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
 * BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


/* Linker script to place sections and symbol values */

__ROM_BASE = 0x80000000;
__ROM_SIZE = 0x00080000;

__RAM_BASE = 0x80080000;
__RAM_SIZE = 0x00680000;

MEMORY
{
  FLASH (rx)  : ORIGIN = __ROM_BASE, LENGTH = __ROM_SIZE
  RAM   (rwx) : ORIGIN = __RAM_BASE, LENGTH = __RAM_SIZE
}

ENTRY(start64)

SECTIONS
{
/* Peripherals */

    /*
     * CS3 Peripherals is a 64MB region from 0x1c000000
     * that includes the following:
     * System Registers             at 0x1C010000
     * UART0 (PL011)                at 0x1C090000
     * Color LCD Controller (PL111) at 0x1C1F0000
     * plus a number of others.
     * CS3_PERIPHERALS is used by the startup code for page-table generation
     * This region is not truly empty, but we have no
     * predefined objects that live within it
     */
    __cs3_peripherals  = 0x1c000000;

    /*
     * Place the UART peripheral registers data structure
     * This is only really needed if USE_SERIAL_PORT is defined, but
     * the linker will remove unused sections if not needed
     */
    .pl011  0x1c090000 (NOLOAD):
    {
        *(.pl011)
    }
    /* Note that some other CS3_PERIPHERALS follow this */

    /*
     * GICv3 distributor
     */
    .gicd 0x2f000000 (NOLOAD):
    {
        *(.gicd)
    }

    /*
     * GICv3 redistributors
     * 128KB for each redistributor in the system
     */
    .gicr 0x2f100000 (NOLOAD):
    {
        *(.gicr)
    }

/* Read-Only Sections */

    .vectors 0x80000000:
    {
        __code_start = .;
        KEEP(*(StartUp))
        KEEP(*(EL1VECTORS EL2VECTORS EL3VECTORS InterruptHandlers))
    } > FLASH

    .init :
    {
        KEEP (*(SORT_NONE(.init)))
    } > FLASH

    .text :
    {
        *(.text*)
    } > FLASH

    .fini :
    {
        KEEP (*(SORT_NONE(.fini)))
    } > FLASH

    .rodata :
    {
        *(.rodata .rodata.*)
    } > FLASH

    .eh_frame :
    {
        KEEP (*(.eh_frame))
    } > FLASH

    .preinit_array :
    {
        PROVIDE_HIDDEN (__preinit_array_start = .);
        KEEP (*(.preinit_array))
        PROVIDE_HIDDEN (__preinit_array_end = .);
    } > FLASH

    .init_array 0x80040000 :
    {
        PROVIDE_HIDDEN (__init_array_start = .);
        KEEP (*(SORT(.init_array.*)))
        KEEP (*(.init_array))
        PROVIDE_HIDDEN (__init_array_end = .);
    } > FLASH

    .fini_array :
    {
        PROVIDE_HIDDEN (__fini_array_start = .);
        KEEP (*(SORT(.fini_array.*)))
        KEEP (*(.fini_array))
        PROVIDE_HIDDEN (__fini_array_end = .);
    } > FLASH

/* Read-Write Sections */

    .data :
    {
        . = ALIGN(8);
        __data_start__ = .;
        *(.data .data.*)
    } > RAM AT > FLASH
    __data_source__ = LOADADDR(.data);

    .got :
    {
        *(.got.plt)
        *(.got)
    } > RAM AT > FLASH
    __data_end__ = .;
    __data_size__ = __data_end__ - __data_start__;

    .bss :
    {
        . = ALIGN(4);
        __bss_start__ = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end__ = .;
    } > RAM AT > RAM
    __bss_size__ = __bss_end__ - __bss_start__;

    .heap (NOLOAD):
    {
        . = ALIGN(64);
        __end__ = .;
        PROVIDE(end = .);
        . = . + 0xA0000;
    } > RAM AT > RAM

    .stack (NOLOAD):
    {
        . = ALIGN(64);
        . = . + 8 * 0x4000;
        __stack = .;
    } > RAM AT > RAM

    .el3_stack (NOLOAD):
    {
        . = ALIGN(64);
        . = . + 8 * 0x1000;
        __el3_stack = .;
    } > RAM AT > RAM

    .ttb0_l1 (NOLOAD):
    {
        . = ALIGN(4096);
        __ttb0_l1 = .;
        . = . + 0x1000;
    } > RAM AT > RAM

    .ttb0_l2_ram (NOLOAD):
    {
        . = ALIGN(4096);
        __ttb0_l2_ram = .;
        . = . + 0x1000;
    } > RAM AT > RAM

    .ttb0_l2_periph (NOLOAD):
    {
        . = ALIGN(4096);
        __ttb0_l2_periph = .;
        . = . + 0x1000;
    } > RAM AT > RAM

    .framebuffer 0x80600000 (NOLOAD):
    {
        . = . + 0x00100000;
    } > RAM AT > RAM

    /*
     * The startup code uses the end of this region to calculate
     * the top of memory - don't place any RAM regions after it
     */
    __top_of_ram = .;
}
