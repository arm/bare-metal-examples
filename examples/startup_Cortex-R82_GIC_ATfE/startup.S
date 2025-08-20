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
// Armv8-R64 AArch64 Startup Code
//
// Includes MPU configuration
//
// Starts in EL2S, exits in EL1S
// ------------------------------------------------------------

#include "v8_system.h"

// MPU region defines

// Protection Region Selection Register
#define Region 0x0  // Start programming MPU at region 0

// Protection Region Base Address Register
#define Execute_Never   0b1       // Bit 0
#define RW_this_EL_only      0b00 // AP[2:1]
#define RW_this_EL_and_lower 0b01
#define RO_this_EL_only      0b10
#define RO_this_EL_and_lower 0b11
#define Non_Shareable   0b00      // SH[1:0]
#define Outer_Shareable 0b10
#define Inner_Shareable 0b11

// Protection Region Limit Address Register
#define ENable 0b1                // Bit 0
#define AttrIndx0 0b000           // AttrIndx[2:0]
#define AttrIndx1 0b001
#define AttrIndx2 0b010
#define AttrIndx3 0b011
#define AttrIndx4 0b100
#define AttrIndx5 0b101
#define AttrIndx6 0b110
#define AttrIndx7 0b111
#define RegionS   0b0             // NS bit 4
#define RegionNS  0b1

//----------------------------------------------------------------

    .section StartUp, "ax"
    .balign 4

    .global el1_vectors
    .global el2_vectors

// ------------------------------------------------------------

    .global Start
    .type Start, "function"
Start:
    // Extract the core number from MPIDR_EL1 and store it in x19
    // (defined by the AAPCS as callee-saved), so we can re-use it later
    //
    bl GetCPUID
    mov x19, x0

    // If run on a multi-core system, put any secondary cores to sleep
    cbz x19, core0_only
loop_wfi:
    dsb SY      // Clear all pending data accesses
    wfi         // Go to sleep
    b loop_wfi

core0_only:

    // Set architectural unknown values in HCR to zero
    ldr x1, =HCR_EL2_zeroed
    msr HCR_EL2, x1
    isb

    // Program the SCTLRs
    ldr x1, =SCTLR_EL2_zeroed
    msr SCTLR_EL2, x1

    ldr x1, =SCTLR_EL1_zeroed
    msr SCTLR_EL1, x1

    // This example does not use EL0, so the EL1 MPU configuration uses RO/RW_this_EL_only permissions.
    // If you need to use EL0, and want EL1 and EL0 code/data to share the same MPU regions using RO/RW_this_EL_and_lower,
    // then you may also need to set SPAN in SCTLR_EL1 to enable EL1 access to RW data (e.g. the stack) in the interrupt handler, with:
    //  mrs x1, SCTLR_EL1
    //  orr x1, x1, #(1 << 23)
    //  msr SCTLR_EL1, x1
    isb

    // Program the VBARs
    ldr x1, =el1_vectors
    msr VBAR_EL1, x1

    ldr x1, =el2_vectors
    msr VBAR_EL2, x1

    // Configure the EL2 SP
    ldr x1, =__stack
    mov SP, x1

    // Configuring security state
    mrs x1, VTCR_EL2
    orr x1, x1, #VTCR_EL2_NSA
    msr VTCR_EL2, x1

    mrs x1, VSTCR_EL2
    orr x1, x1, #VSTCR_EL2_SC
    bic x1, x1, #VSTCR_EL2_SA
    msr VSTCR_EL2, x1

    // Disable trapping
    ldr x1, =CPTR_EL2_zeroed
    msr CPTR_EL2, x1
    isb

