# Neko Library for SNES programming

This library is a simple starting point for writing SNES applications. It includes basic functionality like transferring data into VRAM and CG-RAM. It is written in 65816 assembly and can be built with [cc65](https://github.com/cc65/cc65).

This is ***not*** a full engine, but rather a set of basic routines and structures to start or add to your own project. The code is geared towards flexibility rather than speed. You will probably need to adjust it to your own code and project.

This is work in progress. There is only basic input handling available and no music functionality whatsoever.

## Repository structure

This repository has two branches, `master` and `testrom`. `master` includes only the subroutines and it's headers. `testrom` includes some additional files that will enable you to build a example ROM that uses the library subroutines.

See *Building the test ROM* below for details.

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

## Building the test ROM
If you want to see this library's subroutines in action, checkout the `testrom` branch. This branch includes additional files for building a self-contained working SNES ROM.

There is a makefile that should take care of it. Simple clone the code and use make to build it:
```
$ git clone https://github.com/georgjz/neko.git
$ cd neko
$ git checkout testrom
$ make
```
At the very beginning of the makefile there are two options you can set:
```
# Edit this portion to fit your project
MMAP		= MemoryMap.cfg			# memory map file needed by ld65 linker
BUILDNAME	= NekoCradle.smc     	# name of the final ROM
```
The `MMAP` is the name of the memory map file ld65 needs to build the ROM. Check the [cc65 toolchain documentation](https://cc65.github.io/doc/) for details. `BUILDNAME` will simply determine the name of the output ROM file. This file will be placed in `build/release`. There is no debug option in the makefile yet.

*__Warning__: Do not alter anything else in the makefile unless you know how makefiles work.*  

In the directory `neko` you will find a simple sample program. It will load a tile map and a simple sprite sheet of a cat into VRAM. The cat can be moved with the DPad of Joypad 1. Once the cat comes to close to the screen boundry, the camera will pan in the walking direction.

*__WARNING__: There is a bug in the camera movement code: some times the camera will jump a screen instead of panning smoothly when the cat hits the scroll boundry. It does not happen every time the game is started, but every other. Simple reload the ROM if you experience this. I tested only with the [bsnes+ emulator](https://github.com/devinacker/bsnes-plus).

I'm still working on a fix.*
