#Include <v2/UI>

class SelectInstallationPath extends UI.InstallerPage
{
    build()
    {
        if (this.built) {
            return
        }
        this.parent.GetClientPos(unset, unset, &width)
        width := width - this.parent.marginX - 20
        this.guiObj := Gui(this.options, "test", this)
        this.guiObj.Add("Text", "w" width, "You are installating the Server version of DBA AutoTools. Make sure to install this on a central location that all clients will have access to over the network. Its recommended to install it in the DBA Manufacturing directory in a subfolder, as all DBA Clients need access to that location anyways.")
        this.guiObj.Add("Text", "w" width, "Installation Location")
        this.fields["edtInstallationPath"] := this.guiObj.Add("Edit", "w" width - 60, "")
        this.fields["edtInstallationPath"].OnEvent("Change", "editInstallationPath_change")
        this.actions["btnBrowse"] := this.guiObj.Add("Button", "w60 yp-1 x+5", "Browse")
        this.actions["btnBrowse"].OnEvent("Click", "btnBrowse_click")

        this.built := true
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

install := UI.Installer("Test Installer", "0.9.7", "..\assets\Prag Logo.ico")

obj1 := SelectInstallationPath(install)
obj2 := SelectInstallationPath(install)

install.registerPage(1, obj1)
install.registerPage(2, obj2)

install.show()