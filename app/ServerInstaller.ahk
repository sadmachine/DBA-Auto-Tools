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

class ServerInstaller extends UI.Installer
{
    registerPages()
    {

    }
}

class InstallationPathPage extends UI.InstallerPage
{

    build()
    {
        this.parent.GetClientPos(unset, unset, &width)
        width := width - this.parent.marginX - 20
        this.guiObj := Gui(this.options, "test", this)
        this.guiObj.Add("Text", "w" width, "You are installating the Server version of DBA AutoTools. Make sure to install this on a central location that all clients will have access to over the network. Its recommended to install it in the DBA Manufacturing directory in a subfolder.")
        this.guiObj.Add("Text", "y+10 xm w" width, "Installation Location")
        this.fields["edtInstallationPath"] := this.guiObj.Add("Edit", "w" width - 60, "")
        this.fields["edtInstallationPath"].OnEvent("Change", "editInstallationPath_change")
        this.actions["btnBrowse"] := this.guiObj.Add("Button", "w60 yp-1 x+5", "Browse")
        this.actions["btnBrowse"].OnEvent("Click", "btnBrowse_click")

        super.build()
    }


    btnBrowse_click(GuiCtrlObj, Info)
    {
        this.fields["edtInstallationPath"].text := FileSelect("D2", "C:\", "Select Installation Directory")
        this.parent.data["installationPath"] := this.fields["edtInstallationPath"].text
    }

    editInstallationPath_change(GuiCtrlObj, Info)
    {
        this.parent.data["installationPath"] := this.fields["edtInstallationPath"].text
        MsgBox("Updated Installation Path: " this.parent.data["installationPath"])
    }

    collect()
    {
        this.parent.data["installationPath"] := this.fields["edtInstallationPath"].text
        MsgBox("Installation Path: " this.parent.data["installationPath"])
    }
}

class InstallationProgressPage extends UI.InstallerPage
{

    build()
    {
        this.parent.GetClientPos(unset, unset, &width)
        width := width - this.parent.marginX - 20
        this.guiObj := Gui(this.options, "test", this)
        this.guiObj.Add("Text", "w" width, "You are installating the Server version of DBA AutoTools. Make sure to install this on a central location that all clients will have access to over the network. Its recommended to install it in the DBA Manufacturing directory in a subfolder.")
        this.guiObj.Add("Text", "y+10 xm w" width, "Installation Location")
        this.fields["edtInstallationPath"] := this.guiObj.Add("Edit", "w" width - 60, "")
        this.fields["edtInstallationPath"].OnEvent("Change", "editInstallationPath_change")
        this.actions["btnBrowse"] := this.guiObj.Add("Button", "w60 yp-1 x+5", "Browse")
        this.actions["btnBrowse"].OnEvent("Click", "btnBrowse_click")

        super.build()
    }


    btnBrowse_click(GuiCtrlObj, Info)
    {
        this.fields["edtInstallationPath"].text := FileSelect("D2", "C:\", "Select Installation Directory")
        this.parent.data["installationPath"] := this.fields["edtInstallationPath"].text
    }

    editInstallationPath_change(GuiCtrlObj, Info)
    {
        this.parent.data["installationPath"] := this.fields["edtInstallationPath"].text
        MsgBox("Updated Installation Path: " this.parent.data["installationPath"])
    }

    collect()
    {
        this.parent.data["installationPath"] := this.fields["edtInstallationPath"].text
        MsgBox("Installation Path: " this.parent.data["installationPath"])
    }
}