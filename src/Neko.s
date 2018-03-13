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
;   File: Neko.s
;   Author(s): Georg Ziegler
;   Description: This file contains subroutines to control the cat/neko
;   character that moves around the map
;

;----- Includes ----------------------------------------------------------------
.include "SNESRegisters.inc"
.include "CPUMacros.inc"
.include "WRAMPointers.inc"
.include "TileData.inc"
.include "GameConstants.inc"
;-------------------------------------------------------------------------------

;----- Assembler Directives ----------------------------------------------------
.p816
.i16
.a8
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Routines found in this file
;-------------------------------------------------------------------------------
.export     UpdateNeko          ; The main subroutine that will take care of Neko
;-------------------------------------------------------------------------------

.segment "CODE"
;-------------------------------------------------------------------------------
;   Reserve RO memory
;-------------------------------------------------------------------------------
NekoWalkNorth:
    .byte   $84, $80, $88, $80
NekoWalkSouth:
    .byte   $04, $00, $08, $00
NekoWalkWest:
NekoWalkEast:
    .byte   $44, $40, $48, $40
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Constants used in this file
;-------------------------------------------------------------------------------
    ; Neko constants
NekoFrameHoldLength = $08       ; number of frames an animation should be held
NekoWalkSpeed       = $01
NekoHPos            = OAM + $00
NekoVPos            = OAM + $01
NekoSpriteName      = OAM + $02
NekoAttrib          = OAM + $03
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: UpdateNeko
;   Parameters: -
;   Description: Will react to input and other events for Neko
;-------------------------------------------------------------------------------
.proc   UpdateNeko
        PreserveRegisters       ; preserve working registers

        ; check if buttons were pressed or held
        SetA16                  ; set A to 16 bit
        lda Joy1Trig            ; load buttons pressed in last frame...
        ora Joy1Held            ; ...and combine with buttons held
        beq StandStill          ; if no button pressed or held, stand still

        ; check animation frame count
        lda #$0000              ; reset A
        SetA8                   ; set A to 8 bit
        lda NekoFrameCount      ; get current frame count...
        ina                     ; ...and increment
        cmp #$20                ; have more than 32 frames passed?
        bcc NoFrameReset        ; if not, just store new frame count...
        lda #$00                ; ...else reset frame count
NoFrameReset:
        sta NekoFrameCount      ; store incremented frame count

        ; use frame count to calculate which animation frame to load/display,
        ; which is simply NekoFrameCount / NekoFrameHoldLength
        sta NekoFrameOffset     ; frame count still in A, use as numerator
        lda #$00                ; A will hold remainder
        ldx #$08                ; loop counter for 8 bit integer division
        asl NekoFrameOffset
Div1:   rol
        cmp #NekoFrameHoldLength ; denominator
        bcc Div2
        sbc #NekoFrameHoldLength
Div2:   rol NekoFrameOffset
        dex                      ; decrease loop counter
        bne Div1
        ; NekoFrameOffset now hold quotient NekoFrameCount / NekoFrameHoldLength

        ; call Joypad Handler
        lda #NekoJoypadHandlerOpCode ; load op code
        jsr NekoOpCodeLauncher  ; execute op code subroutine
        ; NekoJoypadHandler will return to here
        jmp Done                ;

StandStill:
        SetAXY8
        stz NekoFrameCount      ; reset frame counter
        lda NekoSpriteName      ; load name
        and #$f0                ; clear lower nibble
        sta NekoSpriteName

Done:
        SetXY16
        SetA8

        RestoreRegisters        ; restore working registers
        rts
.endproc
;----- end of subroutine UpdateNeko --------------------------------------------


;----- Subroutines only visible to this file -----------------------------------
;-------------------------------------------------------------------------------
;   Subroutine: NekoOpCodeLauncher
;   Parameters: A : op code of subroutine to call
;   Description: This will be the launcher to call the subroutines this files
;   uses to manipulate all data concerning Solid Neko
;-------------------------------------------------------------------------------
.proc   NekoOpCodeLauncher
        ldx #$00                ; clear X
        tax                     ; transfer op code
        lda NekoRTSTableH, X    ; get high byte of subroutine address...
        pha                     ; ...and push to stack
        lda NekoRTSTableL, X    ; repeat for low byte...
        pha                     ; ...and push to stack
        rts                     ; call subroutine!
        ; once the subroutine called here is done, that subroutine will return
        ; to the caller of NekoOpCodeLauncher
