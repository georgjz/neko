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
.export     BG1HOffset          ; Background 1 horizontal offset
.export     BG1VOffset          ; Background 1 vertical offset
.export     BG2HOffset          ; Background 2 horizontal offset
.export     BG2VOffset          ; Background 2 vertical offset
.export     BG3HOffset          ; Background 3 horizontal offset
.export     BG3VOffset          ; Background 3 vertical offset
.export     OAM
.export     NekoFrameCount
.export     NekoFrameOffset
;-------------------------------------------------------------------------------

.segment "WRAMPAGE"
;-------------------------------------------------------------------------------
;   Input Variables
;-------------------------------------------------------------------------------
    Joy1Raw:   .res    2        ; Buttons pressed last frame
    Joy1Trig:  .res    2        ; Buttons pressed this frame
    Joy1Held:  .res    2        ; Buttons held from last frame
    Joy2Raw:   .res    2        ; Buttons pressed last frame
    Joy2Trig:  .res    2        ; Buttons pressed this frame
    Joy2Held:  .res    2        ; Buttons held from last frame
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Screen Pointers
;-------------------------------------------------------------------------------
    BG1HOffset: .res    2       ; Background 1 horizontal offset
    BG1VOffset: .res    2       ; Background 1 vertical offset
    BG2HOffset: .res    2       ; Background 2 horizontal offset
    BG2VOffset: .res    2       ; Background 2 vertical offset
    BG3HOffset: .res    2       ; Background 3 horizontal offset
    BG3VOffset: .res    2       ; Background 3 vertical offset
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Variables
;-------------------------------------------------------------------------------
    OAM:            .res    544
    NekoFrameCount: .res    1
    NekoFrameOffset:.res    1
;-------------------------------------------------------------------------------
