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
;   File: NekoLibLauncher.inc
;   Author(s): Georg Ziegler
;   Description: This file contains the implementation of the Subroutine Launcher
;   of the Neko Library.
;

;-------------------------------------------------------------------------------
;   Includes
;-------------------------------------------------------------------------------
.include "NekoOpcodeTable.inc"
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
.export     NekoLibLauncher
;-------------------------------------------------------------------------------

.segment "NEKOLIB"
;-------------------------------------------------------------------------------
;   Subroutine: NekoLibLauncher
;   Parameters: A : op code of subroutine to call
;   Description: This will be the launcher to call the subroutines this files
;   uses to manipulate all data concerning Solid Neko
;-------------------------------------------------------------------------------
.proc   NekoLibLauncher
        phk                     ; set data bank register...
        plb                     ; ...to current program bank, where Neko Lib resides
        ldy #$00                ; clear Y
        xba                     ; make sure that B/upper half of A...
        and #$00                ; ...is zero...
        xba                     ; ...before transfering into Y
        tay                     ; transfer op code
        lda NekoLibRTSTableH, Y ; get high byte of subroutine address...
        pha                     ; ...and push to stack
        lda NekoLibRTSTableL, Y ; repeat for low byte...
        pha                     ; ...and push to stack
        rts                     ; call subroutine!
        ; once the subroutine called here is done, that subroutine will return
        ; to the caller of NekoLibLauncher
.endproc
;----- end of subroutine NekoLibLauncher ---------------------------------------
