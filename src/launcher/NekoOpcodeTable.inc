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
;   File: NekoOpcodeTable.inc
;   Author(s): Georg Ziegler
;   Description: This a header contains the RTS return table for the Neko Library.
;   This table is used by OpcodeLauncher.s
;
.ifndef NEKOOPCODETABLE_INC
NEKOOPCODETABLE_INC = 1

;-------------------------------------------------------------------------------
;   Routines found in this file
;-------------------------------------------------------------------------------
.import     NekoLibRTSTableL
.import     NekoLibRTSTableH
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Opcode Table
;-------------------------------------------------------------------------------
    ; SNESInitialization.inc
ClearRegistersOpcode        = $00
ClearVRAMOpcode             = $01
ClearCGRAMOpcode            = $02
ClearOAMRAMOpcode           = $03
    ; InputUtils.inc
PollJoypad1Opcode           = $04
PollJoypad2Opcode           = $05
    ; MemoryUtils.inc
LoadTileSetOpcode           = $06
LoadPaletteOpcode           = $07
LoadTileMapOpcode           = $08
UpdateOAMRAMOpcode          = $09
;-------------------------------------------------------------------------------

.endif  ; NEKOOPCODETABLE_INC
