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


/* Bare-metal example for Armv-A Base FVP model */

/* Timer and interrupts */

#include <stdio.h>

#include "GICv3.h"
#include "GICv3_gicc.h"
#include "sp804_timer.h"

// LED Base address
#define LED_BASE (volatile unsigned int *)0x1C010008


void nudge_leds(void) // Move LEDs along
{
    static int state = 1;
    static int value = 1;

    if (state)
    {
        int max = (1 << 7);
        value <<= 1;
        if (value == max)
            state = 0;
    }
    else
    {
        value >>= 1;
        if (value == 1)
            state = 1;
    }

    *LED_BASE = value;  // Update LEDs hardware
}


// Initialize Timer 0 and Interrupt Controller
void init_timer(void)
{
    // Enable interrupts
    __asm volatile ("MSR DAIFClr, #0xF");
    setICC_IGRPEN1_EL1(igrpEnable);

    // Configure the SP804 timer to generate an interrupt
    setTimerBaseAddress(0x1C110000);
    initTimer(0x800, SP804_AUTORELOAD, SP804_GENERATE_IRQ);
    startTimer();

    // The SP804 timer generates SPI INTID 34.  Enable
    // this ID, and route it to core 0.0.0.0 (this one!)
    SetSPIRoute(34, 0, gicdirouter_ModeSpecific);    // Route INTID 34 to 0.0.0.0 (this core)
    SetSPIPriority(34, 0);                           // Set INTID 34 to priority to 0
    ConfigureSPI(34, gicdicfgr_Level);               // Set INTID 34 as level-sensitive
    EnableSPI(34);                                   // Enable INTID 34
}


// --------------------------------------------------------

void irqHandler(void)
{
  unsigned int ID;

  ID = getICC_IAR1(); // readIntAckGroup1();

  // Check for reserved IDs
  if ((1020 <= ID) && (ID <= 1023))
  {
      printf("irqHandler() - Reserved INTID %d\n\n", ID);
      return;
  }

  switch(ID)
  {
    case 34:
      // Dual-Timer 0 (SP804)
      printf("irqHandler() - External timer interrupt\n\n");
      nudge_leds();
      clearTimerIrq();
      break;

    default:
      // Unexpected ID value
      printf("irqHandler() - Unexpected INTID %d\n\n", ID);
      break;
  }

  // Write the End of Interrupt register to tell the GIC
  // we've finished handling the interrupt
  setICC_EOIR1(ID); // writeEOIGroup1(ID);
}

// --------------------------------------------------------

// Not actually used in this example, but provided for completeness

void fiqHandler(void)
{
  unsigned int ID;
  unsigned int aliased = 0;

  ID = getICC_IAR0(); // readIntAckGroup0();
  printf("fiqHandler() - Read %d from IAR0\n", ID);

  // Check for reserved IDs
  if ((1020 <= ID) && (ID <= 1023))
  {
    printf("fiqHandler() - Reserved INTID %d\n\n", ID);
    ID = getICC_IAR1(); // readIntAckGroup1();
    printf("fiqHandler() - Read %d from AIAR\n", ID);
    aliased = 1;

    // If still spurious then simply return
    if ((1020 <= ID) && (ID <= 1023))
        return;
  }

  switch(ID)
  {
    case 34:
      // Dual-Timer 0 (SP804)
      printf("fiqHandler() - External timer interrupt\n\n");
      clearTimerIrq();
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
    setICC_EOIR0(ID); // writeEOIGroup0(ID);
  else
    setICC_EOIR1(ID); // writeEOIGroup1(ID);
}
