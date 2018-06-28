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
;   File: InputUtils.s
;   Author(s): Georg Ziegler
;   Description: This file contains subroutines to handle input
;

;-------------------------------------------------------------------------------
;   Includes
;-------------------------------------------------------------------------------
.include "SNESRegisters.inc"
.include "NekoMacros.inc"
.include "WRAMPointers.inc"
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
.export     PollJoypad1         ; Poll the data from Joypad 1
.export     PollJoypad2         ; Poll the data from Joypad 2
;-------------------------------------------------------------------------------

.segment "NEKOLIB"
;-------------------------------------------------------------------------------
;   Subroutine: PollJoypad1
;   Parameters: .far Joy1Raw
;   Description: Poll data from Joypad 1 and update pointers. This subroutine
;   will store the raw input data at the passed pointer and the triggered and
;   held data in the following two words.
;-------------------------------------------------------------------------------
.proc   PollJoypad1
        PreserveRegisters       ; preserve working registers
        phd                     ; preserver caller's frame pointer
        tsc                     ; make own frame pointer
        tcd
        FrameOffset = $0b       ; frame offset is 11: 10 on stack + 1 stack offset
        Joy1Pointer = FrameOffset
        lda Joy1Pointer + $02, S ; get the data bank address
        pha                     ; set data bank register...
        plb                     ; ...to bank of joy1raw pointer

        ; wait for reading Joypads done
Wait1:  lda HVBJOY              ; get read/write status
        and #$01                ; check bit 0
        bne Wait1               ; if bit 0 is set, wait

        ; A - joypad data
        ; X - auxiliar
        ; Y - pointer offset
        SetA16                  ; set A to 16-bit
        ldy #$00                ; set pointer offset to zero
        lda (Joy1Pointer, S), Y ; get last frame
        tax                     ; store last frame in X
        ; ldy Joy1Raw             ; get last frame
        lda JOY1L               ; get new frame
        sta (Joy1Pointer, S), Y ; save new frame
        txa
        eor (Joy1Pointer, S), Y ; check wether the button was pressed before...
        and (Joy1Pointer, S), Y ; ...or not
        ldy #$02
        sta (Joy1Pointer, S), Y ; store newly pressed buttons
        txa                     ; transfer last frame to A
        ldy #$00
        and (Joy1Pointer, S), Y ; button was pressed last and this frame
        ldy #$04
        sta (Joy1Pointer, S), Y ; there was held from last frame
        SetA8                   ; set A back to 8-bit

        pld                     ; restore caller's frame pointer
        RestoreRegisters        ; restore working registers
        rtl
.endproc
;----- end of subroutine PollJoyPad1 -------------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: PollJoypad2
;   Parameters: .far Joy2Raw
;   Description: Poll data from Joypad 2 and update pointers. This subroutine
;   will store the raw input data at the passed pointer and the triggered and
;   held data in the following two words.
;-------------------------------------------------------------------------------
.proc   PollJoypad2
        PreserveRegisters       ; preserve working registers
        phd                     ; preserve caller's frame pointer
        tsc                     ; make own frame pointer
        tcd
        FrameOffset = $0b       ; frame offset is 11: 10 on stack + 1 stack offset
        Joy2Pointer = FrameOffset
        lda Joy2Pointer + $02, S ; get bank address
        pha                     ; set bank address register...
        plb                     ; ...to bank of joy2raw pointer

        ; wait for reading Joypads done
Wait1:  lda HVBJOY              ; get read/write status
        and #$01                ; check bit 0
        bne Wait1               ; if bit 0 is set, wait

        ; A - joypad data
        ; X - auxiliar
        ; Y - pointer offset
        SetA16                  ; set A to 16-bit
        ldy #$00                ; set pointer offset to zero
        lda (Joy2Pointer, S), Y ; get last frame
        tax                     ; store last frame in X
        ; ldy Joy1Raw             ; get last frame
        lda JOY2L               ; get new frame
        sta (Joy2Pointer, S), Y ; save new frame
        txa
        eor (Joy2Pointer, S), Y ; check wether the button was pressed before...
        and (Joy2Pointer, S), Y ; ...or not
        ldy #$02
        sta (Joy2Pointer, S), Y ; store newly pressed buttons
        txa                     ; transfer last frame to A
        ldy #$00
        and (Joy2Pointer, S), Y ; button was pressed last and this frame
        ldy #$04
        sta (Joy2Pointer, S), Y ; there was held from last frame
        SetA8                   ; set A back to 8-bit

        pld                     ; restore caller's frame pointer
        RestoreRegisters        ; restore working registers
        rtl
.endproc
;----- end of subroutine PollJoyPad2 -------------------------------------------
