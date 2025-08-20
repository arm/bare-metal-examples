/*
 * SPDX-FileCopyrightText: Copyright 2012-2026 Arm Limited and/or its affiliates <open-source-office@arm.com>
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
// AArch64 - Common helper functions
// ------------------------------------------------------------

#include "v8_system.h"

    .text

    .global EnableCachesEL1
    .global DisableCachesEL1
    .global InvalidateUDCaches
    .global GetMIDR
    .global GetMPIDR
    .global GetAffinity
    .global GetCPUID

// ------------------------------------------------------------

//
// void EnableCachesEL1(void)
//
//    enable Instruction and Data caches
//
    .type EnableCachesEL1, "function"
    .cfi_startproc
EnableCachesEL1:

    mrs x0, SCTLR_EL1
    orr x0, x0, #SCTLR_ELx_I
    orr x0, x0, #SCTLR_ELx_C
    msr SCTLR_EL1, x0

    isb
    ret
    .cfi_endproc


// ------------------------------------------------------------

    .type DisableCachesEL1, "function"
    .cfi_startproc
DisableCachesEL1:

    mrs x0, SCTLR_EL1
    bic x0, x0, #SCTLR_ELx_I
    bic x0, x0, #SCTLR_ELx_C
    msr SCTLR_EL1, x0

    isb
    ret
    .cfi_endproc


// ------------------------------------------------------------

//
// void InvalidateUDCaches(void)
//
//    Invalidate data and unified caches
//
    .type InvalidateUDCaches, "function"
    .cfi_startproc
InvalidateUDCaches:
    // From the Arm Architecture Reference Manual

    dmb  ish                   // ensure all prior inner-shareable accesses have been observed

    mrs  x0, CLIDR_EL1
    and  w3, w0, #0x07000000   // get 2 x level of coherence
    lsr  w3, w3, #23
    cbz  w3, finished
    mov  w10, #0               // w10 = 2 x cache level
    mov  w8, #1                // w8 = constant 0b1
    mrs  x12, ID_MMFR4_EL1
    ubfx x12, x12, #24, #4     // extract ccidx from id_mmfr4_el1
loop_level:
    add  w2, w10, w10, lsr #1  // calculate 3 x cache level
    lsr  w1, w0, w2            // extract 3-bit cache type for this level
    and  w1, w1, #0x7
    cmp  w1, #2
    b.lt next_level            // no data or unified cache at this level
    msr  CSSELR_EL1, x10       // select this cache level
    isb                        // synchronize change of csselr
    mrs  x1, CCSIDR_EL1        // read ccsidr
    and  w2, w1, #7            // w2 = log2(linelen)-4
    add  w2, w2, #4            // w2 = log2(linelen)
    cbz x12, no_ccidx          // id_mmfr4_el1.ccidx == 0x0
    ubfx x4, x1, #3, #21       // x4 = max way number, right aligned
    b skip1
no_ccidx:
    ubfx w4, w1, #3, #10       // w4 = max way number, right aligned
skip1:
    clz  w5, w4                // w5 = 32-log2(ways), bit position of way in dc operand
    lsl  w9, w4, w5            // w9 = max way number, aligned to position in dc operand
    lsl  w16, w8, w5           // w16 = amount to decrement way number per iteration
loop_way:
    cbz x12, no_ccidx2         // id_mmfr4_el1.ccidx == 0x0
    ubfx x7, x1, #32, #24      // x7 = max set number, right aligned
    b skip2
no_ccidx2:
    ubfx w7, w1, #13, #15      // w7 = max set number, right aligned
skip2:
    lsl  w7, w7, w2            // w7 = max set number, aligned to position in dc operand
    lsl  w17, w8, w2           // w17 = amount to decrement set number per iteration
loop_set:
    orr  w11, w10, w9          // w11 = combine way number and cache number ...
    orr  w11, w11, w7          // ... and set number for dc operand
    dc   isw, x11              // do data cache invalidate by set and way
    subs w7, w7, w17           // decrement set number
    b.ge loop_set
    subs x9, x9, x16           // decrement way number
    b.ge loop_way
next_level:
    add  w10, w10, #2          // increment 2 x cache level
    cmp  w3, w10
    b.gt loop_level
    dsb  sy                    // ensure completion of previous cache maintenance operation
    isb
finished:
    ret
    .cfi_endproc


// ------------------------------------------------------------

//
// ID Register functions
//

    .type GetMIDR, "function"
    .cfi_startproc
GetMIDR:

    mrs x0, MIDR_EL1
    ret
    .cfi_endproc


    .type GetMPIDR, "function"
    .cfi_startproc
GetMPIDR:

    mrs x0, MPIDR_EL1
    ret
    .cfi_endproc


    .type GetAffinity, "function"
    .cfi_startproc
GetAffinity:

    mrs x0, MPIDR_EL1
    ubfx x1, x0, #32, #8
    bfi  w0, w1, #24, #8
    ret
    .cfi_endproc


    .type GetCPUID, "function"
    .cfi_startproc
GetCPUID:

    mrs x0, MIDR_EL1
    ubfx    x0, x0, #4, #12 // extract PartNum
    cmp x0, #0xD0F          // AEMvA or RevC_2xAEMvA FVP model
    b.eq AEM
    cmp x0, #0xD05          // Cortex-A55
    b.eq DynamIQ
    cmp x0, #0xD06          // Cortex-A65
    b.eq DualThreaded
    cmp x0, #0xD4A          // Neoverse E1
    b.eq DualThreaded
    cmp x0, #0xD0A          // Cortex-A75 or higher
    b.pl DynamIQ
    b Others

DualThreaded:                                                  // Cortex-A65 or Neoverse E1
    mrs x0, MPIDR_EL1
    ubfx    x1, x0, #MPIDR_EL1_AFF1_LSB, #MPIDR_EL1_AFF_WIDTH  // AFF1=CPUID
    add x1, x1, x1                                             // two threads per CPU
    ubfx    x0, x0, #MPIDR_EL1_AFF0_LSB, #MPIDR_EL1_AFF_WIDTH  // AFF0=affinity
    add x0, x1, x0                                             // Thread ID
    ret

DynamIQ:                                                       // Cortex-A55, Cortex-A75 or higher
    mrs x1, MPIDR_EL1
    ubfx    x0, x1, #MPIDR_EL1_AFF1_LSB, #MPIDR_EL1_AFF_WIDTH
    cmp x0, #0
    b.ne SkipAFF2                                              // Special case for e.g. Neoverse_N2x1_Neoverse_N2x1
    ubfx    x0, x1, #MPIDR_EL1_AFF2_LSB, #MPIDR_EL1_AFF_WIDTH
SkipAFF2:
    ret

Others:                                                        // Cortex-A34 to A73 (excluding A55)
    mrs x0, MPIDR_EL1
    ubfx    x1, x0, #MPIDR_EL1_AFF0_LSB, #MPIDR_EL1_AFF_WIDTH
    ubfx    x2, x0, #MPIDR_EL1_AFF1_LSB, #MPIDR_EL1_AFF_WIDTH
    add     x0, x1, x2, LSL #2
    ret

AEM:                                                           // AEMvA and RevC_2xAEMvA have the same PartNum
    mrs x0, MPIDR_EL1
    ubfx    x1, x0, #MPIDR_EL1_AFF0_LSB, #MPIDR_EL1_AFF_WIDTH  // AEMvA ID is in Aff0
    ubfx    x2, x0, #MPIDR_EL1_AFF1_LSB, #MPIDR_EL1_AFF_WIDTH  // RevC_2xAEMvA ID is in Aff1 (cluster 0)
    ubfx    x3, x0, #MPIDR_EL1_AFF2_LSB, #MPIDR_EL1_AFF_WIDTH  //   and Aff2 (cluster 1)
    add     x0, x2, x3, LSL #2                                 // For RevC_2xAEMvA, assume unused Aff0 is zero
    add     x0, x0, x1                                         // For AEMvA, assume unused Aff1 & Aff2 are zero
    ret
    .cfi_endproc
