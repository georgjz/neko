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

;----- Includes ----------------------------------------------------------------
.include "MemoryUtils.inc"
.include "InputUtils.inc"
.include "SNESRegisters.inc"
.include "SNESInitialization.inc"
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
        stz NMITIMEN            ; disable NMI
        jsl ClearRegisters
        jsl ClearVRAM
        jsl ClearCGRAM
        jsl ClearOAMRAM

        ; Load Chess Tile Set
        tsx                     ; save stack pointer
        lda #$00                ; size bank
        pha
        pea $2000               ; size
        lda #$01                ; word destination segment << 4
        pha
        lda #^ChessTileSet      ; bank source
        pha
        lda #>ChessTileSet      ; middle source
        pha
        lda #<ChessTileSet      ; low source
        pha
        jsl LoadTileSet
        txs                     ; restore stack pointer to pre-call value
        ; Chess Tile Set loaded

        ; load palette
        tsx                     ; save stack pointer
        ldy #$0c                ; size: 12 bytes
        phy
        lda #$00                ; destination: $00
        pha
        lda #^ChessPalette      ; source: ChessPalette
        pha
        lda #>ChessPalette
        pha
        lda #<ChessPalette
        pha
        jsl LoadPalette
        txs                     ; restore stack pointer
        ; palette loaded

        ; load tile map into VRAM
        tsx                     ; save stack pointer
        lda #$00                ; size: $00:0800
        pha
        pea $0800
        pha                     ; word destination segment << 2
        lda #^ChessTileMap      ; source address
        pha
        lda #>ChessTileMap
        pha
        lda #<ChessTileMap
        pha
        jsl LoadTileMap
        txs                     ; restore stack pointer

        ; initialize variables
        ldx #$00
        stx BG2HScrollOffset
        stx BG2VScrollOffset

        ; set to BG Mode 1, BG2 tile size to 16 x 16
        lda #$21
        sta BGMODE
        ; set BG2 base address to $1000-word
        lda #$10                ; set BG2 Base Address
        sta BG12NBA
        ; set BG2 sc address to VRAM address
        lda #$00
        sta BG2SC
        ; make BG2 visible
        lda #$02
        sta TM
        ; enable NMI, turn on automatic joypad polling
        lda #$81
        sta NMITIMEN
        ; release forced blanking
        lda #$0f
        sta INIDISP

        nop                     ; break point for debugger

        jml GameLoop
.endproc
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   After the ResetHandler will jump to here
;-------------------------------------------------------------------------------
.proc   GameLoop
        wai                     ; wait for NMI / V-Blank

        ; react to Input: scroll screen
        SetA16
        ScrollSpeed = $02

        lda Joy1Trig            ; buttons pressed this frame
        ora Joy1Held            ; combine with buttons held from last frame
        beq Done                ; no button pressed or held
        tay                     ; preserve A in Y
        ; check right button
        and #$0100
        beq RightDone           ; right button not pressed
        lda BG2HScrollOffset    ; load HScrollOffset
        clc
        adc #ScrollSpeed        ; scroll to the right
        sta BG2HScrollOffset
RightDone:
        ; check left button
        tya                     ; restore A
        and #$0200
        beq LeftDone
        lda BG2HScrollOffset
        sec
        sbc #ScrollSpeed        ; scroll to the left
        sta BG2HScrollOffset
LeftDone:
        ; check down button
        tya                     ; restore A
        and #$0400
        beq DownDone
        lda BG2VScrollOffset
        clc
        adc #ScrollSpeed
        sta BG2VScrollOffset
DownDone:
        ; check up button
        tya                     ; restore A
        and #$0800
        beq UpDone
        lda BG2VScrollOffset
        sec
        sbc #ScrollSpeed
        sta BG2VScrollOffset
UpDone:
Done:   ; store new offsets
        SetA8
        lda BG2HScrollOffset    ; lower byte
        sta BG2HOFS
        lda BG2HScrollOffset+1  ; higher byte
        sta BG2HOFS
        lda BG2VScrollOffset
        sta BG2VOFS
        lda BG2VScrollOffset+1
        sta BG2VOFS


        jmp GameLoop
.endproc
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Will be called during V-Blank
;-------------------------------------------------------------------------------
.proc   NMIHandler
        lda RDNMI                   ; read NMI status, aknowledge NMI

        ; read input
        jsl PollJoypad1

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
