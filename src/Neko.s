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
;   File: Neko.s
;   Author(s): Georg Ziegler
;   Description: This file contains subroutines to control the cat/neko
;   character that moves around the map
;

;----- Includes ----------------------------------------------------------------
.include "SNESRegisters.inc"
.include "CPUMacros.inc"
.include "WRAMPointers.inc"
.include "TileData.inc"
;-------------------------------------------------------------------------------

;----- Assembler Directives ----------------------------------------------------
.p816
.i16
.a8
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Routines found in this file
;-------------------------------------------------------------------------------
.export     UpdateNeko          ; The main subroutine that will take care of Neko
;-------------------------------------------------------------------------------

.segment "CODE"
;-------------------------------------------------------------------------------
;   Reserve RO memory
;-------------------------------------------------------------------------------
SnakeWalkNorth:
    .byte   $00, $02, $04, $02
SnakeWalkSouth:
    .byte   $06, $08, $0a, $08
SnakeWalkWest:
SnakeWalkEast:
    .byte   $40, $42, $44, $42
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Constants used in this file
;-------------------------------------------------------------------------------
    ; Snake constants
SnakeFrameHoldLength= $08       ; number of frames an animation should be held
SnakeWalkSpeed      = $01
SnakeHPos           = OAM + $00
SnakeVPos           = OAM + $01
SnakeSpriteName     = OAM + $02
SnakeAttrib         = OAM + $03
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: UpdateNeko
;   Parameters: -
;   Description: Will react to input and other events for Neko
;-------------------------------------------------------------------------------
.proc   UpdateNeko
        ; code
        rts
.endproc
;----- end of subroutine UpdateNeko --------------------------------------------
