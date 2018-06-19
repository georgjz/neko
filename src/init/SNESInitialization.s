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
.export     ClearRegisters      ; Clear all PPU and CPU registers of the SNES
.export     ClearVRAM           ; Clear the complete VRAM to $00
.export     ClearCGRAM          ; Clear CG-RAM to $00 (black)
.export     ClearOAMRAM         ; Clear OAM-RAM to $ff (all sprites off screen)
;-------------------------------------------------------------------------------

.segment "NEKOLIB"
;-------------------------------------------------------------------------------
;   Subroutine: ClearRegisters
;   Parameters: -
;   Description: Clear all PPU and CPU registers to standard values
;-------------------------------------------------------------------------------
.proc   ClearRegisters
        PreserveRegisters       ; preserve work registers

        ; PPU registers
        ldx #$2101              ; registers $2101 through $210c
loop1:  stz $00, X
        inx
        cpx #$210d
        bne loop1

loop2:  stz $00, X              ; registers $210d through $2114, two writes
        stz $00, X
        inx
        cpx #$2115
        bne loop2

        lda #$80                ; VRAM address increment to write to VMDATAH
        sta VMAINC

        inx                     ; registers $2116 through 211a
loop3:  stz $00, X
        inx
        cpx #$211b
        bne loop3

        lda #$01                ; registers $211b through $2120
loop4:  sta $00, X
        stz $00, X
        inx
        stz $00, X
        stz $00, X
        inx
        stz $00, X
        stz $00, X
        inx
        cpx #$2121
        bne loop4

loop5:  stz $00, X              ; registers $2121 through $2133
        inx
        cpx #$2134
        bne loop5

        ; special values
        lda #$30
        sta CGSWSEL
        lda #$e0
        sta COLDATA

        ; CPU registers
        stz NMITIMEN
        lda #$ff
        sta WRIO

        ldx #$4202              ; registers $4202 through $420d
loop6:  stz $00, X
        inx
        cpx #$420e
        bne loop6

        RestoreRegisters        ; restore working registers
        rtl
.endproc
;----- end of subroutine ClearRegisters ----------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: ClearVRAM
;   Parameters: -
;   Description: Clear the complete VRAM to $00
;-------------------------------------------------------------------------------
.proc   ClearVRAM
        PreserveRegisters       ; preserve working registers

        ; set up VRAM registers
        lda #$80                ; increment after write to VMDATAH by 1 word
        sta VMAINC
        ldx #$0000              ; set VRAM address to $0000
        stx VMADDL
        ; set up DMA channel 0 for transfer
        lda #$09                ; 2-byte write and fixed address
        sta DMAP0
        lda #$18                ; set destination to $(21)18
        sta BBAD0
        stz $0000               ; store $00 in WRAM $0000
        stz A1T0L               ; set source address to $00:0000
        stz A1T0H
        stz A1T0B
        stz DAS0L               ; set number of bytes to transfer to $010000
        stz DAS0H
        lda #$01
        sta DAS0B
        sta MDMAEN              ; start transfer

        RestoreRegisters        ; restore working registers
        rtl
.endproc
;----- end of subroutine ClearVRAM ---------------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: ClearCGRAM
;   Parameters: -
;   Description: Clear the complete CG-RAM to $00
;-------------------------------------------------------------------------------
.proc   ClearCGRAM
        PreserveRegisters       ; preserve working registers

        ; set up CG-RAM registers
        stz CGADD               ; set CG-RAM address to $00
        ; write 512/$120 byte of $00 to CG-RAM by DMA channel 0
        lda #$0a                ; 2-byte write to fixed address and fixed address
        sta DMAP0
        lda #$22                ; set destination to CGDATA
        sta BBAD0
        stz $0000               ; set WRAM $00:0000 to $00
        stz A1T0L               ; set source address to $00:0000
        stz A1T0H
        stz A1T0B
        stz DAS0L               ; set number of bytes to transfer to 512/$200
        lda #$02
        sta DAS0H
        stz DAS0B
        lda #$01                ; start transfer
        sta MDMAEN

        RestoreRegisters        ; restore working registers
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
        PreserveRegisters       ; preserve working registers

        ; set up OAM-RAM registers
        stz OAMADDL             ; set OAM-RAM address to $0000
        stz OAMADDH
        ; write 544/$220 words to OAM-RAM by DMA channel 0
        lda #$0a                ; 2-byte write to fixed address and fixed address
        sta DMAP0
        lda #$04                ; set destination address to OAMDATA
        sta BBAD0
        lda #$ff                ; set WRAM $00:0000 to $ff
        sta $0000
        stz A1T0L               ; set destination address to $00:0000
        stz A1T0H
        stz A1T0B
        lda #$20                ; set number of bytes to transfer to 544/$220
        sta DAS0L
        lda #$02
        sta DAS0H
        stz DAS0B
        lda #$01                ; start transfer
        sta MDMAEN

        RestoreRegisters        ; restore working registers
        rtl
.endproc
;----- end of subroutine ClearOAMRAM -------------------------------------------
