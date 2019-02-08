## 0.5.4 - Minor fix
* Fixed the header guards of all include files, should now work as expected (include a header multiple times will have no negative effect)

## 0.5.3 - Minor code improvements
* Minor fixes in the macros code
* Better code relocatability

## 0.5.2 - Add DPAD Constant
* Add a constant to `NekoConstants.inc` that helps checking whether a DPAD button was pressed.

## 0.5.1 - Improve Input Handling
* The PollJoypad1 and PollJoypad2 subroutines now no longer need a fixed symbol/address for storing input data. Now the subroutines will store the input data in the address/pointer passed by stack to the subroutines.
* Fix small things in the macros

## 0.5 - Remove testrom branch
* I removed the `testrom` branch to keep this repository clean. The test ROM files have been moved to [neko-test](https://github.com/georgjz/neko-test). Check it for build instructions.

## 0.4 - Improve and streamline subroutine calling
* The repository has been split in two branches: the `master` branch contains the library code; while `testrom` contains files for building a example ROM for how to use the library routines. Check `README.md` for details.

## 0.3 - Major restructure
* The directory structure changed to better reflect the separate parts of the
program
* Makefile updated to work better with custom file structure
* See README for more details

## 0.2 - New Graphics and Input handling
* Added a new simple cat sprite sheet that the player can control
* Basic Camera moving works

## 0.1.2 - New Graphic File
* Tile Data/Graphics are now in their own file to make the code lean and
clean. They are now included in `src/TileData.s` and `src/include/TileData.inc`
* Explicit `.smart` command no longer needed, the assembler now does this
automatically. Can be turned off by removing the `-s` argument from the
assembler flags in `makefile`

## 0.1.1 - Build System Update
* Removed shell commands from `makefile`, should now build on Windows too
* Makefile will now automatically search all subdirectories of SRCDIR for
source and includes files and add them to build list

## 0.1.0 - First Release
* Simple starting point for writing SNES programs, see README.md
