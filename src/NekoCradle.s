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
;

.include "MemoryUtils.inc"
.include "SNESRegisters.inc"
.include "SNESInitialization.inc"
.include "CPUMacros.inc"
; ca65 Assembler Directives
.p816
.i16
.a8

;-------------------------------------------------------------------------------
;   Exports of subroutines for use in other files
;-------------------------------------------------------------------------------
.export     ResetHandler
.export     NMIHandler
.export     IRQHandler
;-------------------------------------------------------------------------------

.segment "CODE"
;-------------------------------------------------------------------------------
;   This is the entry point of the cradle
;-------------------------------------------------------------------------------
.proc   ResetHandler
        sei                     ; disable interrupts
        clc                     ; set to native mode
        xce
        SetXY16
        SetA8
        ldx #$1fff              ; set up stack
        txs
        lda #$8f                ; force v-blanking
        sta INIDISP
        jsl ClearRegisters
        jsl ClearVRAM
        jsl ClearCGRAM
        jsl ClearOAMRAM

        ; test LoadTileSet
ChessTileSet := $018000
        lda #$00                ; size bank
        pha
        pea $2000               ; size
        lda #$01                ; destination
        pha
        lda #^ChessTileSet      ; bank source
        pha
        lda #>ChessTileSet      ; middle source
        pha
        lda #<ChessTileSet      ; low source
        pha
        jsl LoadTileSet

        nop                     ; break point for debugger

        jml GameLoop
.endproc
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   After the ResetHandler will jump to here
;-------------------------------------------------------------------------------
.proc   GameLoop
        wai
        jmp GameLoop
.endproc
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Will be called during V-Blank
;-------------------------------------------------------------------------------
.proc   NMIHandler
        lda RDNMI                   ; read NMI status
        rti
.endproc
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Is not used in this program
;-------------------------------------------------------------------------------
.proc   IRQHandler
        ; code
        rti
.endproc
;-------------------------------------------------------------------------------

; Graphics!
.segment "TILEDATA"
; ChessTileSet:
.incbin "tiledata/ChessTileSet.bin"
