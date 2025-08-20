# Cortex-R82 Startup Example Code with GIC for Arm Toolchain for Embedded

This example shows the bare-metal startup code (including GIC) for the Cortex-R82 processor, including vector table, exception handlers, MPU, cache, TCM, FPU, timer and GIC initialization, and is illustrated by a semihosted "sorts" example application and "clock" display.

## Purpose and scope

This example shows the bare-metal startup code (including GIC) for the Cortex-R82 processor, including vector table, exception handlers, MPU, cache, TCM, FPU, timer and GIC initialization. A semihosted "sorts" example is provided in sorts.c for demonstration purposes, that can be replaced by your own application code.

One of the two Dual Timers is used to flash some LEDs. The Generic Timer, configured as a virtual timer, is used to trigger an SGI via the GIC to print a clock display. All three interrupts are routed via the GIC. This example can be run on the FVP_BaseR_AEMv8R model. This example can be used as a framework on which to build your own C/C++ applications.

## Building the example

This example is intended to be built with Arm Toolchain for Embedded on the command-line with the supplied `makefile`.

The application executable is built to be loaded and run in RAM at address 0x0, but could be easily ported to platforms with RAM at other addresses by simply changing the code and data addresses in the linker-script `linker.ld`.

This example depends on semihosting support being available. When run on an FVP model (with or without the Debugger connected), semihosting is handled by the FVP model itself by default.

## Building on the command-line

Navigate to the `...\startup_Cortex-R82_GIC_ATfE` directory, and type:

`make`

The usual `make` rules: `clean` and `all` are provided in the `makefile`.

## Running the example on the FVP model

You can run the example executable directly on the command-line with:

```text
FVP_BaseR_AEMv8R -C cluster0.NUM_CORES=1 -C cluster0.has_aarch64=1 -C cluster0.gicv3.cpuintf-mmap-access-level=2 -C cluster0.gicv3.SRE-enable-action-on-mmap=2 -C cluster0.gicv3.SRE-EL2-enable-RAO=1 -C cluster0.gicv3.extended-interrupt-range-support=1 -a startup_Cortex-R82_GIC_ATfE.axf
```

You should see the LEDs flash on the FVP model, and text output similar to:

```text
Cortex-R82 bare-metal startup example with GIC, using Arm Toolchain for Embedded
Floating point calculation using the FPU...
Float result is        0.937500
Float result should be 0.937500
Insertion sort took 2 clock ticks
Shell sort took 0 clock ticks
Quick sort took 1 clock ticks
00:00:01
00:00:02
00:00:03
00:00:04
00:00:05
:
```

## Debugging

