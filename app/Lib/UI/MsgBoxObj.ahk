; === Script Information =======================================================
; Name .........: MsgBox Obj
; Description ..: Utility class for creating MsgBoxes
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/13/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: MsgBoxObj.ahk
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
; UI.MsgBox
class MsgBoxObj extends UI.Base
{
    _output := Map()

    output
    {
        get {
            return this._output
        }
        set {
            this._output := value
            return this._output
        }
    }

    __New(prompt, title := "", options := "-SysMenu +AlwaysOnTop")
    {
        this.promptMsg := prompt
        if (title == "") {
            super.__New(prompt, options)
        } else {
            super.__New(title, options)
        }
    }

    YesEvent(ctrlObj, info)
    {
        Global
        this.Submit()
        this.output := {value: "Yes", canceled: false}
    }

    NoEvent(ctrlObj, info)
    {
        Global
        this.Destroy()
        this.output := {value: "No", canceled: false}
    }

    OkEvent(ctrlObj, info)
    {
        Global
        this.Destroy()
        this.output := {value: "OK", canceled: false}
    }

    _Setup()
    {
        Global

        this.ApplyFont()
        this.Add("Text", "w" this.width, this.promptMsg)
    }

    _Show()
    {
        Global
        if (!this.autoSize) {
            this.Show("w" this.width)
        } else {
            this.Show()
        }

        if (this.type == "OK") {
            this._CenterOkButton()
        }

        WinWaitClose(this.title)
        return this.output
    }

    _CenterOkButton()
    {
        WinGetPos(, , &guiWidth, , "ahk_id " this.hwnd)
        this.actions["OkButton"].Move((guiWidth-60)//2)
    }

    OK()
    {
        this._Setup()

        this.type := "OK"
        this.actions["OkButton"] := this.Add("Button", "w60 Default", "OK")

        this.actions["OkButton"].OnEvent("Click", ObjBindMethod(this, "OkEvent"))

        return this._Show()
    }

    YesNo()
    {
        this._Setup()

        noButtonPosFromRight := (this.width - (this.margin*2)) - 60 - 20

        YesButton := this.Add("Button", "w60 xm+10 Default", "Yes")
        NoButton := this.Add("Button", "w60 yp x" noButtonPosFromRight, "No")

        YesButton.OnEvent("Click", ObjBindMethod(this, "YesEvent"))
        NoButton.OnEvent("Click", ObjBindMethod(this, "NoEvent"))

        return this._Show()
    }
}