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
#Include bootstrap/autoload.ahk

jobNumber := GetJobNumber()

quantities := GetQuantities()

AssertDbaExists()

ActivateDba()

OpenJobReceiptsWindow()

EnterJobNumber(jobNumber)

EnterQuantitiesAndLocations(quantities)


GetJobNumber()
{
    result := InputBox("Enter the Job #", "Job Number")

    if (result.result != "OK") {
        ExitApp
    }

    return result.value
}

GetQuantities()
{
    resultGood := InputBox("Enter the Quantity Good", "Quantity Good")

    if (resultGood.result != "OK") {
        ExitApp
    }

    resultScrap := InputBox("enter the Quantity Scrap", "Quantity Scrap")

    if (resultScrap.result != "OK") {
        ExitApp
    }

    quantities := Map()
    quantities["good"] := resultGood.value
    quantities["scrap"] := resultScrap.value
    return quantities
}

AssertDbaExists()
{
    if (!WinExist(DBA.Windows.WIN_MAIN)) {
        throw Error("WindowException", A_ThisFunc, "The main DBA Manufacturing window does not exist.", A_LineFile, A_LineNumber)
    }
}

ActivateDba()
{
    WinActivate(DBA.Windows.WIN_MAIN)
}

OpenJobReceiptsWindow()
{
    while (WinExist(DBA.Windows.WIN_JOB_RECEIPTS)) {
        MsgBox("The 'Job Receipts' window is already open. Please make sure your work is saved and close the 'Job Receipts' window, then click 'Ok' to continue.", "Job Receipts", "Iconi " ALWAYS_ON_TOP := 0x40000)
    }
    DBA.Windows.MenuOpen("Jobs.Job Receipts")
    if (!WinWaitActive(DBA.Windows.WIN_JOB_RECEIPTS, , 5)) {
        throw Error("WindowException", A_ThisFunc, "The 'Job Receipts' window never became active.", A_LineFile, A_LineNumber)
    }
}

EnterJobNumber(jobNumber)
{
    posX := posY := width := height := 0
    ControlGetPos(&posX, &posY, &width, &height, "TdxDBButtonEdit1", DBA.Windows.WIN_JOB_RECEIPTS)
    yClick := Integer(posY + height / 2)
    xClick := posX + width - 15
    MouseMove(xClick, yClick)
    MouseClick
    Send(jobNumber)
    Send("{Enter}")
}

EnterQuantitiesAndLocations(quantities)
{
    while (!ControlExist("TdxDBGrid1", DBA.Windows.WIN_JOB_RECEIPTS)) {
        Sleep(100)
    }
    ControlSendText(quantities["good"], "TdxDBGrid1", DBA.Windows.WIN_JOB_RECEIPTS)
    Sleep(100)
    ControlSend("{Down}", "TdxDBGrid1", DBA.Windows.WIN_JOB_RECEIPTS)
    Sleep(100)
    ControlSendText(quantities["scrap"], "TdxDBGrid1", DBA.Windows.WIN_JOB_RECEIPTS)
    Sleep(100)
    Send("{Tab}")
    Send("NCMR-")
    Send("{Enter}")
}

ControlExist(Control, WinTitle := "", WinText := "", ExcludeTitle := "", ExcludeText := "") {
    try {
        return ControlGetHwnd(Control, WinTitle, WinText, ExcludeTitle, ExcludeText)
    } catch {
        return false
    }
}