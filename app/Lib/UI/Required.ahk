; === Script Information =======================================================
; Name .........: Required UI helpers
; Description ..: Utility methods for creating required UI boxes
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Required.ahk
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
; UI.Required
class Required
{
    InputBox(prompt, title := "", throwOnFailure := true)
    {
        result := UI.InputBox(prompt, title)
        if (result.canceled)
        {
            if (throwOnFailure) {
                throw Error("ValidationException", A_ThisFunc, "You must supply an input for '" prompt "' to continue", A_LineFile, A_LineNumber)
            } else {
                MsgBox("You must supply an input to continue. Exiting...")
                ExitApp()
            }
        }
        return result.value
    }

    YesNoBox(prompt, title := "", throwOnFailure := true)
    {
        result := UI.YesNoBox(prompt, title)
        if (result.canceled)
        {
            if (throwOnFailure) {
                throw Error("ValidationException", A_ThisFunc, "You must respond yes or no to '" prompt "' to continue", A_LineFile, A_LineNumber)
            } else {
                MsgBox("You must respond yes or no to continue. Exiting...")
                ExitApp()
            }
        }
        return result.value
    }
}