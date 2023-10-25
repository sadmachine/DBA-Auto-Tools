; ==== Script Information ======================================================
; Name .........: ClientInstaller
; Description ..: Handles installation on the client
; AHK Version ..: 2.0.2 (Unicode 64-bit)
; Start Date ...: 08/22/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: ClientInstaller.ahk
; ==============================================================================

; ==== Revision History ========================================================
; Revision 1 (08/22/2023)
; * Added This Banner
;
; ==== TO-DOs ==================================================================
; ==============================================================================

#Include ui/ClientInstaller.ahk

full_command_line := DllCall("GetCommandLine", "str")

if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '" /restart'
        else
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
    }
    ExitApp
}

if (A_IsCompiled) {
    versionStr := IniRead("../app/settings.ini", "version", "current")
    assetStr := "../app/Prag Logo.ico"
} else {
    versionStr := "x.x.x"
    assetStr := "../assets/Prag Logo.ico"
}

install := ClientInstaller("DBA AutoTools", versionStr, assetStr)

install.show()

return