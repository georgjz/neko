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
;   File: NekoLib.inc
;   Author(s): Georg Ziegler
;   Description: Include this header to access all sunbroutines of the Neko
;   Library in your project/code.
;
.ifndef NEKOLIB_INC
.define NEKOLIB_INC

;-------------------------------------------------------------------------------
;   Routines found in this file
;-------------------------------------------------------------------------------
.include    "NekoConstants.inc"         ; constants useful as aliases
.include    "NekoLibLauncher.inc"       ; the opcode launcher to call library subroutines
.include    "NekoOpcodeTable.inc"       ; the opcode table for library subroutines
.include    "NekoMacros.inc"            ; macros included in the library 
;-------------------------------------------------------------------------------

.endif  ; NEKOLIB_INC
