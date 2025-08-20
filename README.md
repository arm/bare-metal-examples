<!--
SPDX-FileCopyrightText: Copyright 2026 Arm Limited and/or its affiliates <open-source-office@arm.com>
SPDX-License-Identifier: MIT
-->

# Arm Bare-Metal Examples

## Introduction

A selection of bare-metal examples for Arm [processors](https://www.arm.com/products/silicon-ip-cpu) and [architectures](https://www.arm.com/architecture/cpu) are given here, to demonstrate features of the Arm Architectures and tools, and to help users get started with their own projects.

These include:
* [Startup code](catalogue.md#startup-code), including reset handler, interrupt handler, MMU/MPU and cache configuration, floating point initialization, timers, etc.
* [Application code](catalogue.md#application-code) examples that showcase features of Arm tools (compilers, models, and debugger).

For the full list of examples given here, see the [catalogue](catalogue.md).  This is a small subset of the examples provided in [Arm Development Studio](https://support.arm.com/tools-and-software/arm-development-studio).

The examples source code is written in C and assembler.  The examples are intended to be compiled with Arm Toolchain for Embedded (ATfE) or GNU GCC, run on the Architecture Envelope Model (AEM) Fixed Virtual Platform (FVP) models, and debugged with a debugger such as the [Arm Debugger](https://support.arm.com/tools-and-software/arm-debugger).

To get started, you will need to:
* download [GNU make](https://www.gnu.org/software/make/), unzip/install it, and add it to the path.  These examples have been tested with GNU make version 4.2.
* download [ATfE](https://github.com/arm/arm-toolchain/releases) and/or [GCC](https://gitlab.arm.com/tooling/gnu-toolchains-for-arm), unzip/install, and add them to the path.  These examples have been tested with ATfE version 22.1.0 and GCC version 15.3.1.
* download the [FVP_Base_RevC_AEMvA and FVP_Base_AEMv8R AEM FVPs](https://support.arm.com/tools-and-software/fixed-virtual-platforms/arm-architecture-fvps), unzip/install, and add them to the path.  These examples have been tested with the AEM FVPs version 11.32.
* optionally, obtain Arm Debugger (provided within [Arm Development Studio](https://support.arm.com/tools-and-software/arm-development-studio#Downloads)), and a license to use it.

## Additional Notes

* The example projects are provided to demonstrate features of the Arm Architectures and tools, and to help users get started with their own projects.  They should not be assumed to be complete and correct, and not used for test/validation purposes.
* The example projects have been tested to work with GNU make 4.2, ATfE 22.1.0, GCC 15.3.1, Arm FVP 11.32, Arm Debugger 11.0.  They are likely to build/run/debug successfully (perhaps with some minor modifications needed) with other versions of these tools, but this has not been tested.
* User guides for the Arm Architecture are available at [Learn The Architecture](https://www.arm.com/architecture/learn-the-architecture).

## License

Example projects are licensed under the MIT license. Please see the [LICENSE](LICENSE).

## Feedback and Support

* For feedback and support on these example projects, please use this repository's [Issue Tracker](https://github.com/arm/bare-metal-examples/issues).
* For feedback and support on the open-source or other tools, please contact the individual tool suppliers.
* For support on the use of Arm Development Studio and its component tools, please raise a support case via [Arm Support](https://support.arm.com/).
* Arm licensees may contact Arm directly through their Partner Managers.

----

*Copyright 2026 Arm Limited and/or its affiliates*
