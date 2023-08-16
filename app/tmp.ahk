#Include <v2/UI>

class SelectInstallationPath extends UI.InstallerPage
{
    build()
    {
        this.Add("Text", "w" this.width, "You are installating the Server version of DBA AutoTools. Make sure to install this on a central location that all clients will have access to over the network. Its recommended to install it in the DBA Manufacturing directory in a subfolder, as all DBA Clients need access to that location anyways.")
        this.Add("Text", "w" this.width, "Installation Location")
        this.fields["edtInstallationPath"] := this.Add("Edit", "w" this.width - 60, "")
        this.fields["edtInstallationPath"].OnEvent("Change", "editInstallationPath_change")
        this.actions["btnBrowse"] := this.Add("Button", "w60 yp-1 x+5", "Browse")
        this.actions["btnBrowse"].OnEvent("Click", "btnBrowse_click")

        super.build()
    }


    btnBrowse_click(GuiCtrlObj, Info)
    {
        this.fields["edtInstallationPath"].text := FileSelect("D2", "C:\", "Select Installation Directory")
    }

    editInstallationPath_change(GuiCtrlObj, Info)
    {
        this.parent.data["installationPath"] := this.fields["edtInstallationPath"].text
    }

    collect()
    {
        this.parent.data["installationPath"] := this.fields["edtInstallationPath"].text
    }
}

class InstallationProgressPage extends UI.InstallerPage
{

    build()
    {
        this.Add("Progress", "Range0-8 h20 w" this.width, 0)
        this.Add("Edit", "-Wrap +ReadOnly h" (this.height - 30) " w" this.width)
        super.build()
    }
}

install := UI.Installer("Test Installer", "0.9.7", "..\assets\Prag Logo.ico")

install.registerPage(1, SelectInstallationPath(install))
install.registerPage(2, InstallationProgressPage(install))

install.show()