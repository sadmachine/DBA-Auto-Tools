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
        this.fields["prgComplete"] := this.Add("Progress", "Range0-8 h20 w" this.width, 0)
        this.fields["edtActionLog"] := this.Add("Edit", "+ReadOnly h" (this.height - 30) " w" this.width)
        super.build()
    }

    performActions()
    {
        ; Disable parent buttons
        this.parent.actions["btnPrev"].opt("+Disabled")
        this.parent.actions["btnNext"].opt("+Disabled")
        this.parent.actions["btnFinish"].opt("+Disabled")
        this.parent.actions["btnCancel"].opt("+Disabled")

        ; Run Actions

        this.createShortcuts()

        this.logAction()

        this.logAction("Complete!")

        ; Enable parent buttons
        this.parent.actions["btnPrev"].opt("-Disabled")
        this.parent.actions["btnNext"].opt("-Disabled")
        this.parent.actions["btnFinish"].opt("+Disabled")
        this.parent.actions["btnCancel"].opt("-Disabled")
    }

    logAction(text := "", useLineBreak := true)
    {
        lineBreak := (useLineBreak ? "`n" : "")
        this.fields["edtActionLog"].Value .= text lineBreak
        ControlSend("^{End}", this.fields["edtActionLog"], this.guiObj)
    }

    updateProgress(amount)
    {
        this.fields["prgComplete"].Value += amount
    }

    incrementProgress()
    {
        this.updateProgress(1)
    }

    createDirectories()
    {
        this.logAction("Creating Directories:")

        this.paths["installation"] := Path.concat(this.parent.data["installationPath"], "DBA AutoTools")
        this.paths["app"] := Path.concat(this.paths["installation"], "app")
        this.paths["client"] := Path.concat(this.paths["installation"], "client")
        this.paths["modules"] := Path.concat(this.paths["app"], "modules")

        DirCreate(this.paths["installation"])
        this.logAction("`t" this.paths["installation"])
        this.incrementProgress()
        DirCreate(this.paths["app"])
        this.logAction("`t" this.paths["app"])
        this.incrementProgress()
        DirCreate(this.paths["client"])
        this.logAction("`t" this.paths["client"])
        this.incrementProgress()
        DirCreate(this.paths["modules"])
        this.logAction("`t" this.paths["modules"])
        this.incrementProgress()

        this.logAction()
    }

    copyFiles()
    {
        this.logAction("Copying Files:")

        dbaAutoToolsExe := Path.concat(this.paths["installation"], "DBA AutoTools.exe")
        jobReceiptsExe := Path.concat(this.paths["modules"], "Job Receipts.exe")
        dashboardJson := Path.concat(this.paths["app"], "dashboard.json")
        settingsIni := Path.concat(this.paths["app"], "settings.ini")
        clientInstallExe := Path.concat(this.paths["client"], "ClientInstall.exe")

        FileInstall("../dist/DBA AutoTools.exe", dbaAutoToolsExe, 1)
        this.logAction("`t" dbaAutoToolsExe)
        this.incrementProgress()
        FileInstall("../dist/app/modules/Job Receipts.exe", jobReceiptsExe, 1)
        this.logAction("`t" jobReceiptsExe)
        this.incrementProgress()
        FileInstall("../dist/app/dashboard.json", dashboardJson, 1)
        this.logAction("`t" dashboardJson)
        this.incrementProgress()
        FileInstall("../dist/app/settings.ini", settingsIni, 1)
        this.logAction("`t" settingsIni)
        this.incrementProgress()
        FileInstall("../dist/client/ClientInstall.exe", clientInstallExe, 1)
        this.logAction("`t" clientInstallExe)
        this.incrementProgress()
        this.logAction()
    }
}

class CompletePage extends UI.InstallerPage
{

    build()
    {
        this.guiObj.Add("Text", "ym+20 w" this.width, "Server Installation is complete! You can click 'Finish' below to close this window.")

        super.build()
    }
}