.endproc
;----- end of subroutine NekoOpCodeLauncher -----------------------------------

NekoSubRoutineOpCodes:
NekoJoypadHandlerOpCode  = $00
HandleBButtonOpCode      = $01
HandleYButtonOpCode      = $02
HandleSelectButtonOpCode = $03
HandleStartButtonOpCode  = $04
HandleUpButtonOpCode     = $05
HandleDownButtonOpCode   = $06
HandleLeftButtonOpCode   = $07
HandleRightButtonOpCode  = $08
HandleAButtonOpCode      = $09
HandleXButtonOpCode      = $0a
HandleLButtonOpCode      = $0b
HandleRButtonOpCode      = $0c

    ; this will act as a return table, split into high and low byte
NekoRTSTableL:
.byte   <(NekoJoypadHandler - 1)  ; Op Code $00
.byte   <(HandleBButton - 1)      ; Op Code $01
.byte   <(HandleYButton - 1)      ; Op Code $02
.byte   <(HandleSelectButton - 1) ; Op Code $03
.byte   <(HandleStartButton - 1)  ; Op Code $04
.byte   <(HandleUpButton - 1)     ; Op Code $05
.byte   <(HandleDownButton - 1)   ; Op Code $06
.byte   <(HandleLeftButton - 1)   ; Op Code $07
.byte   <(HandleRightButton - 1)  ; Op Code $08
.byte   <(HandleAButton - 1)      ; Op Code $09
.byte   <(HandleXButton - 1)      ; Op Code $0a
.byte   <(HandleLButton - 1)      ; Op Code $0b
.byte   <(HandleRButton - 1)      ; Op Code $0c

NekoRTSTableH:
.byte   >(NekoJoypadHandler - 1)  ; Op Code $00
.byte   >(HandleBButton - 1)      ; Op Code $01
.byte   >(HandleYButton - 1)      ; Op Code $02
.byte   >(HandleSelectButton - 1) ; Op Code $03
.byte   >(HandleStartButton - 1)  ; Op Code $04
.byte   >(HandleUpButton - 1)     ; Op Code $05
.byte   >(HandleDownButton - 1)   ; Op Code $06
.byte   >(HandleLeftButton - 1)   ; Op Code $07
.byte   >(HandleRightButton - 1)  ; Op Code $08
.byte   >(HandleAButton - 1)      ; Op Code $09
.byte   >(HandleXButton - 1)      ; Op Code $0a
.byte   >(HandleLButton - 1)      ; Op Code $0b
.byte   >(HandleRButton - 1)      ; Op Code $0c
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
;   Subroutine: NekoJoypadHandler
;   Parameters:
;   Description: Handles all input
;-------------------------------------------------------------------------------
.proc   NekoJoypadHandler
        ; get input
        SetA16                  ; set A to 16 bit
        lda Joy1Trig            ; get buttons pressed during last V-Blank and...
        ora Joy1Held            ; ...combine with held buttons

        ; determine which button to react to/calculate op code
        ldx #$01                ; X will hold the op code to execute
Check:  asl                     ; move MSB into Carry bit
        bcs Done                ; pressed button found
        inx                     ; else increment X...
        jmp Check               ; ...and check next bit
Done:
        ; set op code and call subroutine
        lda #$0000              ; reset A
        SetA8                   ; set A to 8 bit
        txa                     ; set A to op code
        jsr NekoOpCodeLauncher  ; call the button handler

        rts                     ; return to NekoUpdate
.endproc
;----- end of subroutine NekoJoypadHandlers -----------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: HandleBButton
;   Parameters:
;   Description: Reacts to the B button
;-------------------------------------------------------------------------------
.proc   HandleBButton
        ; code
        rts
.endproc
;----- end of subroutine HandleBButton -----------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: HandleYButton
;   Parameters:
;   Description: Reacts to the Y button
;-------------------------------------------------------------------------------
.proc   HandleYButton
        ; code
        rts
.endproc
;----- end of subroutine HandleYButton -----------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: HandleSelectButton
;   Parameters:
;   Description: Reacts to the Select button
;-------------------------------------------------------------------------------
.proc   HandleSelectButton
        ; code
        rts