//----------------------------------------------------------------
// EL2 MPU Configuration
//----------------------------------------------------------------

    // MAIR_EL2 configuration
    mrs x0, MAIR_EL2
    ldr x1, =0xBB                   // Normal inner/outer RW cacheable, write-through
    bfi x0, x1, #0, #8              // Update Attr0
    ldr x1, =0x04                   // Device nGnRnE
    bfi x0, x1, #8, #8              // Update Attr1
    msr MAIR_EL2, x0
    isb

    // Select first 16 MPU regions to program
    ldr x1, =Region
    msr PRSELR_EL2, x1
    isb 

    // Region 0 - Code
    ldr x1, =__code_start
    ldr x2, =((Non_Shareable << 4) | (RO_this_EL_only << 2))
    orr x1, x1, x2
    msr PRBAR_EL2, x1

    ldr x1, =__code_end
    sub x1, x1, #1                  // Convert limit from exclusive to inclusive
    bfc x1, #0, #6                  // and clear the lower 6 bits
    ldr x2, =((RegionS << 4) | (AttrIndx0 << 1) | (ENable))
    orr x1, x1, x2
    msr PRLAR_EL2, x1

    // Region 1 - Data (RW .data, ZI .bss, stack and heap)
    ldr x1, =__data_start
    ldr x2, =((Non_Shareable << 4) | (RW_this_EL_only << 2))
    orr x1, x1, x2
    msr PRBAR1_EL2, x1

    ldr x1, =__stack
    sub x1, x1, #1
    bfc x1, #0, #6
    ldr x2, =((RegionS << 4) | (AttrIndx0 << 1) | (ENable))
    orr x1, x1, x2
    msr PRLAR1_EL2, x1
    dsb sy
    isb

    // Setting up EL1 context

    // Initialize VMID for the EL1 context
    msr VSCTLR_EL2, xzr
    isb

    // Propagating MPIDR_EL1 and MIDR_EL1 to EL1
    mrs x0, MPIDR_EL1
    msr VMPIDR_EL2, x0
    mrs x0, MIDR_EL1
    msr VPIDR_EL2, x0

    // Configuring EL1 in PMSA
    mrs x1, VTCR_EL2
    bic x1, x1, #(1U << 31)    //  VTCR_EL2.MSA [31]
    msr VTCR_EL2, x1

    // Configure for uninterrupted execution in EL1
    msr MDCR_EL2, xzr

    // Allow predictable values from CNTVCT_EL0
    msr CNTVOFF_EL2, xzr

    // Set CNTFRQ_EL0 so software can discover the system counter frequency
    ldr x2, =50000000  // Set to 50MHz
    msr CNTFRQ_EL0, x2

    // Avoid trapping accesses related to virtualization
    mrs x2, HCR_EL2
    orr x2, x2, #HCR_EL2_EnSCXT  // To allow accesses to SCXTNUM_EL1 and SCXTNUM_EL0 for FEAT_CSV2_2 and FEAT_CVS2_1p2
    orr x2, x2, #HCR_EL2_FIEN    // To allow RAS in EL1
    orr x2, x2, #HCR_EL2_API     // To allow pointer authentication instructions in EL1
    orr x2, x2, #HCR_EL2_APK     // To allow pointer authentication keys in EL1
    msr HCR_EL2, x2
    isb

//----------------------------------------------------------------
// Enable EL2 MPU and caches
//----------------------------------------------------------------

    mrs x1, SCTLR_EL2
    orr x1, x1, #SCTLR_ELx_M
    orr x1, x1, #SCTLR_ELx_C
    orr x1, x1, #SCTLR_ELx_I
    bic x1, x1, #SCTLR_ELx_A // Disable alignment fault checking.  To enable, change bic to orr
    msr SCTLR_EL2, x1
    isb


    //
    // Set up EL1 entry point and "dummy" exception return information,
    // then perform exception return to enter EL1
    //
    .global drop_to_el1
drop_to_el1:
    adr x1, el1_entry_aarch64
    msr ELR_EL2, x1
    mov x1, #(AARCH64_SPSR_EL1h | \
              AARCH64_SPSR_F  | \
              AARCH64_SPSR_I  | \
              AARCH64_SPSR_A)
    msr SPSR_EL2, x1
    eret


// ------------------------------------------------------------
// EL1 - Common start-up code
// ------------------------------------------------------------

    .global el1_entry_aarch64
    .type el1_entry_aarch64, "function"
el1_entry_aarch64:

    //
    // Now we're in EL1, setup the application stack per core
    // x19 contains the CPU number
    //
    ldr x0, =__stack
    sub x0, x0, x19, lsl #14
    mov sp, x0

    //
    // Enable floating point
    //
    mov x0, #CPACR_EL1_FPEN
    msr CPACR_EL1, x0
    isb

