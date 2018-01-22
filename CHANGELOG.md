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
