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
;   File: GameObject.s
;   Author(s): Georg Ziegler
;   Description: This file contains subroutines to handle game sprite objects
;

;----- Includes ----------------------------------------------------------------
.include "SNESRegisters.inc"
.include "CPUMacros.inc"
.include "WRAMPointers.inc"
;-------------------------------------------------------------------------------

;----- Assembler Directives ----------------------------------------------------
.p816
.i16
.a8
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Routines found in this file
;-------------------------------------------------------------------------------
.export     GameObject          ; A struct that represents a game object
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Structs
;-------------------------------------------------------------------------------
.struct GameObject
    XPos    .byte
    YPos    .byte
    Heading .byte
.endstruct
;-------------------------------------------------------------------------------

.segment "CODE"
;-------------------------------------------------------------------------------
;   Subroutine: PollJoypad1
;   Parameters: -
;   Description: Poll data from Joypad 1 and update pointers
;-------------------------------------------------------------------------------

;----- end of subroutine PollJoyPad2 -------------------------------------------