//----------------------------------------------------------------
// EL1 MPU Configuration
//----------------------------------------------------------------

    // MAIR_EL1 configuration
    mrs x0, MAIR_EL1      
    ldr x1, =0xBB                   // Normal inner/outer RW cacheable, write-through
    bfi x0, x1, #0, #8              // Update Attr0
    ldr x1, =0x04                   // Device nGnRnE
    bfi x0, x1, #8, #8              // Update Attr1
    msr MAIR_EL1, x0
    isb

    // Select first 16 MPU regions to program 
    ldr x1, =Region
    msr PRSELR_EL1, x1
    isb

    // Region 0 - Code
    ldr x1, =__code_start
    ldr x2, =((Non_Shareable << 4) | (RO_this_EL_only << 2))
    orr x1, x1, x2
    msr PRBAR_EL1, x1

    ldr x1, =__rw_data_end_in_rom   // Allow for copying initial values of RW .data from ROM to RAM
    sub x1, x1, #1                  // Convert limit from exclusive to inclusive
    bfc x1, #0, #6                  // and clear the lower 6 bits
    ldr x2, =((RegionS <<4) | (AttrIndx0 << 1) | (ENable))
    orr x1, x1, x2
    msr PRLAR_EL1, x1

    // Region 1 - Data (RW .data, ZI .bss, stack and heap)
    ldr x1, =__data_start
    ldr x2, =((Non_Shareable << 4) | (RW_this_EL_only << 2))
    orr x1, x1, x2
    msr PRBAR1_EL1, x1

    ldr x1, =__stack
    sub x1, x1, #1
    bfc x1, #0, #6
    ldr x2, =((RegionS << 4) | (AttrIndx0 << 1) | (ENable))
    orr x1, x1, x2
    msr PRLAR1_EL1, x1
    dsb sy
    isb

    // Region 2 - Peripherals
    ldr x1, =0x9A000000
    ldr x2, =((Non_Shareable << 4) | (RW_this_EL_only << 2))
    orr x1, x1, x2
    msr PRBAR2_EL1, x1

    ldr x1, =0xAFFFFFC0
    sub x1, x1, #1
    bfc x1, #0, #6
    ldr x2, =((RegionS << 4) | (AttrIndx1 << 1) | (ENable))
    orr x1, x1, x2
    msr PRLAR2_EL1, x1
    dsb sy
    isb


//----------------------------------------------------------------
// Enable EL1 MPU
// Leave the caches disabled until after RW/ZI initialization
//----------------------------------------------------------------

    mrs x1, SCTLR_EL1          // Read System Control Register
    orr x1, x1, #SCTLR_ELx_M   // Set M bit to enable MPU
    bic x1, x1, #SCTLR_ELx_A   // Disable alignment fault checking.  To enable, change bic to orr
    msr SCTLR_EL1, x1          // Write System Control Register
    isb                        // Ensure subsequent insts execute wrt new MPU settings


//----------------------------------------------------------------
// Copy initial values of RW .data from Flash to RAM
// and zero-initialize the ZI .bss
//----------------------------------------------------------------

    ldr x0, =__data_start
    ldr x1, =__data_source
    ldr x2, =__data_size
    bl memcpy

    ldr x0, =__bss_start
    mov x1, #0
    ldr x2, =__bss_size
    bl memset

    // Set up _fini and fini_array to be called at exit
    ldr x0, =__libc_fini_array
    bl  atexit

    // Call preinit_array, _init and init_array
    bl  __libc_init_array

    ldr x0, =__tls_base
    bl _set_tls

    b   main


//----------------------------------------------------------------
// Enable Instruction and Data caches
//----------------------------------------------------------------

    .global enable_caches
    .type enable_caches, "function"
    .cfi_startproc
enable_caches:
    mrs x1, SCTLR_EL1          // Read System Control Register
    orr x1, x1, #SCTLR_ELx_C   // Enable D-cache
    orr x1, x1, #SCTLR_ELx_I   // Enable I-cache
    msr SCTLR_EL1, x1          // Write System Control Register
    isb                        // Ensure subsequent insts execute wrt new MPU settings
    ret
    .cfi_endproc
