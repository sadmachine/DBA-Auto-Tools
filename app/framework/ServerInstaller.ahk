; ==== Script Information ======================================================
; Name .........: ServerInstaller Script
; Description ..: Runs the Server Installer
; AHK Version ..: 2.0.2 (Unicode 64-bit)
; Start Date ...: 08/16/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: ServerInstaller.ahk
; ==============================================================================

; ==== Revision History ========================================================
; Revision 1 (08/16/2023)
; * Added This Banner
;
; ==== TO-DOs ==================================================================
; ==============================================================================

#Include Views/ServerInstaller.ahk
#Include <v2/Tmp>

if (A_IsCompiled) {
    versionStr := SubStr(A_ScriptName, 29)
    versionStr := StrSplit(versionStr, ".exe")[1]
    tmpPath := Tmp.path("DBA AutoTools", "Prag Logo.ico")
    FileInstall("assets/Prag Logo.ico", tmpPath, 1)
    assetStr := tmpPath
} else {
    versionStr := "x.x.x"
    assetStr := "assets/Prag Logo.ico"
}

install := ServerInstaller("DBA AutoTools", versionStr, assetStr)

install.show()

return