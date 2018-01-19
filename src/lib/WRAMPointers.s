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
;   File: WRAMPointers.s
;   Author(s): Georg Ziegler
;   Description: This file contains address pointers placed in zero page
;   which point to symbols in WRAM. This would be part of the game's
;   custom memory map
;

;-------------------------------------------------------------------------------
;   Pointers found in this file
;-------------------------------------------------------------------------------
.export     Joy1Raw             ; Buttons pressed last frame
.export     Joy1Trig            ; Buttons pressed this frame
.export     Joy1Held            ; Buttons held from last frame
.export     Joy2Raw             ; Buttons pressed last frame
.export     Joy2Trig            ; Buttons pressed this frame
.export     Joy2Held            ; Buttons held from last frame
.export     BG2HScrollOffset
.export     BG2VScrollOffset
;-------------------------------------------------------------------------------

.segment "WRAMPAGE"
;-------------------------------------------------------------------------------
;   Input Pointers
;-------------------------------------------------------------------------------
    Joy1Raw:   .res    2        ; Buttons pressed last frame
    Joy1Trig:  .res    2        ; Buttons pressed this frame
    Joy1Held:  .res    2        ; Buttons held from last frame
    Joy2Raw:   .res    2        ; Buttons pressed last frame
    Joy2Trig:  .res    2        ; Buttons pressed this frame
    Joy2Held:  .res    2        ; Buttons held from last frame
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Variables
;-------------------------------------------------------------------------------
    BG2HScrollOffset:  .res    2
    BG2VScrollOffset:  .res    2
;-------------------------------------------------------------------------------
