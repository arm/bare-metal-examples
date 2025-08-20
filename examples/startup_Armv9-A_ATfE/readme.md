# Armv9-A SMP AArch64 Startup Code for Arm Toolchain for Embedded

This is a multi-core (SMP) startup code example for AArch64, written in C and assembler, to demonstrate support for building and debugging Armv9-A bare-metal applications with Arm Toolchain for Embedded and the Debugger.

## Purpose and scope

This is a multi-core (SMP) startup code example for AArch64, written in C and assembler, to demonstrate support for building and debugging Armv9-A bare-metal applications with Arm Toolchain for Embedded and the Debugger. 
It includes a vector table, reset handler, cache and MMU configuration, interrupt controller (GICv3) initialization, NEON support, and is illustrated by a semihosted SMP prime number generator example application. It illustrates Debugger support for Armv9-A, AArch64, SMP, Exception Level changing, and semihosting.

The executable is intended for running on an Armv9-A SMP FVP model such as the RevC-2xAEMvA FVP model.

Console output is semihosted by default, but may be retargeted to a UART (see "Retargeting" below).

For a good debug view, the compiler's optimization level is set to -O1 in the `makefile`. You can change this to raise the optimization level to -O2 or -O3 for higher performance code generation, but at the cost of a worse debug view.

## Building the example

This example can be built with Arm Toolchain for Embedded on the command-line with the supplied `makefile` using the `make` utility.

Navigate to the `...\startup_Armv9-A_ATfE` directory, and type:

`make`

The usual `make` rules: `clean` and `all` are provided in the `makefile`.

The makefile compiles the sources as:

`clang -c --target=aarch64-none-elf -march=armv9-a -g -O1`

## Running the example

```text
FVP_Base_RevC-2xAEMvA -C cluster0.NUM_CORES=4 -C cluster1.NUM_CORES=0 -C bp.secure_memory=0 -C cache_state_modelled=0 -C pctl.startup=0.*.*.* -C cluster0.has_arm_v9-0=1 -a startup_Armv9-A_ATfE.axf
```

### Retargeting

Console output (`printf()` strings, etc) may either be performed using semihosting or be redirected ("retargeted") to a UART using `retarget.c`. In the `makefile`, select either `OUTPUTCHAN ?= SEMIHOSTED` or `OUTPUTCHAN ?= UART`, then rebuild the example. When run on an FVP model with UART selected, console output will go to a modelled PL011 UART, and be displayed in a telnet window. A telnet client must be installed on your host PC. See "Known issues and troubleshooting" below.

## Debugging

