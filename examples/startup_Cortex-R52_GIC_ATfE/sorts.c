/*
 * SPDX-FileCopyrightText: Copyright 2007-2026 Arm Limited and/or its affiliates <open-source-office@arm.com>
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


/* sorts.c simple sorting program */

#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>

#define N               1000

#if N > 1000000
#error "Value of N too big, must be <= 1000000"
#endif

#define LOG10_N         6
#define N_FORMAT        "%06d"

#if N <= 10000
static void insert_sort(char *strings[], int n)
{
    char *v, *t;
    char **strp, **endp;
    int i;

    endp = &strings[n-1];
    i = n-2;
    do {
        strp = &strings[i];
        v = strp[0];
        do {
            t = strp[1];
            if (strcmp(v, t) <= 0) break;
            *strp++ = t;
        } while (strp < endp);
        strp[0] = v;
    } while (--i >= 0);
}
#endif

static void shell_sort(char *strings[], int n)
{
    int h, i, j;
    char *v;

    strings--;        /* Make array 1 origin */
    h = 1;
    do {h = h * 3 + 1;} while (h <= n);
    do {
        h = h / 3;
        for (i = h + 1; i <= n; i++) {
            v = strings[i];
            j = i;
            while (j > h && strcmp(strings[j-h], v) > 0) {
                strings[j] = strings[j-h];
                j = j-h;
            }
            strings[j] = v;
        }
    }
    while (h > 1);
}

static void randomise(char *strings[], int n)
{
    int i;
    int v;
    char *t;

    srand(1);  /* for repeatable results.  Or use  srand(clock());  for 'more random' results */
    for (i = 0; i < n; i++) {
        v = rand() % n;
        t = strings[v];
        strings[v] = strings[i];
        strings[i] = t;
    }
}

static void check_order(char *sort_type, char *strings[], int n)
{
    int i;

    for (i = 0; i < n; i++) {
        if (atoi(strings[i]) != i) {
            fprintf(stderr, "%s sort failed - exiting (expected " N_FORMAT ", got %s),\r\n", sort_type, i, strings[i]);
            exit(1);
        }
    }
}

int qs_string_compare(const void *a, const void *b)
{
    return strcmp(*(char **)a, *(char **)b);
}

void compare_sorts(void)
{
    char *strings[N], *strings_copy[N];
    char buffer[N*(LOG10_N+1)];
    char *p;
    clock_t starttime, endtime;
    int i;

    p = buffer;
    for (i = 0; i < N; i++) {
        sprintf(p, N_FORMAT, i);
        strings[i] = p;
        p += LOG10_N+1;
    }
    randomise(strings, N);

#if N <= 10000
    /* Do insertion sort */
    memcpy(strings_copy, strings, sizeof(strings));
    starttime = clock();
    insert_sort(strings_copy, N);
    endtime = clock();
    check_order("Insertion", strings_copy, N);
    printf("Insertion sort took %llu clock ticks\r\n", endtime - starttime);
#else
    printf("Value of N too big to use insertion sort, must be <= 10000\r\n");
#endif

    /* Do shell sort */
    memcpy(strings_copy, strings, sizeof(strings));
    starttime = clock();
    shell_sort(strings_copy, N);
    endtime = clock();
    check_order("Shell", strings_copy, N);
    printf("Shell sort took %llu clock ticks\r\n", endtime - starttime);

    /* Do quick sort - use built-in C library sort */
    memcpy(strings_copy, strings, sizeof(strings));
    starttime = clock();
    qsort(strings_copy, N, sizeof(char *), qs_string_compare);
    endtime = clock();
    check_order("Quick", strings_copy, N);
    printf("Quick sort took %llu clock ticks\r\n", endtime - starttime);
}
