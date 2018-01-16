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

.include "SNESRegisters.inc"
.include "SNESInitialization.inc"
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
.proc   ResetHandler
; diable Interrupts
; set to native mode
; set A to 8 bit
; set up Stack
; force blanking

        clc                         ; set to native mode
        xce
        jml GameLoop
.endproc

GameLoop:
        wai
        jmp GameLoop

.proc   NMIHanler
        lda RDNMI                   ; read NMI status
        rti
.endproc

.proc   IRQHandler
        ; code
        rti
.endproc
