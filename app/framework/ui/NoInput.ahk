; ==== Script Information ======================================================
; Name .........: Views.NoInput
; Description ..: A gui window telling the user not to touch mouse or keyboard
; AHK Version ..: 2.* (Unicode 64-bit)
; Start Date ...: 08/07/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: NoInput.ahk
; ==============================================================================

; ==== Revision History ========================================================
; Revision 1 (08/07/2023)
; * Added This Banner
;
; ==== TO-DOs ==================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Views.NoInput
class NoInput extends UI.Base
{
    build()
    {
        this.SetFont("S20")
        this.MarginX := 10
        this.MarginY := 10
        this.add("Text", "cRed w350 Center", "!!! Automation in Progress !!!")
        this.SetFont("S15")
        this.add("Text", "cBlack w350 Center", "Do not touch the keyboard or mouse")

        super.build()
    }
}