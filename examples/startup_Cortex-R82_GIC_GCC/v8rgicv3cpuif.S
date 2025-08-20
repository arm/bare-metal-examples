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


	.section  v8rgicv3cpuif,"ax"

// ------------------------------------------------------------

	.global setICC_SRE
  // void setICC_SRE(unsigned int value)
	.type setICC_SRE, %function
setICC_SRE:
  MSR ICC_SRE_EL1, x0
  ISB
  RET

// ------------------------------------------------------------

	.global getICC_SRE
  // unsigned int getICC_SRE(void)
	.type getICC_SRE, %function
getICC_SRE:
  MRS x0, ICC_SRE_EL1
  RET

// ------------------------------------------------------------

	.global setICC_HSRE
  // void setICC_HSRE(unsigned int value)
	.type setICC_HSRE, %function
setICC_HSRE:
  MSR ICC_SRE_EL2, x0
  ISB
  RET

// ------------------------------------------------------------

	.global getICC_HSRE
  // unsigned int getICC_HSRE(void)
	.type getICC_HSRE, %function
getICC_HSRE:
  MRS x0, ICC_SRE_EL2
  RET

// ------------------------------------------------------------

	.global setICC_MSRE
  // void setICC_MSRE(unsigned int value)
	.type setICC_MSRE, %function
setICC_MSRE:
  MSR ICC_SRE_EL1, x0
  ISB
  RET

// ------------------------------------------------------------

	.global getICC_MSRE
  // unsigned int getICC_MSRE(void)
	.type getICC_MSRE, %function
getICC_MSRE:
  MRS x0, ICC_SRE_EL1
  RET

// ------------------------------------------------------------

	.global enableGroup0Ints
  // void enableGroup0Ints(void)
	.type enableGroup0Ints, %function
enableGroup0Ints:
  MOV x0, #1
  MSR ICC_IGRPEN0_EL1, x0
  ISB
  RET

// ------------------------------------------------------------

	.global disableGroup0Ints
  // void disableGroup0Ints(void)
	.type disableGroup0Ints, %function
disableGroup0Ints:
  MOV x0, #0
  MSR ICC_IGRPEN0_EL1, x0
  ISB
  RET

// ------------------------------------------------------------

	.global enableGroup1Ints
  // void enableGroup1Ints(void)
	.type enableGroup1Ints, %function
enableGroup1Ints:
  MOV x0, #1
  MSR ICC_IGRPEN1_EL1, x0 // Write x0 to ICC_IGRPEN1
  ISB
  RET

// ------------------------------------------------------------

	.global disableGroup1Ints
  // void disableGroup1Ints(void)
	.type disableGroup1Ints, %function
disableGroup1Ints:
  MOV x0, #0
  MSR ICC_IGRPEN1_EL1, x0 // Write x0 to ICC_IGRPEN1
  ISB
  RET

// ------------------------------------------------------------
#if 0 /* These are not present in Cortex-R82 */
	.global enableNSGroup1Ints
  // void enableNSGroup1Ints(void)
	.type enableNSGroup1Ints, %function
enableNSGroup1Ints:
  MRS x0, ICC_IGRPEN1_EL3 // Read ICC_IGRPEN1_EL3 into x0
  ORR x0, x0, #1
  MSR ICC_IGRPEN1_EL3, x0 // Write x0 to ICC_IGRPEN1_EL3
  ISB
  RET

// ------------------------------------------------------------

	.global disableNSGroup1Ints
  // void disableNSGroup1Ints(void)
	.type disableNSGroup1Ints, %function
 disableNSGroup1Ints:
  MRS x0, ICC_IGRPEN1_EL3 // Read ICC_IGRPEN1_EL3 into x0
  BIC x0, x0, #1
  MSR ICC_IGRPEN1_EL3, x0 // Write x0 to ICC_IGRPEN1_EL3
  ISB
  RET

// ------------------------------------------------------------

	.global getICC_CTLR_EL3
  // unsigned int getICC_CTLR_EL3(void)
	.type getICC_CTLR_EL3, %function
getICC_CTLR_EL3:
  MRS x0, ICC_CTLR_EL3
  RET

// ------------------------------------------------------------
	.global setICC_CTLR_EL3
  // void setICC_CTLR_EL3(unsigned int value)
	.type setICC_CTLR_EL3, %function
setICC_CTLR_EL3:
  MSR ICC_CTLR_EL3, x0
  ISB
  RET
#endif
// ------------------------------------------------------------

	.global getICC_CTLR_EL1
  // unsigned int getICC_CTLR_EL1(void)
	.type getICC_CTLR_EL1, %function
