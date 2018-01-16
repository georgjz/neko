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
;   File: SNESInitialization.s
;   Author(s): Georg Ziegler
;   Description: This file contains routines used to set up the SNES after
;   start up or reset of the system.
;

;----- Includes ----------------------------------------------------------------
.include "SNESRegisters.inc"
;-------------------------------------------------------------------------------

;----- Assembler Directives ----------------------------------------------------
.p816
.i16
.a8
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Routines found in this file
;-------------------------------------------------------------------------------
.export     ClearRegisters      ; Clear all PPU and CPU registers of the SNES
.export     ClearVRAM           ; Clear the complete VRAM to $00
.export     ClearCGRAM          ; Clear CG-RAM to $00 (black)
.export     ClearOAMRAM         ; Clear OAM-RAM to $ff (all sprites off screen)
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: ClearRegisters
;   Parameters: -
;   Description: Clear all PPU and CPU registers to standard values
;-------------------------------------------------------------------------------
.proc   ClearRegisters
        ; code
        rtl
.endproc
;----- end of subroutine ClearRegisters ----------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: ClearVRAM
;   Parameters: -
;   Description: Clear the complete VRAM to $00
;-------------------------------------------------------------------------------
.proc   ClearVRAM
        ; code
        rtl
.endproc
;----- end of subroutine ClearVRAM ---------------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: ClearCGRAM
;   Parameters: -
;   Description: Clear the complete CG-RAM to $00
;-------------------------------------------------------------------------------
.proc   ClearCGRAM
        ; code 
        rtl
.endproc
;----- end of subroutine ClearCGRAM --------------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: ClearOAMRAM
;   Parameters: -
;   Description: Clear the complete OAM-RAM to $ff, which moves all sprites
;   off screen
;-------------------------------------------------------------------------------
.proc   ClearOAMRAM
        ; code
        rtl
.endproc
;----- end of subroutine ClearOAMRAM -------------------------------------------