.endproc
;----- end of subroutine HandleSelectButton ------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: HandleStartButton
;   Parameters:
;   Description: Reacts to the Start button
;-------------------------------------------------------------------------------
.proc   HandleStartButton
        ; code
        rts
.endproc
;----- end of subroutine HandleStartButton -------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: HandleUpButton
;   Parameters:
;   Description: Reacts to the Up button
;-------------------------------------------------------------------------------
.proc   HandleUpButton
        ldx #$0000              ; reset X
        ldy #$0000              ; reset Y
        SetXY8                  ; set all registers to 8 bit
        ; update animation
        ldx NekoFrameOffset     ; get animation frame offset...
        lda NekoWalkNorth, X    ; ...and get actual animation frame to display
        sta NekoSpriteName      ; object name in OAMRAM
        ; update attribute
        lda #$20                ; no flip, prio 2, palette 0
        sta NekoAttrib          ; store Attribute in OAMRAM

        ; update Position
        lda NekoVPos            ; get vertical position
        sec                     ; decrease current position by walk speed...
        sbc #NekoWalkSpeed      ; ...to obtain new vertical (sprite) position
        ; check if new position lies within boundry area
        cmp #ScrollVBoundry     ; if new position lies within scroll boundry...
        bcc MoveCamera          ; ...move the camera instead

        ; move Neko sprite
        sta NekoVPos            ; store new Position
        jmp Done

        ; move camera up/towards top of screen
MoveCamera:
        lda BG2VOffset          ; get lower byte of vertical offset
        sec
        sbc #NekoWalkSpeed
        sta BG2VOffset          ; save new offset
        sta BG2VOFS             ; write new offset to PPU
        lda BG2VOffset + 1      ; get high byte of vertical offset
        sbc #$00                ; needed to get the borrow correctly
        and #$03                ; clear upper 6 bits
        sta BG2VOffset + 1      ; save new offset
        sta BG2VOFS

Done:   SetXY16                 ; set X and Y to 16 bit
        rts                     ; return to NekoJoypadHandler
.endproc
;----- end of subroutine HandleUpButton ----------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: HandleDownButton
;   Parameters:
;   Description: Reacts to the Down button
;-------------------------------------------------------------------------------
.proc   HandleDownButton
        ldx #$0000              ; reset X
        ldy #$0000              ; reset Y
        SetXY8                  ; set all registers to 8 bit
        ; update animation
        ldx NekoFrameOffset     ; get animation frame offset...
        lda NekoWalkSouth, X    ; ...and get actual animation frame to display
        sta NekoSpriteName      ; object name in OAMRAM
        ; update attribute
        lda #$20                ; no flip, prio 2, palette 0
        sta NekoAttrib          ; store Attribute in OAMRAM

        ; update Position
        lda NekoVPos            ; get vertical position
        clc                     ; decrease current position by walk speed...
        adc #NekoWalkSpeed      ; ...to obtain new vertical (sprite) position
        ; check if new position lies within boundry area
        cmp # (ScreenVSize - ScrollVBoundry - $20)     ; if new position lies within scroll boundry...
        bcs MoveCamera          ; ...move the camera instead

        ; move Neko sprite
        sta NekoVPos            ; store new Position
        jmp Done

        ; move camera down/towards bottom of screen
        MoveCamera:
        lda BG2VOffset          ; get lower byte of vertical offset
        clc
        adc #NekoWalkSpeed
        sta BG2VOffset          ; save new offset
        sta BG2VOFS             ; write new offset to PPU
        lda BG2VOffset + 1      ; get high byte of vertical offset
        adc #$00                ; needed to get the borrow correctly
        and #$03                ; clear upper 6 bits
        sta BG2VOffset + 1      ; save new offset
        sta BG2VOFS

Done:   SetXY16                 ; set X and Y to 16 bit
        rts                     ; return to NekoJoypadHandler


