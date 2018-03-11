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
.include "NekoCradleInitialization.inc"
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

        jsl ClearRegisters      ; set PPU and CPU registers to standard values
        jsl ClearVRAM           ; write to complete V-RAM once
        jsl ClearCGRAM          ; write to complete CG-RAM once

        jsl InitNekoCradle      ; initalize neko cradle data
        jsl InitVariables       ; set up WRAM variables
        jsl ResetOAM

        ; make BG2 and Objects visible
        lda #$12
        sta TM
        ; release forced blanking
        lda #$0f
        sta INIDISP
        ; enable NMI, turn on automatic joypad polling
        lda #$81
        sta NMITIMEN

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
;         SetA16
;         ScrollSpeed = $02
;
;         lda Joy1Trig            ; buttons pressed this frame
;         ora Joy1Held            ; combine with buttons held from last frame
;         beq Done                ; no button pressed or held
;         tay                     ; preserve A in Y
;         ; check right button
;         and #$0100
;         beq RightDone           ; right button not pressed
;         lda BG2HScrollOffset    ; load HScrollOffset
;         clc
;         adc #ScrollSpeed        ; scroll to the right
;         sta BG2HScrollOffset
; RightDone:
;         ; check left button
;         tya                     ; restore A
;         and #$0200
;         beq LeftDone
;         lda BG2HScrollOffset
;         sec
;         sbc #ScrollSpeed        ; scroll to the left
;         sta BG2HScrollOffset
; LeftDone:
;         ; check down button
;         tya                     ; restore A
;         and #$0400
;         beq DownDone
;         lda BG2VScrollOffset
;         clc
;         adc #ScrollSpeed
;         sta BG2VScrollOffset
; DownDone:
;         ; check up button
;         tya                     ; restore A
;         and #$0800
;         beq UpDone
;         lda BG2VScrollOffset
;         sec
;         sbc #ScrollSpeed
;         sta BG2VScrollOffset
; UpDone:
; Done:   ; store new offsets
;         SetA8
;         lda BG2HScrollOffset    ; lower byte
;         sta BG2HOFS
;         lda BG2HScrollOffset+1  ; higher byte
;         sta BG2HOFS
;         lda BG2VScrollOffset
;         sta BG2VOFS
;         lda BG2VScrollOffset+1
;         sta BG2VOFS


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
