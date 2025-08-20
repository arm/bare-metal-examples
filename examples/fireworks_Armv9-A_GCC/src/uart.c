/*
 * SPDX-FileCopyrightText: Copyright 2005-2025 Arm Limited and/or its affiliates <open-source-office@arm.com>
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
 * PL011 UART driver
 */

#include <stdio.h>

#include "uart.h"

/*
 * UART instance: will be placed using the scatter file
 */
static struct pl011_uart uart __attribute__((section (".pl011")));

void UartInit(void)
{
    /*
     * ensure the UART is disabled
     */
    uart.UARTCR  = 0x0;

    /*
     * OK, now program this thing up
     */
    uart.UARTECR   = 0x0;  // Clear the receive status (i.e. error) register
    uart.UARTLCR_H = 0x0 | PL011_LCR_WORD_LENGTH_8 | PL011_LCR_FIFO_DISABLE | \
        PL011_LCR_ONE_STOP_BIT | PL011_LCR_PARITY_DISABLE | PL011_LCR_BREAK_DISABLE;

    uart.UARTIBRD = PL011_IBRD_DIV_38400;
    uart.UARTFBRD = PL011_FBRD_DIV_38400;

    /*
     * mask and clear all interrupts
     */
    uart.UARTIMSC = 0x0;
    uart.UARTICR  = PL011_ICR_CLR_ALL_IRQS;

    uart.UARTCR  = 0x0 | PL011_CR_UART_ENABLE | PL011_CR_TX_ENABLE | PL011_CR_RX_ENABLE;

    return;
}

void uart_putc_polled(char c)
{
    /* Wait for UART to become free */
    /* Note that FIFOs are not being used here */
    while (uart.UARTFR & PL011_FR_BUSY_FLAG);

    /* Write character and send it */
    uart.UARTDR = c;
}

char uart_getchar_polled(void)
{
    /* Wait for UART to become free */
    /* Note that FIFOs are not being used here */
    while (uart.UARTFR & PL011_FR_BUSY_FLAG);
    /* Read character received */
    return uart.UARTDR;
}