.endproc
;----- end of subroutine HandleDownButton --------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: HandleLeftButton
;   Parameters:
;   Description: Reacts to the Left button
;-------------------------------------------------------------------------------
.proc   HandleLeftButton
        ldx #$0000              ; reset X
        ldy #$0000              ; reset Y
        SetXY8                  ; set all registers to 8 bit
        ; update animation
        ldx NekoFrameOffset     ; get animation frame offset...
        lda NekoWalkEast, X     ; ...and get actual animation frame to display
        sta NekoSpriteName      ; object name in OAMRAM
        ; update attribute
        lda #$60                ; H-flip, prio 2, palette 0
        sta NekoAttrib          ; store Attribute in OAMRAM

        ; update Position
        lda NekoHPos            ; get horizontal position
        sec                     ; decrease current position by walk speed...
        sbc #NekoWalkSpeed      ; ...to obtain new horizontal (sprite) position
        ; check if new position lies within boundry area
        cmp #ScrollHBoundry     ; if new position lies within scroll boundry...
        bcc MoveCamera          ; ...move the camera instead

        ; move Neko sprite
        sta NekoHPos            ; store new Position
        jmp Done

        ; move camera to the left
        MoveCamera:
        lda BG2HOffset          ; get lower byte of horizontal offset
        sec
        sbc #NekoWalkSpeed
        sta BG2HOffset          ; save new offset
        sta BG2HOFS             ; write new offset to PPU
        lda BG2HOffset + 1      ; get high byte of vertical offset
        sbc #$00                ; needed to get the borrow correctly
        and #$03                ; clear upper 6 bits
        sta BG2HOffset + 1      ; save new offset
        sta BG2HOFS

Done:   SetXY16                 ; set X and Y to 16 bit
        rts                     ; return to NekoJoypadHandler
.endproc
;----- end of subroutine HandleLeftButton --------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: HandleRightButton
;   Parameters:
;   Description: Reacts to the Right button
;-------------------------------------------------------------------------------
.proc   HandleRightButton
        ldx #$0000              ; reset X
        ldy #$0000              ; reset Y
        SetXY8                  ; set all registers to 8 bit
        ; update animation
        ldx NekoFrameOffset     ; get animation frame offset...
        lda NekoWalkWest, X     ; ...and get actual animation frame to display
        sta NekoSpriteName      ; object name in OAMRAM
        ; update attribute
        lda #$20                ; no flip, prio 2, palette 0
        sta NekoAttrib          ; store Attribute in OAMRAM

        ; update Position
        lda NekoHPos            ; get horizontal position
        clc                     ; decrease current position by walk speed...
        adc #NekoWalkSpeed      ; ...to obtain new horizontal (sprite) position
        ; check if new position lies within boundry area
        cmp # (ScreenHSize - ScrollHBoundry - $20)    ; if new position lies within scroll boundry...
        bcs MoveCamera          ; ...move the camera instead

        ; move Neko sprite
        sta NekoHPos            ; store new Position
        ; sta NekoHPos + $04
        jmp Done

        ; move camera to the right
        MoveCamera:
        lda BG2HOffset          ; get lower byte of horizontal offset
        clc
        adc #NekoWalkSpeed
        sta BG2HOffset          ; save new offset
        sta BG2HOFS             ; write new offset to PPU
        lda BG2HOffset + 1      ; get high byte of vertical offset
        adc #$00                ; needed to get the borrow correctly
        and #$03                ; clear upper 6 bits
        sta BG2HOffset + 1      ; save new offset
        sta BG2HOFS

Done:   SetXY16                 ; set X and Y to 16 bit
        rts                     ; return to NekoJoypadHandler
        rts
.endproc
;----- end of subroutine HandleRightButton -------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: HandleAButton
;   Parameters:
;   Description: Reacts to the A button
;-------------------------------------------------------------------------------
.proc   HandleAButton
        ; code
        rts
.endproc
;----- end of subroutine HandleAButton -----------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: HandleXButton
;   Parameters:
;   Description: Reacts to the X button
;-------------------------------------------------------------------------------
.proc   HandleXButton
        ; code
        rts
.endproc
;----- end of subroutine HandleXButton -----------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: HandleLButton
;   Parameters:
;   Description: Reacts to the L button
;-------------------------------------------------------------------------------
.proc   HandleLButton
        ; code
        rts
.endproc
;----- end of subroutine HandleLButton -----------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: HandleRButton
;   Parameters:
;   Description: Reacts to the R button
;-------------------------------------------------------------------------------
.proc   HandleRButton
        ; code
        rts
.endproc
;----- end of subroutine HandleRButton -----------------------------------------

;-------------------------------------------------------------------------------
;   Subroutine: UpdateAnimation
;   Parameters:
;   Description:
;-------------------------------------------------------------------------------
.proc   UpdateAnimation
        ; code
        rts
.endproc
;----- end of subroutine ClearRegisters ----------------------------------------
