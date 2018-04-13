# Neko Cradle for SNES programming
This is a simple starting point for writing SNES applications. It includes
basic functionality like transferring data into VRAM and CG-RAM. It is written
in 65816 assembly and can be built with [cc65](https://github.com/cc65/cc65).

This is ***not*** a full engine, but rather a set of basic routines and
structures to start your own project. The code is geared towards
flexibility rather than speed. You will probably need to adjust it to your
own code and project.

This is work in progress. There is only basic input handling available and no
music functionality whatsoever.

## A word on the subroutines and passing arguments
Unlike most other projects the arguments for the subroutines for
loading VRAM, etc. are passed by stack, not by register. This is a
deliberate design choice to ensure that call stacks with varying depths
work without loss of (register) data. It will also make the subroutines
re-entrant and eliminates the need to keep (intermittent) variables for a given
subroutine in WRAM. Each level of nesting keeps its own variables on the stack,
and when they are not needed, they simply disappear.

I am aware that subroutines for loading VRAM, CG-RAM, etc. do not
necessarily need to be re-entrant, but other subroutines certainly will, so
I choose to pass all parameters by stack to keep my codebase consistent
throughout.  

*__Important__: The parameters listed in the subroutine header must be passed
from right to left on the stack.*

## Structure
In `src/` you will find several directories. Here is a short description of the
contents:
* `input`: These routines handle reading both joypads of the SNES.
* `macros`: Macros to change register sizes, etc.
* `memory`: Subroutines to transfer memory with DMA to VRAM, CGRAM, etc.
* `neko`: A simple example game of a cat walking around. See *Sample Code* below.
* `snesinit`: Subroutines to initialize the SNES before running a game.
Generally, you will find a `s` and `inc` file of the same name. Include the `inc`
file with `.include` in your source code to use the subroutines in the matching
`s` file.

## Building
There is a makefile that should take care of it. Simple clone the code and use make
to build it:
```
$ git clone https://github.com/georgjz/neko.git
$ cd meko
$ make
```
At the very beginning of the makefile there are two options you can set:
```
# Edit this portion to fit your project
MMAP		= MemoryMap.cfg			# memory map file needed by ld65 linker
BUILDNAME	= NekoCradle.smc     	# name of the final ROM
```
The `MMAP` is the name of the memory map file ld65 needs to build the ROM. Check
the [cc65 toolchain documentation](https://cc65.github.io/doc/) for details.
`BUILDNAME` will simply determine the name of the output ROM file. This file will
be placed in `build/release`. There is no debug option in the makefile yet.
*__Warning__: Do not alter anything else in the makefile unless you know how makefiles
work.*  

## Sample Code
In `src/neko` you will find a simple sample program. It will load a tile
map and a simple sprite sheet of a cat into VRAM. The cat can be moved with the
DPad of Joypad 1. Once the cat comes to close to the screen boundry, the camera
will pan in the walking direction.

*__WARNING__: There is a bug in the camera movement code: some times the
camera will jump a screen instead of panning smoothly when the cat hits the
scroll boundry. It does not happen every time the game is started, but every other.
I'm still working on a fix.*