getICC_CTLR_EL1:
  MRS x0, ICC_CTLR_EL1
  RET

// ------------------------------------------------------------

	.global setICC_CTLR_EL1
  // void setICC_CTLR_EL1(unsigned int value)
	.type setICC_CTLR_EL1, %function
setICC_CTLR_EL1:
  MSR ICC_CTLR_EL1, x0
  ISB
  RET

// ------------------------------------------------------------

	.global readIntAckGroup0
  // unsigned int readIntAckGroup0(void)
	.type readIntAckGroup0, %function
readIntAckGroup0:
  MRS x0, ICC_IAR0_EL1
  RET

// ------------------------------------------------------------

	.global writeEOIGroup0
  // void writeEOIGroup0(unsigned int ID)
	.type writeEOIGroup0, %function
writeEOIGroup0:
  MSR ICC_EOIR0_EL1, x0
  ISB
  RET

// ------------------------------------------------------------

	.global writeDIR
  // void writeDIR(unsigned int ID)
	.type writeDIR, %function
writeDIR:
  MSR ICC_DIR_EL1, x0
  ISB
  RET

// ------------------------------------------------------------

	.global readIntAckGroup1
  // unsigned int readIntAckGroup1(void)
	.type readIntAckGroup1, %function
readIntAckGroup1:
  MRS x0, ICC_IAR1_EL1
  RET

// ------------------------------------------------------------

	.global writeEOIGroup1
  // void writeEOIGroup1(unsigned int ID)
	.type writeEOIGroup1, %function
writeEOIGroup1:
  MSR ICC_EOIR1_EL1, x0
  ISB
  RET

// ------------------------------------------------------------

	.global setPriorityMask
  // void setPriorityMask(unsigned int ID)
	.type setPriorityMask, %function
setPriorityMask:
  MSR ICC_PMR_EL1, x0
  // No ISB required, writes to ICC_PMR_EL1 are self-synchronizing
  RET

// ------------------------------------------------------------

	.global getBinaryPointGroup0
  // unsigned int getBinaryPointGroup0(void)
	.type getBinaryPointGroup0, %function
getBinaryPointGroup0:
  MRS x0, ICC_BPR0_EL1
  RET

// ------------------------------------------------------------

	.global setBinaryPointGroup0
  // void setBinaryPointGroup0(unsigned int ID)
	.type setBinaryPointGroup0, %function
setBinaryPointGroup0:
  MSR ICC_BPR0_EL1, x0
  ISB
  RET

// ------------------------------------------------------------

	.global getBinaryPointGroup1
  // unsigned int getBinaryPointGroup1(void)
	.type getBinaryPointGroup1, %function
getBinaryPointGroup1:
  MRS x0, ICC_BPR1_EL1
  RET

// ------------------------------------------------------------

	.global setBinaryPointGroup1
  // void setBinaryPointGroup1(unsigned int ID)
	.type setBinaryPointGroup1, %function
setBinaryPointGroup1:
  MSR ICC_BPR1_EL1, x0
  ISB
  RET

// ------------------------------------------------------------

	.global getRunningPriority
  // unsigned int getRunningPriority(void)
	.type getRunningPriority, %function
getRunningPriority:
  MRS x0, ICC_RPR_EL1
  RET

// ------------------------------------------------------------
// SGIs
// ------------------------------------------------------------

	.global sendGroup0SGI
  // void sendGroup0SGI(unsigned int ID, unsigned int mode, unsigned target_list)
	.type sendGroup0SGI, %function
sendGroup0SGI:
  ORR x0, x0, x1
  ORR x0, x0, x2
  MSR ICC_SGI0R_EL1, x0
  RET

// ------------------------------------------------------------

	.global sendGroup1SGI
  // void sendGroup1SGI(unsigned int ID, unsigned int mode, unsigned target_list)
	.type sendGroup1SGI, %function
sendGroup1SGI:
  ORR x0, x0, x1
  ORR x0, x0, x2
  MSR ICC_SGI1R_EL1, x0
  RET

// ------------------------------------------------------------

	.global sendOtherGroup1SGI
  // void sendOtherGroup1SGI(unsigned int ID, unsigned int mode, unsigned target_list)
	.type sendOtherGroup1SGI, %function
sendOtherGroup1SGI:
  ORR x0, x0, x1
  ORR x0, x0, x2
  MSR ICC_ASGI1R_EL1, x0
  RET

// ------------------------------------------------------------

// ICH_* registers not used in this example
