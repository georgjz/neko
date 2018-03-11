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
;   File: NekoCradleeInitialization.s
;   Author(s): Georg Ziegler
;   Description: This file contains subroutines to initialize the basic cradle
;   data and variables.
;

;----- Includes ----------------------------------------------------------------
.include "MemoryUtils.inc"
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
.export     InitNekoCradle      ; Load basic tile sets and map
.export     InitVariables       ; Initialize the variables in WRAM
.export     ResetOAM            ; Resets the OAM to $ff
;-------------------------------------------------------------------------------

.segment "CODE"
;-------------------------------------------------------------------------------
;   Subroutine: InitNekoCradle
;   Parameters: -
;   Description: Load tile sets and maps, and sprite sheet into V-RAM
;-------------------------------------------------------------------------------
.proc   InitNekoCradle
        PreserveRegisters       ; preserve working registers

        ; load Chess Tile Set
        tsx                     ; save stack pointer
        lda #$00                ; size bank
        pha
        pea $2000               ; size
        lda #$01                ; word destination segment << 4
        pha
        lda #^ChessTileSet      ; bank source
        pha
        lda #>ChessTileSet      ; bank source
        pha
        lda #<ChessTileSet      ; bank source
        pha
        jsl LoadTileSet
        txs                     ; restore stack pointer
        ; Chess Tile Set loaded

        ; load chess palette
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
        ; chess palette loaded

        ; load tile map into VRAM
        tsx                     ; save stack pointer
        lda #$00                ; size $00:0800
        pha
        pea $0800
        pha                     ; word destination segment << 2
        lda #^ChessTileMap     ; source address
        pha
        lda #>ChessTileMap
        pha
        lda #<ChessTileMap
        pha
        jsl LoadTileMap
        txs                     ; restore stack pointer

        ; load neko sprite sheet
        tsx                     ; save stack pointer
        lda #$00                ; size $00:4000
        pha
        pea $4000
        lda #$02                ; destination segment $4000
        pha
        lda #^NekoSpriteSheet
        pha
        lda #>NekoSpriteSheet
        pha
        lda #<NekoSpriteSheet
        pha
        jsl LoadTileSet
        txs                     ; restore stack pointer

        ; load Neko Palette
        tsx                     ; save stack pointer
        ldy #$20                ; size: 32 bytes
        phy
        lda #$80                ; destination: $80
        pha
        lda #^NekoPalette
        pha
        lda #>NekoPalette
        pha
        lda #<NekoPalette
        pha
        jsl LoadPalette
        txs                     ; restore stack pointer

        ; set background options
        lda #$21                ; set to BG Mode 1, BG2 tile size to 16 x 16
        sta BGMODE
        lda #$10                ; set BG2 base address
        sta BG12NBA
        lda #$00                ; set BG2 SC address to VRAM address $0000
        sta BG2SC

        ; set object options
        lda #$21                ; set OAM Address to $4000
        sta OBJSEL

        RestoreRegisters        ; restore working registers
        rtl
.endproc
;----- end of subroutine InitNekoCradle ----------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: InitVariables
;   Parameters: -
;   Description: Initialize variables in WRAM
;-------------------------------------------------------------------------------
.proc   InitVariables
        PreserveRegisters       ; preserve working registers

        ; set neko start position
        ldx #$0000
        lda #$40
        sta OAM, x              ; HPos
        inx
        sta OAM, x              ; VPos
        inx
        lda #$08                ; Name/Sprite
        sta OAM, x
        inx
        lda #$20                ; attribute
        sta OAM, x              ; no flip, priority 2, palette 0

        ; set sprite size
        ldx #$0200
        lda #$fa                ; size large for objects 0 and 1
        sta OAM, x

        ; set frame counter and offset
        lda #$00
        sta NekoFrameCount
        sta NekoFrameOffset

        ; initialize background offsets
        stz BG1HOffset
        stz BG1VOffset
        stz BG2HOffset
        stz BG2VOffset
        stz BG3HOffset
        stz BG3VOffset

        RestoreRegisters        ; restore working registers
        rtl
.endproc
;----- end of subroutine InitVariables -----------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: ResetOAM
;   Parameters: -
;   Description: Reset OAM to $ff
;-------------------------------------------------------------------------------
.proc   ResetOAM
        PreserveRegisters       ; preserve working registers

        ldx #$0000
        lda #$ff
loop:   sta OAM, x
        inx
        cpx #$0221
        bne loop

        RestoreRegisters        ; restore working registers
        rtl
.endproc
;----- end of subroutine ClearRegisters ----------------------------------------
