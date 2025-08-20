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


/*
 * Armv8/9-A AArch64 common helper functions
 */

#ifndef V8_AARCH64_H
#define V8_AARCH64_H

/*
 * Parameters for data barriers
 */
#define OSHLD   1
#define OSHST   2
#define OSH     3
#define NSHLD   5
#define NSHST   6
#define NSH     7
#define ISHLD   9
#define ISHST  10
#define ISH    11
#define LD     13
#define ST     14
#define SY     15

/**********************************************************************/

/*
 * function prototypes
 */

/*
 * void InvalidateUDCaches(void)
 *   invalidates all Unified and Data Caches
 *
 * Inputs
 *   <none>
 *
 * Returns
 *   <nothing>
 *
 * Side Effects
 *   guarantees that all levels of cache will be invalidated before
 *   returning to caller
 */
void InvalidateUDCaches(void);

/*
 * unsigned long long EnableCachesEL1(void)
 *   enables I- and D- caches at EL1
 *
 * Inputs
 *   <none>
 *
 * Returns
 *   New value of SCTLR_EL1
 *
 * Side Effects
 *   context will be synchronised before returning to caller
 */
unsigned long long EnableCachesEL1(void);

/*
 * unsigned long long GetMIDR(void)
 *   returns the contents of MIDR_EL0
 *
 * Inputs
 *   <none>
 *
 * Returns
 *   MIDR_EL0
 */
unsigned long long GetMIDR(void);

/*
 * unsigned long long GetMPIDR(void)
 *   returns the contents of MPIDR_EL0
 *
 * Inputs
 *   <none>
 *
 * Returns
 *   MPIDR_EL0
 */
unsigned long long GetMPIDR(void);

/*
 * unsigned int GetCPUID(void)
 *   returns the Aff0 field of MPIDR_EL0
 *
 * Inputs
 *   <none>
 *
 * Returns
 *   MPIDR_EL0[7:0]
 */
unsigned int GetCPUID(void);

#endif
