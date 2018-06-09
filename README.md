# Neko Library for SNES programming

This library is a simple starting point for writing SNES applications. It includes basic functionality like transferring data into VRAM and CG-RAM. It is written in 65816 assembly and can be built with [cc65](https://github.com/cc65/cc65).

This is ***not*** a full engine, but rather a set of basic routines and structures to start or add to your own project. The code is geared towards flexibility rather than speed. You will probably need to adjust it to your own code and project.

This is work in progress. There is only basic input handling available and no music functionality whatsoever.

There is a separate repository that hosts a simple example project. You can find it [here](https://github.com/georgjz/neko-test). Build this ROM to see how to use the Neko library.

## Passing Arguments to Subroutines
Unlike most other projects the arguments for the subroutines for loading VRAM, etc. are passed by stack, not by register. This is a deliberate design choice to ensure that call stacks with varying depths work without loss of (register) data. It will also make the subroutines re-entrant and eliminates the need to keep (intermittent) variables for a given subroutine in WRAM. Each level of nesting keeps its own variables on the stack, and when they are no longer needed they simply disappear.

I am aware that subroutines for loading VRAM, CG-RAM, etc. do not necessarily need to be re-entrant, but other subroutines certainly will, so I choose to pass all parameters by stack to keep my codebase consistent.  

*__Important__: The parameters listed in the subroutine header must be passed from right to left on the stack.*

## Structure
In `src/` you will find several directories. Here is a short description of the contents:
* `init/`: Headers and simple reset routines required by the SNES so start correctly.
* `input/`: These routines handle reading both joypads of the SNES.
* `macros/`: Macros to change register sizes, etc.
* `memory/`: Subroutines to transfer memory with DMA to VRAM, CGRAM, etc.

Generally, you will find a `*.s` and `*.inc` file of the same name. Include the `*.inc` file with `.include` in your source code to use the subroutines in the matching `*.s` file.

There is no documentation yet, check the comments in the source files for details for now.
