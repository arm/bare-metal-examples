/*
 * SPDX-FileCopyrightText: Copyright 2013-2025 Arm Limited and/or its affiliates <open-source-office@arm.com>
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


//
// Simple utility routines for baremetal v8 code
//


#include "v8_system.h"

    .text

//
// void *ZeroBlock(void *blockPtr, unsigned int nBytes)
//
// Zero fill a block of memory
//   Fill memory pages or similar structures with zeros.
//   The byte count must be a multiple of the block fill size (16 bytes)
//
//  Inputs:
//    blockPtr - base address of block to fill
//    nBytes - block size, in bytes
//
//  Returns:
//    pointer to just filled block, NULL if nBytes is
//  incompatible with block fill size
//
    .global ZeroBlock
    .type ZeroBlock, "function"
    .cfi_startproc
ZeroBlock:

    //
    // we fill data by steam, 16 bytes at a time: check that
    // blocksize is a multiple of that
    //
    ubfx x2, x1, #0, #4
    cbnz x2, incompatible

    //
    // we already have one register full of zeros, get another
    //
    mov x3, x2

    //
    // OK, set temporary pointer and away we go
    //
    add x0, x0, x1

loop0:
    subs x1, x1, #16
    stp  x2, x3, [x0, #-16]!
    b.ne loop0

    //
    // that's all - x0 will be back to its start value
    //
    ret

    //
    // parameters are incompatible with block size - return
    // an indication that this is so
    //
incompatible:
    mov x0,#0
    ret
    .cfi_endproc
