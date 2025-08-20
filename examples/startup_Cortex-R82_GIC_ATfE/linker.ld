/*
 * SPDX-FileCopyrightText: Copyright 2022-2026 Arm Limited and/or its affiliates <open-source-office@arm.com>
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

__ROM_BASE = 0x00000000;
__ROM_SIZE = 0x00020000;

__RAM_BASE = 0x00020000;
__RAM_SIZE = 0x00010000;

MEMORY
{
  FLASH (rx)  : ORIGIN = __ROM_BASE, LENGTH = __ROM_SIZE
  RAM   (rwx) : ORIGIN = __RAM_BASE, LENGTH = __RAM_SIZE
}

ENTRY(Start)

SECTIONS
{
    .text 0x0 :
    {
        __code_start = .;
        *(VECTORS)
        KEEP (*(SORT_NONE(.init)))
        *(.text*)
        KEEP (*(SORT_NONE(.fini)))

        *(.rodata .rodata.*)

        KEEP (*(.eh_frame))

        . = ALIGN(8);
        PROVIDE_HIDDEN (__bothinit_array_start = . );
        PROVIDE_HIDDEN (__preinit_array_start = .);
        KEEP (*(.preinit_array))
        PROVIDE_HIDDEN (__preinit_array_end = .);
        PROVIDE_HIDDEN (__init_array_start = .);
        KEEP (*(SORT(.init_array.*)))
        KEEP (*(.init_array))
        PROVIDE_HIDDEN (__init_array_end = .);
        PROVIDE_HIDDEN ( __bothinit_array_end = . );
        PROVIDE_HIDDEN (__fini_array_start = .);
        KEEP (*(SORT(.fini_array.*)))
        KEEP (*(.fini_array))
        PROVIDE_HIDDEN (__fini_array_end = .);
    } > FLASH

    .ARM.extab :
    {
        *(.ARM.extab*)
    } > FLASH

    .ARM.exidx :
    {
        __exidx_start = .;
        *(.ARM.exidx*)
        __exidx_end = .;
        __code_end = .;
    } > FLASH

    .data : ALIGN(4)
    {
        *(.data .data.*)
    } > RAM AT > FLASH

  __data_start = ADDR(.data);
  __data_source = LOADADDR(.data);

    .got :
    {
        *(.got.plt)
        *(.got)
    } > RAM AT > FLASH

  /* Thread local initialized data. This gets
   * space allocated as it is expected to be placed
   * in ram to be used as a template for TLS data blocks
   * allocated at runtime. We're slightly abusing that
   * by placing the data in flash where it will be copied
   * into the allocate ram addresses by the existing
   * data initialization code in crt0
   */
  .tdata :
  {
    *(.tdata .tdata.*)
    __data_end = .;
    __tdata_end = .;
  } > RAM AT > FLASH

  __tls_base = ADDR(.tdata);
  __tdata_start = ADDR(.tdata);
  __tdata_source = LOADADDR(.tdata);
  __tdata_source_end = LOADADDR(.tdata) + SIZEOF(.tdata);
  __tdata_size = SIZEOF(.tdata);
  __tls_align = MAX(ALIGNOF(.tdata), ALIGNOF(.tbss));
  __arm64_tls_tcb_offset = MAX(16, __tls_align);
  __data_size = __data_end - __data_start;
  __rw_data_end_in_rom = __code_end + __data_size;

    .tbss (NOLOAD) :
    {
        . = ALIGN(16);    
        __bss_start = .;
        *(.tbss .tbss.*)
        *(.tcommon)
        . = ALIGN(4);
        __tls_end = .;
        __tbss_end = .;
    } > RAM AT > RAM

    .bss :
    {
        . = ALIGN(4);
        *(.bss*)
        *(COMMON)
        . = ALIGN(64);
        __bss_end = .;
    } > RAM AT > RAM

    __bss_size = __bss_end - __bss_start;

    .heap (NOLOAD) :
    {
        . = ALIGN(8);
        __heap_start = .;
        . = . + 0x1000;
        __heap_end = .;
    } > RAM

    .stack (NOLOAD) :
    {
        . = ALIGN(8);
        . = . + 0x8000;
        __stack = .;
    } > RAM
}
