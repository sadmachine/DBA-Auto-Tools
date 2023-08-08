; === Script Information =======================================================
; Name .........: InputBox Obj
; Description ..: Utility class for creating InputBoxes
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: InputBoxObj.ahk
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
; UI.InputBox
class InputBoxObj extends UI.Base
{
    output := Map()
    __instance := true

    __New(prompt, title := "", options := "-SysMenu +AlwaysOnTop")
    {
        this.promptMsg := prompt
        if (this.title == "")
        {
            return super.__New(prompt, options)
        }
        else
        {
            return super.__New(title, options)
        }
    }

    SubmitEvent()
    {
        Global
        this.Submit()
        this.output := {value: this.editBox.Text, canceled: false}
    }

    CancelEvent()
    {
        Global
        this.Destroy()
        this.output := {value: "", canceled: true}
    }

    prompt()
    {
        Global
        this.ApplyFont()
        this.Add("Text", "r1", this.promptMsg)
        this.editBox := this.Add("Edit", "r1 w" this.width - (this.margin*2) - 10)
        cancelButtonPosFromRight := this.width - 60 - 10 - this.margin
        SubmitButton := this.Add("Button", "w60 xm+10 Default", "OK")
        CancelButton := this.Add("Button", "w60 yp x" cancelButtonPosFromRight, "Cancel")

        SubmitButton.OnEvent("Click", ObjBindMethod(this, "SubmitEvent"))
        CancelButton.OnEvent("Click", ObjBindMethod(this, "CancelEvent"))

        this.Show("w" this.width + (this.margin*2))

        WinWaitClose(this.title)
        return this.output
    }
}