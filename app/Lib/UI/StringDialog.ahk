; === Script Information =======================================================
; Name .........: String Dialog
; Description ..: Dialog for entering string data
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: StringDialog.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/13/2023)
; * Added This Banner
;
; Revision 2 (04/21/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; UI.StringDialog
class StringDialog extends UI.BaseDialog
{
    define()
    {
        this.addControl("edit")
    }
}