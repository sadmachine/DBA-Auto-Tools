; ==== Script Information ======================================================
; Name .........: WinWaitCloseMsgBox
; Description ..: Custom MsgBox that waits for a specified window to close
; AHK Version ..: 2.* (Unicode 64-bit)
; Start Date ...: 10/24/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: WinWaitCloseMsgBox.ahk
; ==============================================================================

; ==== Revision History ========================================================
; Revision 1 (10/24/2023)
; * Added This Banner
;
; ==== TO-DOs ==================================================================
; ==============================================================================

; Directives
#Requires AutoHotkey >=2.0

class WinWaitCloseMsgBox
{
    guiObj := Object()

    __New(message, winTitle, title := "", options := "+AlwaysOnTop +ToolWindow")
    {
        this.guiObj := Gui(options, title)
        this.guiObj.MarginX := 10 
        this.guiObj.add("Text", "w236", message)
        this.guiObj.show("w256")
        WinWaitClose(winTitle)
        this.guiObj.destroy()
    }
}