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
;   File: GameConstants.inc
;   Author(s): Georg Ziegler
;   Description: This file contains constants that need to be globally visible
;
.ifndef GAMECONSTANTS_INC
.define GAMECONSTANTS_INC

;-------------------------------------------------------------------------------
;   Display Area/Camera: Constants needed to calculate camera movement
;-------------------------------------------------------------------------------
ScreenHSize         = $ff       ; screen is 256 dots wide
ScreenVSize         = $e0       ; screen is 224 dots high (NTSC)
    ; if the player object enters this boundry, the camera will scroll
ScrollHBoundry      = ScreenHSize / 5
ScrollVBoundry      = ScreenVSize / 5
;-------------------------------------------------------------------------------

.endif  ; GAMECONSTANTS_INC
