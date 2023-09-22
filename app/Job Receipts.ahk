; ==== Script Information ======================================================
; Name .........: Job Receipts
; Description ..: Job Receipts Module
; AHK Version ..: 2.0.2 (Unicode 64-bit)
; Start Date ...: 08/05/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Job Receipts.ahk
; ==============================================================================

; ==== Revision History ========================================================
; Revision 1 (08/05/2023)
; * Added This Banner
;
; ==== TO-DOs ==================================================================
; ==============================================================================
#Include framework/bootstrap/autoload.ahk
#Include framework/Views/NoInput.ahk
#Include framework/Views/ReceiptQuantityDialog.ahk
#Include <v2/DBA>

UI.Base.defaultFont := Map("options", "S12", "fontName", "Segoe UI")

SetControlDelay(100)
SetKeyDelay(50)

jobNumber := GetJobNumber()

quantities := GetQuantities()


AssertDbaExists()

AssertJobReceiptsNotAlreadyOpen()

noInputGui := NoInput("Automation in Progress", "AlwaysOnTop ToolWindow")
noInputGui.Show()

Sleep 300

ActivateDba()

OpenJobReceiptsWindow()

EnterJobNumber(jobNumber)

EnterQuantitiesAndLocations(quantities)

noInputgui.Destroy()

result := MsgBox("Receive on another job?", unset, "YesNo Icon? 0x40000")

if (result == "Yes") {
    Reload
}

ExitApp


; --- Function Definitions -----------------------------------------------------

GetJobNumber()
{
    database := IniRead("../settings.ini", "firebird", "Database")


    valid := false
    while (!valid) {
        stringDialog := UI.StringDialog("Job Number")
        stringDialog.setFont("S12")

        result := stringDialog.prompt("Enter the Job #")

        if (result.canceled) {
            ExitApp
        }

        jobNumber := result.value

        DB := DBA.DbConnection(Map("database", database))
        results := DB.query("SELECT jobno, jobstats FROM jobs WHERE jobno='" jobNumber "'")
        if (results.count() != 1) {
            MsgBox("The Job # you entered (" jobNumber ") is not valid, please enter another.", "Job # Error", "Icon!")
            continue
        }

        result := results.row(1)
        if (result["JOBSTATS"] != 'RELEASED') {
            MsgBox("The Job # you entered (" jobNumber ") has status " results[1]["jobstats"] ", but status must be RELEASED.`nPlease release the job or try another Job #.", "Job # Error", "Icon!")
            continue
        }
        valid := true
    }

    return jobNumber
}

GetQuantities()
{
    quantities := ReceiptQuantityDialog("Job Quantities")
    results := quantities.prompt(0, 10000)

    if (results.canceled) {
        ExitApp
    }

    quantities := Map()
    quantities["good"] := results.values["quantityGood"]
    quantities["scrap"] := results.values["quantityScrap"]
    return quantities
}

AssertDbaExists()
{
    if (!WinExist(DBA.Windows.WIN_MAIN)) {
        throw Error("WindowException", A_ThisFunc, "The main DBA Manufacturing window does not exist.")
    }
}

ActivateDba()
{
    WinActivate(DBA.Windows.WIN_MAIN)
}

AssertJobReceiptsNotAlreadyOpen() {
    while (WinExist(DBA.Windows.WIN_JOB_RECEIPTS)) {
        MsgBox("The 'Job Receipts' window is already open. Please make sure your work is saved and close the 'Job Receipts' window, then click 'Ok' to continue.", "Job Receipts", "Iconi " ALWAYS_ON_TOP := 0x40000)
    }
}

OpenJobReceiptsWindow()
{
    DBA.Windows.MenuOpen("Jobs.Job Receipts")
    if (!WinWaitActive(DBA.Windows.WIN_JOB_RECEIPTS, , 5)) {
        throw Error("WindowException", A_ThisFunc, "The 'Job Receipts' window never became active.")
    }
}

EnterJobNumber(jobNumber)
{
    posX := posY := width := height := 0
    ControlGetPos(&posX, &posY, &width, &height, "TdxDBButtonEdit1", DBA.Windows.WIN_JOB_RECEIPTS)
    yClick := Integer(posY + height / 2)
    xClick := posX + width - 15
    BlockInput("MouseMove")
    MouseMove(xClick, yClick)
    MouseClick
    BlockInput("MouseMoveOff")
    hwnd := WinWaitActive("ahk_class TfrmDropDownSubFrm")
    WinExist(hwnd)
    ControlSend(jobNumber)
    ControlSend("{Enter}")
}

EnterQuantitiesAndLocations(quantities)
{
    hwnd := WinExist(DBA.Windows.WIN_JOB_RECEIPTS)
    while (!ControlExist("TdxDBGrid1", hwnd)) {
    }
    ControlFocus("TdxDBGrid1")
    ControlSend(quantities["good"], "TdxDBGrid1")
    ControlSend("{Down}", "TdxDBGrid1")
    ControlSend(quantities["scrap"], "TdxDBGrid1")
    ControlSend("{Tab}", "TdxDBGrid1")
    ControlSend("NCMR-", "TdxDBGrid1")
    ControlSend("{Enter}", "TdxDBGrid1")
    ControlSend("{Alt Down}u{Alt Up}")

    WinClose(DBA.Windows.WIN_JOB_RECEIPTS)
    
    count := 0
    while (WinWait("Warning", unset, 1)) {
        WinActivate()
        Send("u")
        WinExist(DBA.Windows.WIN_JOB_RECEIPTS)
        ControlSend("{Alt Down}u{Alt Up}")
        count++
        if (count >= 5) {
            Break
        }
    }

    if (!WinWaitClose(DBA.Windows.WIN_JOB_RECEIPTS, unset, 5)) {
        MsgBox("There was an issue closing the 'Job Receipts' window. Please check that the transaction was saved and close the window manually.", "Job Receipts", "Icon!")
    }
}

ControlExist(Control, WinTitle := "", WinText := "", ExcludeTitle := "", ExcludeText := "") {
    try {
        return ControlGetHwnd(Control, WinTitle, WinText, ExcludeTitle, ExcludeText)
    } catch {
        return false
    }
}