The following sections describe how to debug this example using the Arm Debugger GUI in [Arm Development Studio](https://support.arm.com/tools-and-software/arm-development-studio).  For an overview of Arm Debugger, its capabilities, and how to obtain it, please see [Arm Debugger Product Support](https://support.arm.com/tools-and-software/arm-debugger).  These sections may be used as a reference to debug with other debuggers if they have similar capabilities.  The debug sessions described here use a debug configuration (.launch file).  The .launch file for this example is provided in the Examples in Arm Development Studio.

## Debugging AArch64 code at source-level across different exception levels

You can debug AArch64 code at source-level across different exception levels using the Debugger.

The Debugger supports these address prefixes to represent the virtual memory spaces ("translation regimes") for AArch64:

- "EL3:" to represent EL3 (always secure, but can access non-secure memory)
- "EL2:" to represent EL2 (always non-secure) or, if Armv8.4-SecEL2 is implemented, "EL2S:" for secure or "EL2N:" for non-secure
- "EL1S:" to represent Secure EL1/EL0
- "EL1N:" to represent Non-secure EL1/EL0

This is similar to the use of "S:", "N:" and "H:" for Secure, Non-secure and Hypervisor in Armv7-A/R.

These prefixes can be used by you:

- to load symbols associated with a memory space, for example:

  `add-symbol-file foo.axf EL1N:0`
- to set breakpoints, for example:

  `break EL1N:main`
- to view/modify the content of memory, for example:

  enter "`EL1N:0x80000000`" in the Memory view, or on the command-line:

  `x EL1N:0x80000000`

The Debugger also uses these prefixes when reporting the current memory space where the code stopped, for example:

`Execution stopped in EL3h mode at EL3:0x0000000080000000`

The prefixes used for AArch32 are the same as for Armv7-A/R ("S:", "N:" and "H:").

There is no prefix for EL0 because the same Translation Table Base Register (TTBR) is used for both EL0 and EL1. This TTBR points to the Translation Tables for either Secure EL1/EL0 or Non-secure EL1/EL0. \[This is a simplification - there are actually two TTBRs, TTBR0_EL1 and TTBR1_EL1, that may be used for the stage 1 translation of memory accesses at EL0 and EL1, depending on the settings in TCR_EL1\]. The consequence of this is that if the core is stopped in e.g. AArch64 EL0 in secure state, the debugger will report:

`Execution stopped in EL0t mode at EL1S:0x0000000080000000`

Note that the "EL1S:" here is the memory space. The exception level here is "EL0t", which is held in the `$AArch64::$System::$PSTATE::$Mode` register.

To debug AArch64 code across different exception levels with the Debugger you can, for example, first load the image and symbols at EL3 with:

`loadfile yourimage.elf`

then use a command sequence to load the symbols for all other ELs they apply to, for example:

`add-symbol-file yourimage.elf EL1N:0`

`add-symbol-file yourimage.elf EL1S:0`

In the Debugger's debug launcher, put the add-symbol-file commands into the **Debugger** tab "Execute debugger commands" field.

If yourimage.elf is already specified in the **Files** tab, then there's no need to use a loadfile command too.

The ":0" part of the address qualifier is an offset, that allows rebasing of symbols to an offset address. The offset is often 0, but is not always necessarily so. For example, for source-level debug of the Linux Kernel before the MMU is enabled you need to calculate the \<offset\> between the virtual and physical addresses of the code. For instance if the kernel is linked at virtual address 0xC0008000 and has been loaded at physical address 0x80008000, the offset is (P - V) = (0x80008000 - 0xC0008000) = -0x40000000. For source-level debug after the MMU is enabled, the offset is usually zero.

## Debugging the example

1. Select **Run \> Debug Configurations...**.
2. Select `startup_Armv9-A_ATfE_FVP` from the list of **Generic Arm C/C++ Application** configurations.
3. In the **Files** tab, notice that **Load symbols** is ticked. This loads symbols for the EL3 virtual memory space ("translation regime") that the core(s) start up in by default.
4. In the **Debugger** tab, select **Debug from entry point**. Notice that an `add-symbol-file` command is used to load symbols for the EL1N memory space. The startup code switches the Exception Level from EL3 to EL1N before reaching the `main()` function.
5. Click on **Debug** to start debugging. The executable image will be downloaded to the target and the PC set to the entry point at `start64` in `startup.S`.
6. The startup code will be executed by all cores in the model. The cores start up in AArch64 EL3 by default in the model. The startup code starts with some common basic initialization, such as setting up the VBARs, configuring Exception Levels EL3, EL2 and EL1, preparing some stack space in EL3 for each processor, and setting up the GIC, before switching from EL3 to EL1N. You can single-step through this code if you wish (press F6), to see the registers changing.
7. In the **Registers** view, expand **AArch64**, then expand **Core** to see the core AArch64 registers.
8. To see the Exception Level switching from EL3 to EL1N, in the **Command** field, enter `break EL3:drop_to_el1`. Continue execution (press F8). Code execution will stop at `drop_to_el1` in EL3. Single-step (press F5) the next instructions, up to and including the `eret`. After executing the `eret`, the processor switches from EL3 to EL1N and lands at `el1_entry_aarch64`, still in AArch64.
9. Once in EL1, the code then sets up the application stack for each processor, enables floating point, invalidates the caches and TLBs for all stage 1 translations used at EL1, sets the Translation Table Base address, and sets memory attributes. You can single-step through this code if you wish (press F6), to see the registers changing, up to the point where code execution forks depending on whether it is executing on the primary processor or a secondary processor. CPU0 is nominated as the primary processor, the other CPUs are secondary processors.
10. In the **Breakpoints** view, delete all breakpoints.
11. To see effects of the fork, in the **Command** field, enter `break EL1N:el1_primary` then `break EL1N:el1_secondary`. Continue execution (press F8). Code execution will stop at `el1_primary` or `el1_secondary` depending on which processor the code is executing. Within `el1_secondary`, the secondary processors go to sleep until the primary processor wakes them up with an interrupt. Within `el1_primary`, the primary processor completes its initialization, including setting up its MMU. Then the C library and the C run-time environment are initialised, before calling main(). This only needs to be done once, hence is done by the primary processor only. The primary processor will wake up the secondary processors later, within `main()`. Delete all the existing breakpoints before continuing.
12. To see the primary processor waking up the secondary processors, in the **Command** field, enter `break EL1N:main`, then continue execution (press F8). Code execution will stop at `main()`. In the Debug Control view, select the other cores in turn, to see them all in the Wait For Interrupt (`wfi`) loop. The primary processor wakes the secondary processors by calling `SendSGI`. After waking-up, the secondary processors complete their initialization, including setting up their MMU. All processors eventually call the `MainApp`.
13. In the **Command** field, enter `break EL1N:MainApp`, and continue execution (press F8). Within `MainApp`, all CPUs are used to execute the primes application.
14. In the **Breakpoints** view, delete all breakpoints and continue execution (press F8). Text output from the main application appears in the **Target Console** view.

## Viewing the MMU and page-table configuration

Disconnect, then reconnect in the same way as before. Set a breakpoint on `main()` with `break EL1N:main`, then run (press F8) to the breakpoint.

Startup code executed earlier by CPU0 will have already configured the page-tables and enabled the MMU. To view the MMU and page-table configuration:

1. Open the **MMU/MPU** view with **Window \> Show View \> MMU/MPU**.
2. In the **MMU/MPU** view, select the **Memory Map** tab, then click on **Show Memory Map**. This gives a top-level view of the virtual memory layout, by combining translation table entries that map to contiguous regions of physical memory with common memory type, cacheability, shareability and access attributes.
3. In the **MMU/MPU** view, select the **Tables** tab, then expand **TTBR0_EL1**. The lower pane shows TTBR0_EL1 points to page-tables at NP:0x00000000800CD000. Scroll down through the page-tables to see (non Fault) entries at 0x1C000000, 0x2F000000, 0x80000000. Notice that for this example, each entry is "flat-mapped" - an input (virtual) address 0x80000000 maps to the same output (physical) address 0x80000000.
4. In the **Commands** view, enter `mmu print`. This gives a similar output to the above:

   ```text
   mmu print
   Input Address         | Type           | Next Level            | Output Address        | Properties
   -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   + 0x00000000          | TTBR0_EL1      | NP:0x00000000800BC000 |                       | TBI1=0, TBI0=0, AS=0, IPS=4GB, TG1=4KB, SH1=0x0, ORGN1=0x0, IRGN1=0x0, EPD1=1, A1=0, T1SZ=0, TG0=4KB, SH0=0x3, ORGN0=0x1, IRGN0=0x1, EPD0=0, T0SZ=32, ASID=0
    + 0x00000000         | Level 1 Table  | NP:0x00000000800BF000 |                       | APTable=0x0, UXNTable=0, PXNTable=0
     - 0x00000000        | Invalid (x224) |                       |                       |
     - 0x1C000000        | Level 2 Block  |                       | NP:0x000000001C000000 | UXN=0, PXN=0, Contiguous=0, nG=1, AF=1, SH=0x0, AP=0x0, AttrIndx=0x2
     - 0x1C200000        | Invalid (x151) |                       |                       |
     - 0x2F000000        | Level 2 Block  |                       | NP:0x000000002F000000 | UXN=0, PXN=0, Contiguous=0, nG=1, AF=1, SH=0x0, AP=0x0, AttrIndx=0x2
     - 0x2F200000        | Invalid (x135) |                       |                       |
    - 0x40000000         | Invalid        |                       |                       |
    + 0x80000000         | Level 1 Table  | NP:0x00000000800BD000 |                       | APTable=0x0, UXNTable=0, PXNTable=0
     - 0x80000000        | Level 2 Block  |                       | NP:0x0000000080000000 | UXN=0, PXN=0, Contiguous=0, nG=1, AF=1, SH=0x3, AP=0x0, AttrIndx=0x1
     - 0x80200000        | Invalid (x511) |                       |                       |
   :
   ```
5. In the **MMU/MPU** view, select the **Translation** tab. This allows you to see which physical address is mapped to a particular virtual address, and vice-versa. For example, enter 0x80000000, select **Virtual to Physical** then press **Translate**. The lower pane shows the translated address. For this example, the translated address is 0x80000000 because this example uses "flat-mapping". Now select **Physical to Virtual** then press **Translate**. Again the result is 0x80000000.
6. In the **Commands** view, enter `mmu translate 0x80000000` then press **Submit**. This gives a similar output to the Virtual to Physical address translation above. To translate Physical to Virtual addresses, enter, for example, `mmu translate NP:0x80000000`.
7. Disconnect.

## Debugging the interrupt handler

To debug the interrupt handler, disconnect, then reconnect in the same way as before, then:

1. In the **Breakpoints** view, click on the **Manage Signals...** button, select **Stop** and **Print** for **EL1_IRQ_SPx_NON-SECURE**, then **OK**. This is equivalent to typing `handle EL1_IRQ_SPx_NON-SECURE stop` on the CLI.
2. Continue execution by pressing the green run/continue button (press F8). The IRQ breakpoint will be hit shortly after, due to the timer interrupt occurring.
3. Restart execution again (press F8). The LEDs will advance, and the code runs for another short period until the timer interrupt occurs again.
4. Single-step (press F5) through the `irqFirstLevelHandler` and observe the AAPCS-corruptible registers being pushed onto the stack \[AAPCS=Procedure Call Standard for the Arm Architecture\], and step again to see C code being called from assembler, continue stepping until `irqHandler()`.
5. `irqHandler()` clears the timer interrupt and advances the LED sequence. Step through this C code in `irqHandler()`, and back out through the assembler code of `irqFirstLevelHandler` that pops the AAPCS-corruptible registers off the stack, and finally returns from the interrupt.
6. In the **Breakpoints** view, click on the **Manage Signals...** button, deselect **Stop** and **Print** for **EL1_IRQ_SPx_NON-SECURE**, then **OK**. This is equivalent to typing `handle EL1_IRQ_SPx_NON-SECURE nostop noprint` on the CLI.

## Viewing GIC registers

The GIC "CPU Interface" (ICC\_\*) and "Virtual interface control" (ICH\_\*) registers are System Registers, so appear automatically in the **Registers** view if present in the current platform. To view these, expand **System \> GIC**.

By contrast, the GIC "Distributor" (GICD\_\*) and "Redistributor" (GICR\_\*) registers are memory-mapped, so do not appear in the Registers view by default.

However, the missing registers can be added to the Registers view by using the following "peripheral" commands, either entered in the Commands view, or executed as a script, or added into a .launch file:

```text
peripheral add type Dist_base id $GIC::$Dist address 0x2F000000
peripheral add type RD_base id $GIC::$Redist address 0x2F100000
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

## Known issues and troubleshooting

- On Windows, when connected to a Fixed Virtual Platform (FVP) model and debugging an application that uses a telnet console, the following error may be reported: `Windows cannot find "C:\Windows\System32\telnet.exe"` or `No telnet executable was found on your system`. Arm FVP models can make use of "telnet" as a serial terminal, to enable serial data to be transferred from application code running on an Arm FVP via a modelled UART to a serial terminal. This error occurs when the telnet client is disabled or otherwise unavailable on your computer. The telnet client is disabled by default on Windows. To enable the telnet client on Windows 11:

  1. From the Start menu, select "Settings"
  2. Search for "Turn Windows features on or off"
  3. From the list that appears, tick the "Telnet Client" checkbox
  4. Click "OK" to close the dialog and install the feature.

## See also:

- [Arm Development Studio Getting Started Guide](https://developer.arm.com/documentation/101469/latest/)
- [Arm Development Studio User Guide](https://developer.arm.com/documentation/101470/latest/)
- [Arm Debugger Command Reference](https://developer.arm.com/documentation/101471/latest/)
- [Fast Models Fixed Virtual Platforms in Arm Development Studio Reference Guide](https://developer.arm.com/documentation/110379/latest/)
- [Arm Toolchain for Embedded Professional User Guide](https://developer.arm.com/documentation/107976/latest/)
- [Arm Toolchain for Embedded Migration Guide](https://developer.arm.com/documentation/110599/latest/)
