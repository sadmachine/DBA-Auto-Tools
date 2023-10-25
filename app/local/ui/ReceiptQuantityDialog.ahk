; === Script Information =======================================================
; Name .........: Base Dialog
; Description ..: Base Dialog for all other dialogs to inherit from
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/09/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: BaseDialog.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/09/2023)
; * Added This Banner
; * Update to auto set control text to data.value, if it exists + no text given
;
; Revision 2 (04/21/2023)
; * Update for ahk v2
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; UI.BaseDialog
class ReceiptQuantityDialog extends UI.Base
{
    data := ""
    output := Map()
    controls := Map()

    __New(title, data := Map())
    {
        this.data := data
        options := "-SysMenu +AlwaysOnTop"

        super.__New(title, options, this)
    }

    prompt(minQ, maxQ)
    {
        Global
        this.ApplyFont()

        range := "Range" minQ "-" maxQ

        this.Add("Text", "w90 Right ym+2", "Qty Good: ")
        this.controls["quantityGood"] := this.Add("Edit", "x+0 yp-2")
        this.Add("UpDown", range, 0)

        this.Add("Text", "w90 Right xm y+10", "Qty Failed: ")
        this.controls["quantityScrap"] := this.Add("Edit", "x+0 yp-2")
        this.Add("UpDown", range, 0)

        SaveButton := this.Add("Button", "y+20 xm+5 w100 Default", "Submit")
        CancelButton := this.Add("Button", "x+65 w100", "Cancel")

        SaveButton.OnEvent("Click", "SubmitEvent")
        CancelButton.OnEvent("Click", "CancelEvent")
        this.OnEvent("Close", "CancelEvent")

        this.Show("xCenter yCenter")
        WinWaitClose(this.title)

        return this.output
    }

    SubmitEvent(guiCtrlObj, info)
    {
        this.Submit()
        resultValues := Map(
            "quantityGood", this.controls["quantityGood"].Text,
            "quantityScrap", this.controls["quantityScrap"].Text
        )
        this.output := { values: resultValues, canceled: false }
    }

    CancelEvent(guiCtrlObj, info)
    {
        this.Destroy()
        this.output := { values: "", canceled: true }
    }

    getOutput() {
        return this.output
    }
}