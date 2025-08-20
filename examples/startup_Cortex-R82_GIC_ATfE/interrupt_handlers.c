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


/* Timer and interrupts */

#include <stdio.h>
#include <stdint.h>
#include "GICv3.h"
#include "v8rgicv3cpuif.h"

extern void SGI1IRQhandler (void);
extern void virtualTimerIRQhandler (void);
extern void DualTimer0IRQhandler (void);


// --------------------------------------------------------

void irqHandler(void)
{
  unsigned int ID;

  ID = readIntAckGroup1(); // getICC_IAR1();

  // Check for reserved IDs
  if ((1020 <= ID) && (ID <= 1023))
  {
      printf("irqHandler() - Reserved INTID %d\n\n", ID);
      return;
  }

  switch(ID)
  {
  case 1:
      //printf("irqHandler() - SGI1IRQhandler\n\n");
      SGI1IRQhandler();
      break;

  case 27:
      //printf("irqHandler() - virtualTimerIRQhandler\n\n");
      virtualTimerIRQhandler();
      break;

  case 34:
      //printf("irqHandler() - DualTimer0IRQhandler\n\n");
      DualTimer0IRQhandler();
      break;

    default:
      // Unexpected ID value
      printf("irqHandler() - Unexpected INTID %d\n\n", ID);
      break;
  }

  // Write the End of Interrupt register to tell the GIC
  // we've finished handling the interrupt
  writeEOIGroup1(ID); // setICC_EOIR1(ID);
}

// --------------------------------------------------------

// Not actually used in this example, but provided for completeness

void fiqHandler(void)
{
  unsigned int ID;
  unsigned int aliased = 0;

  ID = readIntAckGroup0(); // getICC_IAR0();
  printf("fiqHandler() - Read %d from IAR0\n", ID);

  // Check for reserved IDs
  if ((1020 <= ID) && (ID <= 1023))
  {
    printf("fiqHandler() - Reserved INTID %d\n\n", ID);
    ID = readIntAckGroup1(); // getICC_IAR1();
    printf("fiqHandler() - Read %d from AIAR\n", ID);
    aliased = 1;

    // If still spurious then simply return
    if ((1020 <= ID) && (ID <= 1023))
        return;
  }

  switch(ID)
  {
    case 34:
      printf("fiqHandler() - External timer interrupt\n\n");
      break;

    default:
      // Unexpected ID value
      printf("fiqHandler() - Unexpected INTID %d\n\n", ID);
      break;
  }

  // Write the End of Interrupt register to tell the GIC
  // we've finished handling the interrupt
  // Write to the EOI register with the same Group (0 or 1)
  // as was used for the IAR read
  if (aliased == 0)
      writeEOIGroup0(ID); // setICC_EOIR0(ID);
  else
      writeEOIGroup1(ID); // setICC_EOIR1(ID);
}
