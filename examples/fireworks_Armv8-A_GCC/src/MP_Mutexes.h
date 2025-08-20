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
 * AArch64 - Basic Mutex Example
 */

#ifndef MP_MUTEX_H
#define MP_MUTEX_H

/*
 * The Arm C library calls-out to these functions to manage multithreading.
 * They can also be called by user application code.
 *
 * Mutex type is specified by the Arm C library
 *
 * Declare function prototypes for libc mutex routines
 */
typedef signed int *mutex;

/*
 * int _mutex_initialize(mutex *m)
 *
 * Inputs
 *  mutex *m - pointer to the 32-bit word associated with the mutex
 *
 * Returns
 *  0 - application is non-threaded
 *  1 - application is threaded
 *  The C library uses the return result to indicate whether it is being used in a multithreaded environment.
 */
int _mutex_initialize(mutex *m);

/*
 * void _mutex_acquire(mutex *m)
 *
 * Inputs
 *  mutex *m - pointer to the 32-bit word associated with the mutex
 *
 * Returns
 *  <nothing>
 *
 * Side Effects
 *  Routine does not return until the mutex has been claimed. A load-acquire
 *  is used to guarantee that the mutex claim is properly ordered with
 *  respect to any accesses to the resource protected by the mutex
 */
void _mutex_acquire(mutex *m);

/*
 * void _mutex_release(mutex *m)
 *
 * Inputs
 *  mutex *m - pointer to the 32-bit word associated with the mutex
 *
 * Returns
 *  <nothing>
 *
 * Side Effects
 *  A store-release is used to guarantee that the mutex release is properly
 *  ordered with respect any accesses to the resource protected by the mutex
 */
void _mutex_release(mutex *m);

#endif
