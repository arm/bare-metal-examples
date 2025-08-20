<!--
SPDX-FileCopyrightText: Copyright 2026 Arm Limited and/or its affiliates <open-source-office@arm.com>
SPDX-License-Identifier: MIT
-->

# Arm Bare-Metal Examples Catalogue

## Types of Examples

The following examples are provided:
* [Startup code](#startup-code), including reset handler, interrupt handler, MMU/MPU and cache configuration, floating point initialization, timers, etc.
* [Application code](#application-code) examples that showcase features of Arm tools (compilers, models, and debugger).


### Startup code

| Type                  | Architecture/Processor | Compiler(s)    | Description |
| --------------------- | ---------------------- | -------------- | ----------- |
| Armv9-A startup code  | Armv9-A                | ATfE, GCC      | Multi-core (SMP) startup code examples for Armv9-A, including vector table, reset handler, interrupt handler, cache and MMU configuration, interrupt controller (GICv3) and timer initialization, and NEON support.  Startup code in EL3 switches to EL1N to run the application.  The application here is a multi-core (SMP) prime number generator with mutexes.<br><br>Examples:<br>[startup_Armv9-A_ATfE](examples/startup_Armv9-A_ATfE)<br>[startup_Armv9-A_GCC](examples/startup_Armv9-A_GCC) |
| Armv8-A startup code  | Armv8-A                | ATfE, GCC      | Same as Armv9-A startup code above, but for Armv8-A.<br><br>Examples:<br>[startup_Armv8-A_ATfE](examples/startup_Armv8-A_ATfE)<br>[startup_Armv8-A_GCC](examples/startup_Armv8-A_GCC) |
| Armv8-R startup code  | Cortex-R52, Cortex-R82 | ATfE, GCC      | Single-core examples, including vector table, exception handlers, MPU, cache, TCM, FPU, timer and GIC initialization.  The application performs a floating point calculation, semihosted "sorts" algorithms, and an interrupt-driven clock display.<br><br>Examples:<br>[startup_Cortex-R52_GIC_ATfE](examples/startup_Cortex-R52_GIC_ATfE)<br>[startup_Cortex-R52_GIC_GCC](examples/startup_Cortex-R52_GIC_GCC)<br>[startup_Cortex-R82_GIC_ATfE](examples/startup_Cortex-R82_GIC_ATfE)<br>[startup_Cortex-R82_GIC_GCC](examples/startup_Cortex-R82_GIC_GCC) |

### Application code

| Type                  | Architecture/Processor  | Compiler(s)   | Description |
| --------------------- | ----------------------  | ------------- | ----------- |
| Fireworks             | Armv9-A                 | ATfE, GCC     | Multi-core (SMP) examples for Armv9-A that produce a graphical simulated fireworks display and flying aeroplane banner on the FVP model LCD screen.  Includes Armv9-A startup code as above, plus LCD screen driver, and retargeted printf() output to a UART.  Startup code in EL3 switches to EL1N to run the application.<br><br>Examples:<br>[fireworks_Armv9-A_ATfE](examples/fireworks_Armv9-A_ATfE)<br>[fireworks_Armv9-A_GCC](examples/fireworks_Armv9-A_GCC) |
| Fireworks             | Armv8-A                 | ATfE, GCC     | Same as Armv9-A fireworks above, but for Armv8-A.<br><br>Examples:<br>[fireworks_Armv8-A_ATfE](examples/fireworks_Armv8-A_ATfE)<br>[fireworks_Armv8-A_GCC](examples/fireworks_Armv8-A_GCC) |

For details on each example project, please refer to the readme.md available within it.

Additional examples will be added in future releases.

----

*Copyright 2026 Arm Limited and/or its affiliates*






















































