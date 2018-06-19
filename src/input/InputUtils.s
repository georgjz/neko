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
;   Parameters: -
;   Description: Poll data from Joypad 1 and update pointers
;-------------------------------------------------------------------------------
.proc   PollJoypad1
        PreserveRegisters       ; preserve working registers

        ; wait for reading Joypads done
Wait1:  lda HVBJOY              ; get read/write status
        and #$01                ; check bit 0
        bne Wait1               ; if bit 0 is set, wait

        SetA16                  ; set A to 16-bit
        ldy Joy1Raw             ; get last frame
        lda JOY1L               ; get new frame
        sta Joy1Raw             ; save new frame
        tya
        eor Joy1Raw             ; check wether the button was pressed before...
        and Joy1Raw             ; ...or not
        sta Joy1Trig            ; store newly pressed buttons
        tya                     ; transfer last frame to A
        and Joy1Raw             ; button was pressed last and this frame
        sta Joy1Held            ; there was held from last frame
        SetA8                   ; set A back to 8-bit

        RestoreRegisters        ; restore working registers
        rtl
.endproc
;----- end of subroutine PollJoyPad1 -------------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: PollJoypad2
;   Parameters: -
;   Description: Poll data from Joypad 2 and update pointers
;-------------------------------------------------------------------------------
.proc   PollJoypad2
        PreserveRegisters       ; preserve working registers

        ; wait for reading Joypads done
Wait1:  lda HVBJOY              ; get read/write status
        and #$01                ; check bit 0
        bne Wait1               ; if bit 0 is set, wait

        SetA16                  ; set A to 16-bit
        ldy Joy2Raw             ; get last frame
        lda JOY2L               ; get new frame
        sta Joy2Raw             ; save new frame
        tya
        eor Joy2Raw             ; check wether the button was pressed before...
        and Joy2Raw             ; ...or not
        sta Joy2Trig            ; store newly pressed buttons
        tya                     ; transfer last frame to A
        and Joy2Raw             ; button was pressed last and this frame
        sta Joy2Held            ; there was held from last frame
        SetA8                   ; set A back to 8-bit

        RestoreRegisters        ; restore working registers
        rtl
.endproc
;----- end of subroutine PollJoyPad2 -------------------------------------------
