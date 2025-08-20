/*
 * SPDX-FileCopyrightText: Copyright 2014-2026 Arm Limited and/or its affiliates <open-source-office@arm.com>
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


// ------------------------------------------------------------
// AArch64 Vector tables
// ------------------------------------------------------------


    .global el1_vectors
    .global el2_vectors
    .global el3_vectors
    .global c0sync1
    .global irqHandler
    .global fiqHandler
    .global irqFirstLevelHandler
    .global fiqFirstLevelHandler

    .section  EL1VECTORS, "ax"
    .align 11

//
// Current EL with SP0
//
el1_vectors:
c0sync1: B c0sync1

    .balign 0x80
c0irq1: B irqFirstLevelHandler

    .balign 0x80
c0fiq1: B fiqFirstLevelHandler

    .balign 0x80
c0serr1: B c0serr1

//
// Current EL with SPx
//
    .balign 0x80
cxsync1: B cxsync1

    .balign 0x80
cxirq1: B irqFirstLevelHandler

    .balign 0x80
cxfiq1: B fiqFirstLevelHandler

    .balign 0x80
cxserr1: B cxserr1

//
// Lower EL using AArch64
//
    .balign 0x80
l64sync1: B l64sync1

    .balign 0x80
l64irq1: B irqFirstLevelHandler

    .balign 0x80
l64fiq1: B fiqFirstLevelHandler

    .balign 0x80
l64serr1: B l64serr1

//
// Lower EL using AArch32
//
    .balign 0x80
l32sync1: B l32sync1

    .balign 0x80
l32irq1: B irqFirstLevelHandler

    .balign 0x80
l32fiq1: B fiqFirstLevelHandler

    .balign 0x80
l32serr1: B l32serr1

//----------------------------------------------------------------

    .section  EL2VECTORS, "ax"
    .align 11

//
// Current EL with SP0
//
el2_vectors:
c0sync2: B c0sync2

    .balign 0x80
c0irq2: B irqFirstLevelHandler

    .balign 0x80
c0fiq2: B fiqFirstLevelHandler

    .balign 0x80
c0serr2: B c0serr2

//
// Current EL with SPx
//
    .balign 0x80
cxsync2: B cxsync2

    .balign 0x80
cxirq2: B irqFirstLevelHandler

    .balign 0x80
cxfiq2: B fiqFirstLevelHandler

    .balign 0x80
cxserr2: B cxserr2

//
// Lower EL using AArch64
//
    .balign 0x80
l64sync2: B l64sync2

    .balign 0x80
l64irq2: B irqFirstLevelHandler

    .balign 0x80
l64fiq2: B fiqFirstLevelHandler

    .balign 0x80
l64serr2: B l64serr2

//
// Lower EL using AArch32
//
    .balign 0x80
l32sync2: B l32sync2

    .balign 0x80
l32irq2: B irqFirstLevelHandler

    .balign 0x80
l32fiq2: B fiqFirstLevelHandler

    .balign 0x80
l32serr2: B l32serr2

//----------------------------------------------------------------

    .section  EL3VECTORS, "ax"
    .align 11

//
// Current EL with SP0
//
el3_vectors:
c0sync3: B c0sync3

    .balign 0x80
c0irq3: B irqFirstLevelHandler

    .balign 0x80
c0fiq3: B fiqFirstLevelHandler

    .balign 0x80
c0serr3: B c0serr3

//
// Current EL with SPx
//
    .balign 0x80
cxsync3: B cxsync3

    .balign 0x80
cxirq3: B irqFirstLevelHandler

    .balign 0x80
cxfiq3: B fiqFirstLevelHandler

    .balign 0x80
cxserr3: B cxserr3

//
// Lower EL using AArch64
//
    .balign 0x80
l64sync3: B l64sync3

    .balign 0x80
l64irq3: B irqFirstLevelHandler

    .balign 0x80
l64fiq3: B fiqFirstLevelHandler

    .balign 0x80
l64serr3: B l64serr3

//
// Lower EL using AArch32
//
    .balign 0x80
l32sync3: B l32sync3

    .balign 0x80
l32irq3: B irqFirstLevelHandler

    .balign 0x80
l32fiq3: B fiqFirstLevelHandler

    .balign 0x80
l32serr3: B l32serr3


    .section InterruptHandlers, "ax"
    .balign 4

    .type irqFirstLevelHandler, "function"
irqFirstLevelHandler:
  STP      x29, x30, [sp, #-16]!
  STP      x18, x19, [sp, #-16]!
  STP      x16, x17, [sp, #-16]!
  STP      x14, x15, [sp, #-16]!
  STP      x12, x13, [sp, #-16]!
  STP      x10, x11, [sp, #-16]!
  STP      x8, x9, [sp, #-16]!
  STP      x6, x7, [sp, #-16]!
  STP      x4, x5, [sp, #-16]!
  STP      x2, x3, [sp, #-16]!
  STP      x0, x1, [sp, #-16]!

  BL       irqHandler

  LDP      x0, x1, [sp], #16
  LDP      x2, x3, [sp], #16
  LDP      x4, x5, [sp], #16
  LDP      x6, x7, [sp], #16
  LDP      x8, x9, [sp], #16
  LDP      x10, x11, [sp], #16
  LDP      x12, x13, [sp], #16
  LDP      x14, x15, [sp], #16
  LDP      x16, x17, [sp], #16
  LDP      x18, x19, [sp], #16
  LDP      x29, x30, [sp], #16
  ERET

    .type fiqFirstLevelHandler, "function"
fiqFirstLevelHandler:
  STP      x29, x30, [sp, #-16]!
  STP      x18, x19, [sp, #-16]!
  STP      x16, x17, [sp, #-16]!
  STP      x14, x15, [sp, #-16]!
  STP      x12, x13, [sp, #-16]!
  STP      x10, x11, [sp, #-16]!
  STP      x8, x9, [sp, #-16]!
  STP      x6, x7, [sp, #-16]!
  STP      x4, x5, [sp, #-16]!
  STP      x2, x3, [sp, #-16]!
  STP      x0, x1, [sp, #-16]!

  BL       fiqHandler

  LDP      x0, x1, [sp], #16
  LDP      x2, x3, [sp], #16
  LDP      x4, x5, [sp], #16
  LDP      x6, x7, [sp], #16
  LDP      x8, x9, [sp], #16
  LDP      x10, x11, [sp], #16
  LDP      x12, x13, [sp], #16
  LDP      x14, x15, [sp], #16
  LDP      x16, x17, [sp], #16
  LDP      x18, x19, [sp], #16
  LDP      x29, x30, [sp], #16
  ERET
