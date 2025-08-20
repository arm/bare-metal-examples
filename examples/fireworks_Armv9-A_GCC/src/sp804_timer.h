/*
 * SPDX-FileCopyrightText: Copyright 2009-2025 Arm Limited and/or its affiliates <open-source-office@arm.com>
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
// SP804 Dual Timer
// ------------------------------------------------------------

#ifndef _SP804_TIMER_
#define _SP804_TIMER_

#include <stdint.h>

// Set base address of timer
// address - virtual address of SP804 timer
void setTimerBaseAddress(uint64_t address);


// Sets up the private timer
// load_value  - Initial value of timer
// auto_reload - Periodic (SP804_AUTORELOAD) or one shot (SP804_SINGLESHOT)
// interrupt   - Whether to generate an interrupt

#define SP804_AUTORELOAD   (0)
#define SP804_SINGLESHOT   (1)
#define SP804_GENERATE_IRQ (1 << 5)
#define SP804_NO_IRQ       (0)

void initTimer(uint32_t load_value, uint32_t auto_reload, uint32_t interrupt);


// Starts the timer
void startTimer(void);


// Stops the timer
void stopTimer(void);


// Returns the current timer count
uint32_t getTimerCount(void);


// Clears the timer interrupt
void clearTimerIrq(void);

#endif

// ------------------------------------------------------------
// End of sp804_timer.h
// ------------------------------------------------------------