The following sections describe how to debug this example using the Arm Debugger GUI in [Arm Development Studio](https://support.arm.com/tools-and-software/arm-development-studio).  For an overview of Arm Debugger, its capabilities, and how to obtain it, please see [Arm Debugger Product Support](https://support.arm.com/tools-and-software/arm-debugger).  These sections may be used as a reference to debug with other debuggers if they have similar capabilities.  The debug sessions described here use a debug configuration (.launch file).  The .launch file for this example is provided in the Examples in Arm Development Studio.

## Debugging the reset handler

To debug the reset handler, start a debug session:

1. Select **Run \> Debug Configurations...**.
2. Select `startup_Cortex-R82_GIC_ATfE-FVP` from the list of **Generic Arm C/C++ Application** configurations.
3. Select **Debug from entry point** in the **Debugger** tab.
4. Click on **Debug** to start debugging.

The Debugger will download the program's code and data sections to the target, and set the program counter PC to the entry point of the image at `Start` in `startup.S`. The core starts-up in AArch64 EL2S.

1. The first block of instructions inside `Start` check which CPU is running. If run on a multi-core system, all cores other than CPU0 are put into a WFI loop.
2. The next block of instructions configure various system and control registers, including the SCTLR and VBAR registers, and initializes the EL2 Stack Pointer. In the **Registers** view, expand **System**, then expand **Virt**. Single-step (press F5) through these instructions to see these registers being written to.
3. The next block configures the EL2 MPU regions (Code, Data, Stack/Heap) to addresses determined by the linker-script `linker.ld`. In the **Registers** view, expand **System**, then expand **Control**. Single-step (press F5) through these instructions, and see the base address, access control, limit address and enable being set in `PRBAR` and `PRLAR` for each region. The EL2 MPU is enabled later.
4. The next block configures the EL1 context. Single-step (press F5) through these instructions to see these registers being written to.
5. The next block enables the EL2 MPU and caches. In the **Registers** view, expand **System**, then expand **Virt**. Single-step (press F5) through these instructions to see these registers being written to.
6. The next block changes Exception Level from EL2S to EL1S. Single-step (press F5) through these to the ERET instruction to see how this transition is set up, then single-step (press F5) the ERET instruction and see the Exception Level change from EL2S to EL1S.
7. The next block initializes the Stack Pointers for each core, based on an address determined by the linker-script `linker.ld`, and then enables floating point.
8. The next block configures the EL1 MPU regions (Code, Data, Stack/Heap, Peripherals) to addresses determined by the linker-script `linker.ld`. In the **Registers** view, expand **System**, then expand **Control**. Single-step (press F5) through these instructions, and see the base address, access control, limit address and enable being set in `PRBAR` and `PRLAR` for each region.
9. The next block enables the EL1 MPU. In the **Registers** view, expand **System**, then expand **Virt**. Single-step (press F5) through these instructions to see the M bit being set in the `SCTLR`. The caches are enabled later, after RW/ZI initialization.
10. Finally, code execution sets up the C library run-time environment, and branches to `main()`. In the **Commands** view, set a breakpoint on `main()` with `break main`, and run to it (press F8). `main()` is reached in main.c.
11. The C code in `main()` enables the caches, displays a welcome message via semihosting, performs a float calculation to demonstrate floating point (using the FPU, if compiled appropriately), and runs a simple sorts application. It then enables the GIC, virtual timer of the Generic Timer, timer 0 of the SP804 Dual-Timer, and interrupts. Finally, it goes into an endless Wait For Interrupt (WFI) loop.
12. Delete all breakpoints, and continue running (press F8). Notice a clock display is printed (driven by the virtual timer of the Generic Timer), and the LEDs are flashing on the FVP model (driven by timer 0 of the SP804 Dual-Timer).

## Debugging the interrupt handler

To debug the interrupt handler, disconnect, then reconnect in the same way as before, then:

1. Set breakpoint on DualTimer0IRQhandler() with `break DualTimer0IRQhandler` and run to it (press F8). Notice that the LED advances by one step on the FVP model. Run again and again to see the LEDs advancing. Delete that breakpoint.
2. Set breakpoint on SGI1IRQhandler() with `break SGI1IRQhandler` and run to it (press F8). Driven by a millisecond timer, this function updates the clock display once every 1000 times this function is called. Delete that breakpoint, and set a new one immediately after the `if (ms==1000)` test. Run again and again to see the clock updating. Delete that breakpoint.
3. Interrupts to SGI1IRQhandler are driven by the Virtual Timer that triggers an SGI via the GIC. All three interrupt sources (DualTimer0, Virtual Timer, and SGI) are routed via the GIC to the single top-level interrupt handler. To see this in action, set breakpoints on DualTimer0IRQhandler(), SGI1IRQhandler() and virtualTimerIRQhandler().
4. In the **Breakpoints** view, click on the **Manage Signals...** button, select **Stop** and **Print** for **IRQ_EL1_SPx_SECURE**, then **OK**. This is equivalent to typing `handle EL1_IRQ_SPx_SECURE stop print` on the CLI.
5. Continue execution by pressing the green run/continue button (press F8). The IRQ breakpoint in the vector table will be hit shortly after, due to one of the three interrupts occurring.
6. Single-step (press F5) through the `irqFirstLevelHandler` and observe the AAPCS-corruptible registers being pushed onto the stack \[AAPCS=Procedure Call Standard for the Arm Architecture\], and step again to see C code being called from assembler, continue stepping until `irqHandler()`.
7. `irqHandler()` acknowledges the interrupt, identifies the interrupt source, and calls the appropriate interrupt handler. Step through this C code or run to reach one of the handlers. For virtualTimerIRQhandler(), notice that it sends an SGI to immediately trigger a new interrupt to call SGI1IRQhandler(). Step back out of the handler, through the assembler code of `irqFirstLevelHandler` that pops the AAPCS-corruptible registers off the stack, and finally returns from the interrupt.
8. In the **Breakpoints** view, click on the **Manage Signals...** button, deselect **Stop** and **Print** for **EL1_IRQ_SPx_NON-SECURE**, then **OK**. This is equivalent to typing `handle EL1_IRQ_SPx_NON-SECURE nostop noprint` on the CLI.

## Viewing GIC registers

The GIC "CPU Interface" (ICC\_\*) and "Virtual interface control" (ICH\_\*) registers are System Registers, so appear automatically in the **Registers** view if present in the current platform. To view these, expand **System \> GIC**.

By contrast, the GIC "Distributor" (GICD\_\*) and "Redistributor" (GICR\_\*) registers are memory-mapped, so do not appear in the Registers view by default.

However, the missing registers can be added to the Registers view by using the following "peripheral" commands, either entered in the Commands view, or executed as a script, or added into a .launch file:

```text
peripheral add type Dist_base id $GIC::$Dist address 0xAF000000
peripheral add type RD_base id $GIC::$Redist address 0xAF100000
```

Use "peripheral show" then e.g. "peripheral show GICv3" to reveal all supported register-frame types.

The newly added registers can be seen in the **Registers** view. For AArch64+AArch32 platforms, expand **Peripherals \> GIC**. For AArch64-only platforms, expand **GIC**. Then expand **Dist** and **Redist**.

## Capturing a history of instruction execution ("trace") from the FVP model

To capture a history of instruction execution ("trace") from the FVP model and view it in the Debugger, first disconnect any existing debug session, then:

1. In the **Project Explorer** view, double-click on the `.launch` file.
2. In the **Edit Configuration** dialog, press the "DTSL Options" **Edit...** button.
3. In the **DTSL Configuration** dialog, select **Model Trace** in the **Trace Buffer** tab, and **Enable trace** for the core(s) of interest in the **Core Trace** tab, then press **OK**.
4. In the **Edit Configuration** dialog, press the **Debug** button.
5. Open the **Trace** view.
6. Run and debug as before. A history of instruction execution for the current core is displayed in the **Trace** view.
7. In a multi-core system, to view the trace from one of the other cores, select the other core in the **Debug Control** view.

## See also:

- [Arm Dual-Timer Module (SP804)](https://developer.arm.com/documentation/ddi0271)
- [Learn the architecture - Generic Timer](https://developer.arm.com/documentation/102379)
- [Learn the architecture - Arm Generic Interrupt Controller v3 and v4](https://developer.arm.com/documentation/198123)
- [Arm Development Studio Getting Started Guide](https://developer.arm.com/documentation/101469/latest/)
- [Arm Development Studio User Guide](https://developer.arm.com/documentation/101470/latest/)
- [Arm Debugger Command Reference](https://developer.arm.com/documentation/101471/latest/)
- [Fast Models Fixed Virtual Platforms in Arm Development Studio Reference Guide](https://developer.arm.com/documentation/110379/latest/)
- [DSTREAM User Guide](https://developer.arm.com/documentation/100955/latest)
- [Arm Toolchain for Embedded Professional User Guide](https://developer.arm.com/documentation/107976/latest/)
- [Arm Toolchain for Embedded Migration Guide](https://developer.arm.com/documentation/110599/latest/)
