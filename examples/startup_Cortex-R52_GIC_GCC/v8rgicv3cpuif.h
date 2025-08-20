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


#ifndef V8RGICV3CPUIF_H_
#define V8RGICV3CPUIF_H_

void setICC_SRE(unsigned int value);
unsigned int getICC_SRE(void);
void setICC_HSRE(unsigned int value);
unsigned int getICC_HSRE(void);
void setICC_MSRE(unsigned int value);
unsigned int getICC_MSRE(void);
void enableGroup0Ints(void);
void disableGroup0Ints(void);
void enableGroup1Ints(void);
void disableGroup1Ints(void);
void enableNSGroup1Ints(void);
void disableNSGroup1Ints(void);
unsigned int getICC_MCTLR(void);
void setICC_MCTLR(unsigned int value);
unsigned int getICC_CTLR(void);
void setICC_CTLR(unsigned int value);
unsigned int readIntAckGroup0(void);
void writeEOIGroup0(unsigned int ID);
void writeDIR(unsigned int ID);
unsigned int readIntAckGroup1(void);
void writeEOIGroup1(unsigned int ID);
void setPriorityMask(unsigned int ID);
unsigned int getBinaryPointGroup0(void);
void setBinaryPointGroup0(unsigned int ID);
unsigned int getBinaryPointGroup1(void);
void setBinaryPointGroup1(unsigned int ID);
unsigned int getRunningPriority(void);
void sendGroup0SGI(unsigned int ID, unsigned int mode, unsigned target_list);
void sendGroup1SGI(unsigned int ID, unsigned int mode, unsigned target_list);
void sendOtherGroup1SGI(unsigned int ID, unsigned int mode, unsigned target_list);
void setICH_HCR(unsigned int value);
unsigned int getICH_HCR(void);
void setICH_AP1R0(unsigned int value);
unsigned int getICH_AP1R0(void);
void setICH_AP0R0(unsigned int value);
unsigned int getICH_AP0R0(void);
void setICH_LR0(unsigned int value);
unsigned int getICH_LR0(void);
void setICH_LRC0(unsigned int value);
unsigned int getICH_LRC0(void);
void setICH_LR1(unsigned int value);
unsigned int getICH_LR1(void);
void setICH_LRC1(unsigned int value);
unsigned int getICH_LRC1(void);
void setICH_LR2(unsigned int value);
unsigned int getICH_LR2(void);
void setICH_LRC2(unsigned int value);
unsigned int getICH_LRC2(void);
void setICH_LR3(unsigned int value);
unsigned int getICH_LR3(void);
void setICH_LRC3(unsigned int value);
unsigned int getICH_LRC3(void);

#endif /* V8RGICV3CPUIF_H_ */
