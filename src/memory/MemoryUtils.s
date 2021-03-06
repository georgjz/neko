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
;   File: MemoryUtils.s
;   Author(s): Georg Ziegler
;   Description: This file contains subroutines to move data into the
;   PPUs VRAM, CG-RAM and OAM-RAM spaces
;

;-------------------------------------------------------------------------------
;   Includes
;-------------------------------------------------------------------------------
.include "SNESRegisters.inc"
.include "NekoMacros.inc"
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Assembler Directives
;-------------------------------------------------------------------------------
.p816
.i16
.a8
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Routines found in this file
;-------------------------------------------------------------------------------
.export     LoadTileSet         ; Load a tile set into VRAM
.export     LoadPalette         ; Load palette data into CG-RAM
.export     LoadTileMap         ; Load a tile map into VRAM
.export     UpdateOAMRAM        ; Update the OAM-RAM
;-------------------------------------------------------------------------------

.segment "NEKOLIB"
;-------------------------------------------------------------------------------
;   Subroutine: LoadTileSet
;   Parameters: Source: .faraddr, Destination Segment: .byte, Size: .faraddr
;   Description: Load a tile set into VRAM and place it in Destination Segment
;-------------------------------------------------------------------------------
.proc   LoadTileSet
        PreserveRegisters       ; preserve working registers
        phd                     ; preserve callers frame pointer
        tsc                     ; make own frame pointer in D
        tcd
        FrameOffset = $0b       ; set frame offset to 11: 10 bytes on stack + 1 offset
        ldx #$0000              ; X is used as argument offset

        ; set DMA source address to Source
        ldy FrameOffset, x      ; get Source address
        sty A1T0L               ; set DMA source to Source
        inx
        inx
        lda FrameOffset, x      ; get Source bank
        sta A1T0B               ; set DMA source bank to Source Bank
        lda #$18                ; set B bus destination to VMDATAL
        sta BBAD0

        ; set VRAM registers to Destination Segment
        inx                     ; get next argument
        lda FrameOffset, x      ; get Destination Segment byte
        asl                     ; move lower nibble into higher nibble
        asl
        asl
        asl
        stz VMADDL              ; set VRAM address to $n000
        sta VMADDH
        lda #$80                ; VRAM address increment to 1 word
        sta VMAINC

        ; set DMA transfer number to Size
        inx                     ; get next argument
        ldy FrameOffset, x      ; get low and middle byte of Size
        sty DAS0L
        inx
        inx
        lda FrameOffset, x
        sta DAS0B

        ; set DMA channel 0 parameters and start transfer
        lda #$01                ; 2-address(L,H) write, auto increment
        sta DMAP0
        sta MDMAEN              ; start transfer

        pld                     ; restore callers frame pointer
        RestoreRegisters        ; restore working registers
        rtl
.endproc
;----- end of subroutine LoadTileSet -------------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: LoadPalette
;   Parameters: Source: .faraddr, Destination: .byte, Size: .byte
;   Description: Load palette data into CG-RAM
;-------------------------------------------------------------------------------
.proc   LoadPalette
        PreserveRegisters       ; preserve working registers
        phd                     ; preserve caller's frame pointer
        tsc                     ; make D own frame pointer
        tcd
        FrameOffset = $0b       ; set frame offset to 11: 10 bytes on stack + 1 offset
        ldx #$0000              ; X is used as argument offset

        ; set DMA channel 0 source address to Source
        ldy FrameOffset, x      ; get middle and low byte of Source
        sty A1T0L               ; set DMA A-Bus address to Source
        inx
        inx
        lda FrameOffset, x      ; get bank of Source
        sta A1T0B               ; set DMA A-Bus address to Source

        ; set CG-RAM registers
        inx                     ; get next argument
        lda FrameOffset, x
        ; asl                     ; multiply by 2
        sta CGADD               ; set CG address to Destination
        lda #$22                ; set DMA B-Bus address to CGDATA
        sta BBAD0

        ; set DMA transfer number
        inx                     ; get next argument
        lda FrameOffset, x
        sta DAS0L
        stz DAS0H
        stz DAS0B

        ; set DMA channel 0 parameters, start transfer
        lda #$02                ; 1-address written twice, auto increment
        sta DMAP0
        lda #$01                ; start transfer
        sta MDMAEN

        pld                     ; restore callers frame pointer
        RestoreRegisters        ; restore working registers
        rtl
.endproc
;----- end of subroutine LoadPalette -------------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: LoadTileMap
;   Parameters: Source: .faraddr, Destination Segment: .byte, Size: .word
;   Description: Load a tile map into VRAM and plac it in Destination Segment
;-------------------------------------------------------------------------------
.proc   LoadTileMap
        PreserveRegisters       ; preserve working registers
        phd                     ; preserve callers frame pointer
        tsc                     ; make own frame pointer in D
        tcd
        FrameOffset = $0b       ; set frame offset to 11: 10 bytes on stack + 1 offset
        ldx #$0000              ; X is used as argument offset

        ; set DMA source address to Source
        ldy FrameOffset, x      ; get Source address
        sty A1T0L               ; set DMA source to Source
        inx
        inx
        lda FrameOffset, x      ; get Source bank
        sta A1T0B               ; set DMA source bank to Source Bank
        lda #$18                ; set B bus destination to VMDATAL
        sta BBAD0

        ; set VRAM registers to Destination Segment
        inx                     ; get next argument
        lda FrameOffset, x      ; get Destination Segment byte
        asl                     ; move lower nibble into higher nibble
        asl
        stz VMADDL              ; set VRAM address to $nn00
        sta VMADDH
        lda #$80                ; VRAM address increment to 1 word
        sta VMAINC

        ; set DMA transfer number to Size
        inx                     ; get next argument
        ldy FrameOffset, x      ; get low and middle byte of Size
        sty DAS0L
        inx
        inx
        lda FrameOffset, x
        sta DAS0B

        ; set DMA channel 0 parameters and start transfer
        lda #$01                ; 2-address(L,H) write, auto increment
        sta DMAP0
        sta MDMAEN              ; start transfer

        pld                     ; restore callers frame pointer
        RestoreRegisters        ; restore working registers
        rtl
.endproc
;----- end of subroutine LoadTileMap -------------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: UpdateOAMRAM
;   Parameters: Source: .faraddr
;   Description: Load data into OAM-RAM
;-------------------------------------------------------------------------------
.proc   UpdateOAMRAM
        PreserveRegisters       ; preserve working registers
        phd                     ; preserve callers frame pointer
        tsc                     ; create own frame pointer
        tcd
        FrameOffset = $0b       ; set frame offset to 11: 10 bytes on stack + 1 offset
        ldx #$00

        ; set source address
        ldy FrameOffset, x      ; get source address middle and low byte
        sty A1T0L
        inx
        inx
        lda FrameOffset, x      ; get source address bank
        sta A1T0B

        ; set OAM-RAM registers
        stz OAMADDL             ; start reseting OAM address...
        stz OAMADDH             ; ...to $00
        lda #$04                ; set DMA destination to $2104
        sta BBAD0

        ; set transfer size
        ldy #$0220              ; set transfer size to $0220
        sty DAS0L               ; set DMA transfer size
        stz DAS0B

        ; set DMA channel 0 parameters and start transfer
        lda #$02                ; 1-address write twice, auto increment
        sta DMAP0
        lda #$01                ; start transfer
        sta MDMAEN

        pld                     ; restore caller's frame pointer
        RestoreRegisters        ; restore working registers
        rtl
.endproc
;----- end of subroutine UpdateOAMRAM ------------------------------------------
