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
;   File: NekoMacros.inc
;   Author(s): Georg Ziegler
;   Description: This file contains Macros to replace common code snippets
;
.ifndef NEKOMACROS_INC
.define NEKOMACROS_INC

;-------------------------------------------------------------------------------
;   Registers Macros: These sets the registers to specific widths
;-------------------------------------------------------------------------------
.macro  SetXY8                  ; set X and Y to 8-bit
        sep #$10
.endmacro

.macro  SetXY16                 ; set X and Y to 16-bit
        rep #$10
.endmacro

.macro  SetA8                   ; set A to 8-bit
        sep #$20
.endmacro

.macro  SetA16                  ; set A to 16-bit
        rep #$20
.endmacro

.macro  SetAXY8                 ; set all registers to 8-bit
        sep #$30
.endmacro

.macro  SetAXY16                ; set all registers to 16-bit
        rep #$30
.endmacro
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine Macros: Macros mainly used by subroutines
;-------------------------------------------------------------------------------
.macro  PushSizeB    Size       ; push a 1 byte data size to stack
        lda #Size
        pha
.endmacro

.macro  PushSizeW   Size        ; push a 2 byte data size to stack
        pea Size
.endmacro

.macro  PushSizeF   Size        ; push a 3 byte data size to stack
        lda .BANKBYTE(Size)
        pha
        pea .LOWORD(Size)
.endmacro

.macro  PushFarAddr SrcAddr     ; push a .faraddr to stack
        lda .BANKBYTE(SrcAddr)
        pha
        pea .LOWORD(SrcAddr)
.endmacro

.macro  PreserveRegisters
        pha                     ; preserve working registers
        phx
        phy
.endmacro

.macro  RestoreRegisters
        ply                     ; restore working registers
        plx
        pla
.endmacro
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;   Arithmetic Macros: Simplify common arithemic operations
;-------------------------------------------------------------------------------
.macro  ShiftALeft count
    .repeat count
        asl
    .endrepeat
.endmacro

.macro  ShiftARight count
    .repeat count
        lsr
    .endrepeat
.endmacro

.endif  ; NEKOMACROS_INC
