; Copyright (C) 2018 Georg Ziegler
;
; Permission is hereby granted, free of charge, to any person obtaining a copy of
; this software and associated documentation files (the "Software"), to deal in
; the Software without restriction, including without limitation the rights to
; use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
; of the Software, and to permit persons to whom the Software is furnished to do
; so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in
; all copies or substantial portions of the Software.
; -----------------------------------------------------------------------------
;   File: MemoryUtils.inc
;   Author(s): Georg Ziegler
;   Description: This a header file for MemoryUtils.s, include this
;   to use the subroutines in afore mentioned file
;
.ifndef MEMORYUTILS_INC
.define MEMORYUTILS_INC

;-------------------------------------------------------------------------------
;   Routines found in this file
;-------------------------------------------------------------------------------
.import     LoadTileSet         ; Load a tile set into VRAM
.import     LoadPalette         ; Load palette data into CG-RAM
;-------------------------------------------------------------------------------

.endif  ; MEMORYUTILS_INC
