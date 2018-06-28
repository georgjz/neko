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
;   File: InputUtils.inc
;   Author(s): Georg Ziegler
;   Description: This a header file for InputUtils.s, include this
;   to use the subroutines in afore mentioned file
;
.ifndef INPUTUTILS_INC
.define INPUTUTILS_INC

;-------------------------------------------------------------------------------
;   Routines found in this file
;-------------------------------------------------------------------------------
.import     PollJoypad1         ; Poll the data from Joypad 1
.import     PollJoypad2         ; Poll the data from Joypad 2
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;   Constants useful for reading joypad data
;-------------------------------------------------------------------------------
MASK_BUTTON_B       = $8000
MASK_BUTTON_Y       = $4000
MASK_BUTTON_SELECT  = $2000
MASK_BUTTON_START   = $1000
MASK_BUTTON_UP      = $0800
MASK_BUTTON_DOWN    = $0400
MASK_BUTTON_LEFT    = $0200
MASK_BUTTON_RIGHT   = $0100
MASK_BUTTON_A       = $0080
MASK_BUTTON_X       = $0040
MASK_BUTTON_L       = $0020
MASK_BUTTON_R       = $0010   
;-------------------------------------------------------------------------------

.endif  ; INPUTUTILS_INC
