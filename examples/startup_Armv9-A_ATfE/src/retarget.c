/*
 * SPDX-FileCopyrightText: Copyright 2016-2025 Arm Limited and/or its affiliates <open-source-office@arm.com>
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
 * This file contains re-implementations of functions whose
 * C library implementations rely on semihosting.
 *
 * Define USE_SERIAL_PORT to retarget the I/O only to the serial port.
 * Otherwise, I/O is targeted to the debugger console using semihosting.
 *
 * Define STANDALONE to eliminate all use of semihosting-using functions too.
 */

#include <stdio.h>

#ifdef STANDALONE
#define USE_SERIAL_PORT 1
#endif


#ifdef USE_SERIAL_PORT
#include "uart.h"

/* Redirect stdio as per https://github.com/picolibc/picolibc/blob/main/doc/os.md */
static FILE __stdio = FDEV_SETUP_STREAM(uart_putc_polled, NULL, NULL, _FDEV_SETUP_WRITE);
FILE *const stdin = &__stdio;
__strong_reference(stdin, stdout);
__strong_reference(stdin, stderr);

#endif  // USE_SERIAL_PORT

#ifdef STANDALONE

void _exit(int return_value)
{
    __asm volatile ("dsb sy");
    while (1)
    {
        __asm volatile ("wfi");
    }
}

#endif // STANDALONE
