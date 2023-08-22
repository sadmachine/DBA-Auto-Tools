; ==== Script Information ======================================================
; Name .........: ServerInstaller
; Description ..: description
; AHK Version ..: 2.* (Unicode 64-bit)
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

; Directives
#Requires AutoHotkey >=2.0

; Includes
#Include <v2/UI>
#Include <v2/Path>

class ClientInstaller extends UI.Installer
{
    registerPages()
    {
        this.registerPage(1, IntroductionPage(this))
        this.registerPage(2, ProgressPage(this))
        this.registerPage(3, CompletePage(this))
    }
}

class IntroductionPage extends UI.InstallerPage
{

    build()
    {
        this.guiObj.Add("Text", "ym+20 w" this.width, "You are installating the Client version of DBA AutoTools. Make sure that you are running this as the administrator, otherwise some installation tasks may fail.`nThe installation will place a shortcut to the program on the Public Desktop (for all users), as well as the system startup folder (for all users).")

        super.build()
    }
}

class ProgressPage extends UI.InstallerPage
{
    paths := Map()

    build()
    {
        this.controls["prgComplete"] := this.Add("Progress", "Range0-2 h20 w" this.width, 0)
        this.SetFont("s8", "Lucida Sans Typewriter")
        this.controls["edtActionLog"] := this.Add("Edit", "+ReadOnly h" (this.height - 30) " w" this.width)
        super.build()
    }

    performActions()
    {
        ; Disable parent buttons
        this.parent.disable("btnPrev")
        this.parent.disable("btnNext")
        this.parent.disable("btnFinish")
        this.parent.disable("btnCancel")

        ; Run Actions

        this.createShortcuts()

        this.logAction()

        this.logAction("Complete!")

        ; Enable parent buttons
        this.parent.enable("btnNext")
        this.parent.enable("btnFinish")
        this.parent.enable("btnCancel")
    }

    logAction(text := "", level := 0, useLineBreak := true)
    {
        output := ""
        loop level {
            output .= "  "
        }
        output .= text
        if (useLineBreak) {
            output .= "`n"
        }
        this.controls["edtActionLog"].Value .= output 
        ControlSend("^{End}", this.controls["edtActionLog"], this.guiObj)
    }

    logDone(text, level := 1, useLineBreak?)
    {
        text := Format("{:- 7s}{: 5s}{:s}", "DONE", " ... ", text)
        this.logAction(text, level?, useLineBreak?)
    }

    logSkipped(text, level := 1, useLineBreak?)
    {
        text := Format("{:- 7s}{: 5s}{:s}", "SKIPPED", " ... ", text)
        this.logAction(text, level?, useLineBreak?)
    }

    updateProgress(amount)
    {
        this.controls["prgComplete"].Value += amount
    }

    incrementProgress()
    {
        this.updateProgress(1)
    }

    createShortcuts()
    {
        this.logAction("Creating Shortcuts:")

        rootPath := Path.makeAbsolute(Path.concat(A_ScriptDir, "../"))
        MsgBox(rootPath)
        uncRootPath := Path.convertToUnc(rootPath)
        MsgBox(uncRootPath)
        targetPath := Path.concat(uncRootPath, "DBA AutoTools.exe")
        desktopLinkPath := Path.concat(A_DesktopCommon, "DBA AutoTools.lnk")
        startupLinkPath := path.concat(A_StartupCommon, "DBA AutoTools.lnk")

        FileCreateShortcut(targetPath, desktopLinkPath, uncRootPath)
        this.logDone(desktopLinkPath)
        this.incrementProgress()
        FileCreateShortcut(targetPath, startupLinkPath, uncRootPath)
        this.logDone(startupLinkPath)
        this.incrementProgress()

        this.logAction()
    }

}

class CompletePage extends UI.InstallerPage
{

    build()
    {
        this.guiObj.Add("Text", "ym+20 w" this.width, "Client Installation is complete! You can click 'Finish' below to close this window.")

        super.build()
    }
}