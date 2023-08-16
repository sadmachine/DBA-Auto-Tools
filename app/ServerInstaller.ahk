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

#Include src/views/ServerInstaller.ahk

if (A_IsCompiled) {
    versionStr := SubStr(A_ScriptName, 28)
    versionStr := SubStr(versionStr, 0, -4)
    assetStr := "assets/Prag Logo.ico"
} else {
    versionStr := "x.x.x"
    assetStr := "../assets/Prag Logo.ico"
}

install := ServerInstaller("DBA AutoTools", versionStr, assetStr)

install.show()

return