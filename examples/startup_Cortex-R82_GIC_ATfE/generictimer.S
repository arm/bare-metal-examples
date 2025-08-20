/*
 * SPDX-FileCopyrightText: Copyright 2016-2026 Arm Limited and/or its affiliates <open-source-office@arm.com>
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


	.section  generictimer,"ax"

	.global setCNTFRQ
  // Sets the value of CNTFRQ_EL0
	.type setCNTFRQ, %function
setCNTFRQ:							// Arguments: system counter clock frequency, in Hz
  msr CNTFRQ_EL0, x0
  ret


	.global getCNTFRQ
  // Returns the value of CNTFRQ_EL0
	.type getCNTFRQ, %function
getCNTFRQ:							// Return: system counter clock frequency, in Hz
  mrs x0, CNTFRQ_EL0
  ret


	.global getCNTPCT
  // Returns the current value of physical count (CNTPCT_EL0)
	.type getCNTPCT, %function
getCNTPCT:
  isb
  mrs  x0, CNTPCT_EL0
  ret


	.global setCNTP_TVAL
  // Sets the value of the Non-secure EL1 Physical Timer Value Register (CNTP_TVAL_EL0)
	.type setCNTP_TVAL, %function
setCNTP_TVAL:
  msr CNTP_TVAL_EL0, x0
  ret


	.global getCNTP_TVAL
  // Returns the value of Non-secure EL1 Physical Timer Value Register (CNTP_TVAL_EL0)
	.type getCNTP_TVAL, %function
getCNTP_TVAL:
  mrs x0, CNTP_TVAL_EL0
  ret


	.global setCNTV_TVAL
  // Sets the value of the EL1 Virtual Timer Value Register (CNTV_TVAL_EL0)
	.type setCNTV_TVAL, %function
setCNTV_TVAL:
  msr CNTV_TVAL_EL0, x0
  ret


	.global getCNTV_TVAL
  // Returns the value of EL1 Virtual Timer Value Register (CNTV_TVAL_EL0)
	.type getCNTV_TVAL, %function
getCNTV_TVAL:
  mrs x0, CNTV_TVAL_EL0
  ret


	.global enablePhyTimer
	.type enablePhyTimer, %function
enablePhyTimer:
  ldr x0, =0x1						// Enable timer
  mrs x0, CNTP_CTL_EL0
  ret


	.global disablePhyTimer
	.type disablePhyTimer, %function
disablePhyTimer:
  ldr x0, =0x0						// Disable timer
  mrs x0, CNTP_CTL_EL0
  ret


	.global enableVirtualTimer
	.type enableVirtualTimer, %function
enableVirtualTimer:
  ldr x0, =0x1						// Enable timer
  msr CNTV_CTL_EL0, x0
  isb
  ret


	.global disableVirtualTimer
	.type disableVirtualTimer, %function
disableVirtualTimer:
  ldr x0, =0x0						// Disable timer
  msr CNTV_CTL_EL0, x0
  isb
  ret


	.global setCNTP_CVAL
  // Sets the value of the Non-secure EL1 Physical Compare Value Register (CNTP_CVAL_EL0)
	.type setCNTP_CVAL, %function
setCNTP_CVAL:
  msr CNTP_CVAL_EL0, x0
  ret


	.global getCNTP_CVAL
  // Returns the value of Non-secure EL1 Physical Compare Value Register (CNTP_CVAL_EL0)
	.type getCNTP_CVAL, %function
getCNTP_CVAL:
  mrs x0, CNTP_CVAL_EL0
  ret


	.global setCNTV_CVAL
  // Sets the value of the EL1 Virtual Compare Value Register (CNTV_CVAL_EL0)
	.type setCNTV_CVAL, %function
setCNTV_CVAL:
  msr CNTV_CVAL_EL0, x0
  ret


	.global getCNTV_CVAL
  // Returns the value of EL1 Virtual Compare Value Register (CNTV_CVAL_EL0)
	.type getCNTV_CVAL, %function
getCNTV_CVAL:
  mrs  x0, CNTV_CVAL_EL0
  ret


	.global setCNTVOFF
  // Sets the value of the Counter Virtual Offset Register (CNTVOFF_EL2)
  // EL2 and EL3 only
	.type setCNTVOFF, %function
setCNTVOFF:
  msr CNTVOFF_EL2, x0
  ret


	.global getCNTVOFF
  // Returns the value of Counter Virtual Offset Register (CNTVOFF_EL2)
  // EL2 and EL3 only
	.type getCNTVOFF, %function
getCNTVOFF:
  mrs x0, CNTVOFF_EL2
  ret


	.global setCNTHP_TVAL
  // Sets the value of the EL2 Physical Timer Value Register (CNTHP_TVAL_EL2)
	.type setCNTHP_TVAL, %function
setCNTHP_TVAL:
  msr CNTHP_TVAL_EL2, x0
  ret


	.global getCNTHP_TVAL
  // Returns the value of EL2 Physical Timer Value Register (CNTHP_TVAL_EL2)
	.type getCNTHP_TVAL, %function
getCNTHP_TVAL:
  mrs x0, CNTHP_TVAL_EL2
  ret


	.global enableHypTimer
	.type enableHypTimer, %function
enableHypTimer:
  ldr x0, =0x1						// Enable timer
  msr CNTHP_CTL_EL2, x0
  isb
  ret


	.global disableHypTimer
	.type disableHypTimer, %function
disableHypTimer:
  ldr x0, =0x0						// Disable timer
  msr CNTHP_CTL_EL2, x0
  isb
  ret


	.global setCNTHP_CVAL
  // Sets the value of the EL2 Physical Compare Value Register (CNTHP_CVAL_EL2)
	.type setCNTHP_CVAL, %function
setCNTHP_CVAL:
  msr CNTHP_CVAL_EL2, x0
  ret


	.global getCNTHP_CVAL
  // Returns the value of EL2 Physical Compare Value Register (CNTHP_CVAL_EL2)
	.type getCNTHP_CVAL, %function
getCNTHP_CVAL:
  mrs x0, CNTHP_CVAL_EL2
  ret
