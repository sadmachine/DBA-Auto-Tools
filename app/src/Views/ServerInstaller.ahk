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

class ServerInstaller extends UI.Installer
{
    registerPages()
    {
        this.registerPage(1, InstallationVariablesPage(this))
        this.registerPage(2, InstallationProgressPage(this))
        this.registerPage(3, CompletePage(this))
    }
}

class InstallationVariablesPage extends UI.InstallerPage
{

    build()
    {
        this.Add("Text", "ym+20 w" this.width, "You are installating the Server version of DBA AutoTools. Make sure to install this on a central location that all clients will have access to over the network. Its recommended to install it in the DBA Manufacturing directory in a subfolder.")

        this.Add("Text", "y+10 xm w" this.width, "Installation Location")

        this.controls["edtInstallationPath"] := this.Add("Edit", "w" (this.width - 60), "")
        this.SetFont("s9", "Segoe UI")
        this.controls["btnBrowse"] := this.Add("Button", "w60 yp-1 x+5", "Browse")
        this.controls["btnBrowse"].OnEvent("Click", "btnBrowse_click")

        this.Add("Text", "y+10 xm w" this.width, "Database (i.e. SERVER-NAME:C:\path\to\database)")
        this.controls["edtDatabasePath"] := this.Add("Edit", "w" this.width, "")

        this.controls["chkOverwriteSettings"] := this.Add("CheckBox", "y+20 xm+5", "Overwrite existing settings files? (only applies if this is an update)")

        super.build()
    }


    btnBrowse_click(GuiCtrlObj, Info)
    {
        this.controls["edtInstallationPath"].text := Path.makeAbsolute(FileSelect("D2", "C:\", "Select Installation Directory"))
    }

    validate()
    {
        if (!InStr(FileExist(this.controls["edtInstallationPath"].text), "D")) {
            MsgBox("The 'Installation Path' must be a valid directory.", "Validation Error", "Icon!")
            return false
        }

        return true
    }

    collect()
    {
        this.parent.data["installationPath"] := this.controls["edtInstallationPath"].text
        this.parent.data["databasePath"] := this.controls["edtDatabasePath"].text
        this.parent.data["overwriteSettings"] := this.controls["chkOverwriteSettings"].Value 
    }
}

class InstallationProgressPage extends UI.InstallerPage
{
    paths := Map()

    build()
    {
        this.controls["prgComplete"] := this.Add("Progress", "Range0-9 h20 w" this.width, 0)
        this.SetFont("s8", "Lucida Sans Typewriter")
        this.controls["edtActionLog"] := this.Add("Edit", "-Wrap +HScroll +ReadOnly h" (this.height - 30) " w" this.width)
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

        this.createDirectories()

        this.copyFiles()

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

    createDirectories()
    {
        this.logAction("Creating Directories:")

        this.paths["installation"] := Path.concat(this.parent.data["installationPath"], "DBA AutoTools")
        this.paths["app"] := Path.concat(this.paths["installation"], "app")
        this.paths["client"] := Path.concat(this.paths["installation"], "client")
        this.paths["modules"] := Path.concat(this.paths["app"], "modules")

        DirCreate(this.paths["installation"])
        this.logDone(this.paths["installation"])
        this.incrementProgress()
        DirCreate(this.paths["app"])
        this.logDone(this.paths["app"])
        this.incrementProgress()
        DirCreate(this.paths["client"])
        this.logDone(this.paths["client"])
        this.incrementProgress()
        DirCreate(this.paths["modules"])
        this.logDone(this.paths["modules"])
        this.incrementProgress()

        this.logAction()
    }

    copyFiles()
    {
        this.logAction("Copying Files:")

        overwrite := this.parent.data["overwriteSettings"]

        dbaAutoToolsExe := Path.concat(this.paths["installation"], "DBA AutoTools.exe")
        jobReceiptsExe := Path.concat(this.paths["modules"], "Job Receipts.exe")
        dashboardJson := Path.concat(this.paths["app"], "dashboard.json")
        settingsIni := Path.concat(this.paths["app"], "settings.ini")
        clientInstallExe := Path.concat(this.paths["client"], "ClientInstall.exe")
        pragLogoIco := Path.concat(this.paths["app"], "Prag Logo.ico")

        FileInstall("../dist/DBA AutoTools.exe", dbaAutoToolsExe, 1)
        this.logDone(dbaAutoToolsExe)
        this.incrementProgress()

        FileInstall("../dist/app/modules/Job Receipts.exe", jobReceiptsExe, 1)
        this.logDone(jobReceiptsExe)
        this.incrementProgress()

        if (!FileExist(dashboardJson) || overwrite) {
            FileInstall("../dist/app/dashboard.json", dashboardJson, 1)
            this.logDone(dashboardJson)
            this.incrementProgress()
        } else {
            this.logSkipped(dashboardJson)
            this.incrementProgress()
        }

        if (!FileExist(dashboardJson) || overwrite) {
            FileInstall("../dist/app/settings.ini", settingsIni, overwrite)
            IniWrite(this.parent.data["databasePath"], settingsIni, "firebird", "Database")
            this.logDone(settingsIni)
            this.incrementProgress()
        } else {
            this.logSkipped(settingsIni)
            this.incrementProgress()
        }

        FileInstall("../assets/Prag Logo.ico", pragLogoIco, 1)
        this.logDone(pragLogoIco)
        this.incrementProgress()

        FileInstall("../dist/client/ClientInstall.exe", clientInstallExe, 1)
        this.logDone(clientInstallExe)
        this.incrementProgress()

        this.logAction()
    }
}

class CompletePage extends UI.InstallerPage
{
    build()
    {
        this.Add("Text", "ym+20 w" this.width, "Server Installation is complete! You can click 'Finish' below to close this window.")
        this.parent.disable("btnPrev")

        super.build()
    }
}