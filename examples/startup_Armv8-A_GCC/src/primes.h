/*
 * SPDX-FileCopyrightText: Copyright 2011-2025 Arm Limited and/or its affiliates <open-source-office@arm.com>
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
// Prime Number Generator Code
// ------------------------------------------------------------

#ifndef _PRIMES_H
#define _PRIMES_H

#include "MP_Mutexes.h"

// Mutex to regulate access by multiple CPUs to a resource, aligned to cache line size
extern mutex print_lock __attribute__ ((aligned (64)));

// Initializes shared data used during calculation of primes
// Must be called by CPU 0 only, before any CPU calls to calculatePrimes()
void initPrimes(void);

// Starts calculation of primes on that CPU
// Must be called by each participating CPU
void calculatePrimes(unsigned int id);

#endif

// ------------------------------------------------------------
// End of primes.h
// ------------------------------------------------------------
