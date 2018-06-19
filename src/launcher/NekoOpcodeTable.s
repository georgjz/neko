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
;   File: NekoOpcodeTable.s
;   Author(s): Georg Ziegler
;   Description: This file contains the RTS return table for the Neko Library.
;   This table is used by OpcodeLauncher.s
;
; .ifndef NEKOOPCODETABLE_INC
; .define NEKOOPCODETABLE_INC

;-------------------------------------------------------------------------------
;   Include subroutine symbols
;-------------------------------------------------------------------------------
.include    "SNESInitialization.inc"
.include    "InputUtils.inc"
.include    "MemoryUtils.inc"
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Routines found in this file
;-------------------------------------------------------------------------------
.export     NekoLibRTSTableL
.export     NekoLibRTSTableH
;-------------------------------------------------------------------------------

.segment "NEKOLIB"
;-------------------------------------------------------------------------------
;   Neko Library RTS Return Table
;-------------------------------------------------------------------------------
    ; this will act as a return table, split into high and low byte
NekoLibRTSTableL:
    ; SNESInitialization.inc
.byte   <(ClearRegisters - 1)       ; Op Code $00
.byte   <(ClearVRAM - 1)            ; Op Code $01
.byte   <(ClearCGRAM - 1)           ; Op Code $02
.byte   <(ClearOAMRAM - 1)          ; Op Code $03
    ; InputUtils.inc
.byte   <(PollJoypad1 - 1)          ; Op Code $04
.byte   <(PollJoypad2 - 1)          ; Op Code $05
    ; MemoryUtils.inc
.byte   <(LoadTileSet - 1)          ; Op Code $06
.byte   <(LoadPalette - 1)          ; Op Code $07
.byte   <(LoadTileMap - 1)          ; Op Code $08
.byte   <(UpdateOAMRAM - 1)         ; Op Code $09

NekoLibRTSTableH:
    ; SNESInitialization.inc
.byte   >(ClearRegisters - 1)       ; Op Code $00
.byte   >(ClearVRAM - 1)            ; Op Code $01
.byte   >(ClearCGRAM - 1)           ; Op Code $02
.byte   >(ClearOAMRAM - 1)          ; Op Code $03
    ; InputUtils.inc
.byte   >(PollJoypad1 - 1)          ; Op Code $04
.byte   >(PollJoypad2 - 1)          ; Op Code $05
    ; MemoryUtils.inc
.byte   >(LoadTileSet - 1)          ; Op Code $06
.byte   >(LoadPalette - 1)          ; Op Code $07
.byte   >(LoadTileMap - 1)          ; Op Code $08
.byte   >(UpdateOAMRAM - 1)         ; Op Code $09
;-------------------------------------------------------------------------------


; .endif  ; NEKOOPCODETABLE_INC
