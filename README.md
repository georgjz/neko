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
loading VRAM, etc. will be passed by stack, not by register. This is a
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

## Sample Code
In `src/NekoCradle.s` you will find a sample program, that will load a tileset
and corresponding tilemap into VRAM. The graphics are stored in `src/tiledata`.
You can scroll around the screen with the DPad of controller 1. The corners of
the scroll area are marked with white tiles. Again, this code is not geared
towards speed but readability and understanding, since this is also a
learning project for me.
