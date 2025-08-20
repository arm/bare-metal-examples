/*
 * SPDX-FileCopyrightText: Copyright 2012-2025 Arm Limited and/or its affiliates <open-source-office@arm.com>
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
// Defines for v8 System Registers
//

#ifndef V8_SYSTEM_H
#define V8_SYSTEM_H

//
// AArch64 SPSR
//
#define AARCH64_SPSR_EL3h 0b1101
#define AARCH64_SPSR_EL3t 0b1100
#define AARCH64_SPSR_EL2h 0b1001
#define AARCH64_SPSR_EL2t 0b1000
#define AARCH64_SPSR_EL1h 0b0101
#define AARCH64_SPSR_EL1t 0b0100
#define AARCH64_SPSR_EL0t 0b0000
#define AARCH64_SPSR_RW (1 << 4)
#define AARCH64_SPSR_F  (1 << 6)
#define AARCH64_SPSR_I  (1 << 7)
#define AARCH64_SPSR_A  (1 << 8)
#define AARCH64_SPSR_D  (1 << 9)
#define AARCH64_SPSR_IL (1 << 20)
#define AARCH64_SPSR_SS (1 << 21)
#define AARCH64_SPSR_V  (1 << 28)
#define AARCH64_SPSR_C  (1 << 29)
#define AARCH64_SPSR_Z  (1 << 30)
#define AARCH64_SPSR_N  (1 << 31)

//
// Multiprocessor Affinity Register
//
#define MPIDR_EL1_AFF3_LSB 32
#define MPIDR_EL1_U  (1 << 30)
#define MPIDR_EL1_MT (1 << 24)
#define MPIDR_EL1_AFF2_LSB 16
#define MPIDR_EL1_AFF1_LSB  8
#define MPIDR_EL1_AFF0_LSB  0
#define MPIDR_EL1_AFF_WIDTH 8

//
// Data Cache Zero ID Register
//
#define DCZID_EL0_BS_LSB   0
#define DCZID_EL0_BS_WIDTH 4
#define DCZID_EL0_DZP_LSB  5
#define DCZID_EL0_DZP (1 << 5)

//
// System Control Register
//
#define SCTLR_EL1_UCI     (1 << 26)
#define SCTLR_ELx_EE      (1 << 25)
#define SCTLR_EL1_E0E     (1 << 24)
#define SCTLR_EL2_SPAN    (1 << 23)
#define SCTLR_ELx_WXN     (1 << 19)
#define SCTLR_EL1_nTWE    (1 << 18)
#define SCTLR_EL1_nTWI    (1 << 16)
#define SCTLR_EL1_UCT     (1 << 15)
#define SCTLR_EL1_DZE     (1 << 14)
#define SCTLR_ELx_I       (1 << 12)
#define SCTLR_EL1_UMA     (1 << 9)
#define SCTLR_EL1_SED     (1 << 8)
#define SCTLR_EL1_ITD     (1 << 7)
#define SCTLR_EL1_THEE    (1 << 6)
#define SCTLR_EL1_CP15BEN (1 << 5)
#define SCTLR_EL1_SA0     (1 << 4)
#define SCTLR_ELx_SA      (1 << 3)
#define SCTLR_ELx_C       (1 << 2)
#define SCTLR_ELx_A       (1 << 1)
#define SCTLR_ELx_M       (1 << 0)

//
// Architectural Feature Access Control Register
//
#define CPACR_EL1_TTA     (1 << 28)
#define CPACR_EL1_FPEN    (3 << 20)

//
// Architectural Feature Trap Register
//
#define CPTR_ELx_TCPAC (1 << 31)
#define CPTR_ELx_TTA   (1 << 20)
#define CPTR_ELx_TFP   (1 << 10)

//
// Secure Configuration Register
//
#define SCR_EL3_NSE       (1 << 62)
#define SCR_EL3_FGTEn2    (1 << 59)
#define SCR_EL3_EnIDCP128 (1 << 55)
#define SCR_EL3_RPZEn     (1 << 54)
#define SCR_EL3_PFAREn    (1 << 53)
#define SCR_EL3_TWERR     (1 << 52)
#define SCR_EL3_TMEA      (1 << 51)
#define SCR_EL3_MECEn     (1 << 49)
#define SCR_EL3_En128     (1 << 47)
#define SCR_EL3_AIEn      (1 << 46)
#define SCR_EL3_PIEn      (1 << 45)
#define SCR_EL3_SCTLR2En  (1 << 44)
#define SCR_EL3_TCR2En    (1 << 43)
#define SCR_EL3_RCWMASKEn (1 << 42)
#define SCR_EL3_ENTP2     (1 << 41)
#define SCR_EL3_GCSEn     (1 << 39)
#define SCR_EL3_HXEn      (1 << 38)
#define SCR_EL3_TME       (1 << 34)
#define SCR_EL3_FGTEn     (1 << 27)
#define SCR_EL3_ATA       (1 << 26)
#define SCR_EL3_EEL2      (1 << 18)
#define SCR_EL3_API       (1 << 17)
#define SCR_EL3_APK       (1 << 16)
#define SCR_EL3_TWE  (1 << 13)
#define SCR_EL3_TWI  (1 << 12)
#define SCR_EL3_ST   (1 << 11)
#define SCR_EL3_RW   (1 << 10)
#define SCR_EL3_SIF  (1 << 9)
#define SCR_EL3_HCE  (1 << 8)
#define SCR_EL3_SMD  (1 << 7)
#define SCR_EL3_AW        (1 << 5)
#define SCR_EL3_FW        (1 << 4)
#define SCR_EL3_EA   (1 << 3)
#define SCR_EL3_FIQ  (1 << 2)
#define SCR_EL3_IRQ  (1 << 1)
#define SCR_EL3_NS   (1 << 0)

#define TCR_EL3_PIE       (1 << 35)
#define TCR_EL3_SH0_IS    (3 << 12)

#define TCR2_EL2_PIE      (1 << 1)


//
// Hypervisor Configuration Register
//
#define HCR_EL2_ID   (1 << 33)
#define HCR_EL2_CD   (1 << 32)
#define HCR_EL2_RW   (1 << 31)
#define HCR_EL2_TRVM (1 << 30)
#define HCR_EL2_HVC  (1 << 29)
#define HCR_EL2_TDZ  (1 << 28)

#define HCRX_EL2_GCSEn     (1 << 22)
#define HCRX_EL2_EnIDCP128 (1 << 21)
#define HCRX_EL2_EnSDERR   (1 << 20)
#define HCRX_EL2_TMEA      (1 << 19)
#define HCRX_EL2_EnSNERR   (1 << 18)
#define HCRX_EL2_SCTLR2En  (1 << 15)
#define HCRX_EL2_TCR2En    (1 << 14)
#define HCRX_EL2_MSCEn     (1 << 11)

// S1 attributes

#define S1_XN         (0x1 << 54)
#define S1_PNCH       (0x1 << 52)

#define S1_NSE        (0x1 << 11)

#define S1_AP_RW_P    (0b00 << 6)
#define S1_AP_RW      (0b01 << 6)
#define S1_AP_RO_P    (0b10 << 6)
#define S1_AP_RO      (0b11 << 6)
#define S1_NS         (0x1 << 5)
#define S1_N_DIRTY    (0b1 << 7)

#define S1_ATTRINDX_0 (0 << 2)
#define S1_ATTRINDX_1 (1 << 2)
#define S1_ATTRINDX_2 (2 << 2)
#define S1_ATTRINDX_3 (3 << 2)
#define S1_ATTRINDX_4 (4 << 2)
#define S1_ATTRINDX_5 (5 << 2)
#define S1_ATTRINDX_6 (6 << 2)
#define S1_ATTRINDX_7 (7 << 2)

// FEAT_GCS
#define GCSCRE0_EL1_nTR    (1 << 10)
#define GCSCR_ELx_STREn    (1 << 9)
#define GCSCR_ELx_PUSHMEn  (1 << 8)
#define GCSCR_ELx_EXLOCKEN (1 << 6)
#define GCSCR_ELx_RVCHKEN  (1 << 5)
#define GCSCR_ELx_PCRSEL   (1 << 0)

// FEAT_PIE
#define S1_PIIndex(idx) ((((idx >> 2) & 3) << 53) | \
                         (((idx >> 1) & 1) << 51) | \
                         (( idx       & 1) << 6))

#define S1_AttrIndex(idx) (idx << 2)

#endif // V8_SYSTEM_H
