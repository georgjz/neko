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
;   File: CPUMacros.s
;   Author(s): Georg Ziegler
;   Description: This file contains Macros to replace common code snippets
;
.ifndef CPUMACROS_INC
.define CPUMACROS_INC

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
.macro  PreserveRegisters
        pha                     ; preserve working registers
        phx
        phy
        php
.endmacro

.macro  RestoreRegisters
        plp 
        ply                     ; restore working registers
        plx
        pla
.endmacro
;-------------------------------------------------------------------------------

.endif  ; CPUMACROS_INC
