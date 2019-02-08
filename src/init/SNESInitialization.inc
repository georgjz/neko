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
;   File: SNESInitialization.inc
;   Author(s): Georg Ziegler
;   Description: This a header file for SNESInitialization.s, include this
;   to use the subroutines in afore mentioned file
;
.ifndef SNESINITIALIZATION_INC
SNESINITIALIZATION_INC = 1

;-------------------------------------------------------------------------------
;   Routines found in this file
;-------------------------------------------------------------------------------
.import     ClearRegisters      ; Clear all PPU and CPU registers of the SNES
.import     ClearVRAM           ; Clear the complete VRAM to $00
.import     ClearCGRAM          ; Clear CG-RAM to $00 (black)
.import     ClearOAMRAM         ; Clear OAM-RAM to $ff (all sprites off screen)
;-------------------------------------------------------------------------------

.endif  ; SNESINITIALIZATION_INC
