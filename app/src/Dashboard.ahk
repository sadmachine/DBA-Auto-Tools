; ==== Script Information ======================================================
; Name .........: Dashboard Interface
; Description ..: The main "DBA AutoTools" dashboard
; AHK Version ..: 2.0.2
; Start Date ...: 08/05/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Dashboard.ahk
; ==============================================================================

; ==== Revision History ========================================================
; Revision 1 (08/05/2023)
; * Copy from old repo, convert to ahk v2
; * Fix DBA.Window variable references
;
; ==== TO-DOs ==================================================================
; TODO - Abstract out to a controller and a view
; TODO - Move as much configuration stuff into the .json file as possible
; TODO - Generalize logic where possible
; ==============================================================================
class Dashboard
{
    static built := false
    static vertical_fix := 65
    static height := 200
    static width := 300
    static padding := 20
    static hwnd := Map()
    static display_x := 0
    static display_y := 0
    static sections := Map()
    static modules := Map()
    static section_padding_top := 20
    static section_padding_bottom := 5
    static section_padding_x := 5
    static button_interior_padding := 5
    static guiObj := Object()
    static actions := Map()

    static initialize(configFileName)
    {
        this._readDashboardConfig(configFileName)
        daemon := ObjBindMethod(Dashboard, "_daemon")
        SetTimer(daemon, 250)
    }

    static _daemon() {
        if (!this.built) {
            this.build(true)
        } else {
            this.destroyOnClose()
        }
    }

    static build(show := false)
    {
        this.display_x := 234 + this.padding
        this.display_y := 74

        ; Wait for the Main DBA window to be active
        WinWait(DBA.Windows.WIN_MAIN)
        WinActivate(DBA.Windows.WIN_MAIN)
        WinWaitActive(DBA.Windows.WIN_MAIN)

        ; Build the dashboard
        this.guiObj := Gui(, , Dashboard.Events(this.actions))
        this.guiObj.MarginX := this.configObj["marginX"]
        this.guiObj.MarginY := this.configObj["marginY"]
        this.guiObj.SetFont("s12")

        this._addActions()

        this.guiObj.Opt("+OwnDialogs +AlwaysOnTop")

        ; Get a reference to the "parent" and "child" window
        this.hwnd["parent"] := WinExist(DBA.Windows.WIN_MAIN)
        this.hwnd["child"] := this.guiObj.hwnd

        this.built := true

        if (show) {
            this.show()
        }
    }

    static show()
    {
        this.guiObj.Title := this.configObj["title"]
        this.guiObj.Show("x" this.display_x " y" this.display_y)
        ; Need to set the parent of the gui to the "DBA NG Sub-Assy Jobs" program

        ; This makes it so our dashboard moves with the parent window, and acts like its part of the program
        DllCall("SetParent", "Ptr", this.hwnd["child"], "Ptr", this.hwnd["parent"])

        ; Disable the close button
        hSysMenu := DllCall("GetSystemMenu", "Int", this.hwnd["child"], "Int", FALSE)
        nCnt := DllCall("GetMenuItemCount", "Int", hSysMenu)
        DllCall("RemoveMenu", "Int", hSysMenu, "Uint", nCnt - 1, "Uint", "0x400")
        DllCall("RemoveMenu", "Int", hSysMenu, "Uint", nCnt - 2, "Uint", "0x400")
        DllCall("DrawMenuBar", "Int", this.hwnd["child"])

        x := y := width := height := 0

        this.guiObj.GetClientPos(unset, unset, &width, &height)

        if ((width - (this.configObj["marginX"] * 2)) < this.configObj["minWidth"]) {
            UI.setClientPos(this.guiObj, this.display_x, this.display_y, this.configObj["minWidth"])
        }
        if ((height - (this.configObj["marginY"] * 2)) < this.configObj["minHeight"]) {
            UI.setClientPos(this.guiObj, this.display_x, this.display_y, unset, this.configObj["minHeight"])
        }
    }

    static destroyOnClose()
    {
        WinWaitClose(DBA.Windows.WIN_MAIN)
        this.guiObj.Destroy()
        this.built := false
    }

    static _addActions()
    {
        for key, action in this.configObj["actions"] {
            label := action["label"]
            action := this.guiObj.Add("Button", action["options"], action["label"])
            action.OnEvent("Click", "handleAction")
        }
    }

    static _readDashboardConfig(configFileName)
    {
        configFile := FileOpen(configFileName, "r")
        configJson := configFile.read()
        this.configObj := Jxon_Load(&configJson)
        this.actions := OrderedMap()
        for key, value in this.configObj["actions"] {
            this.actions[value["label"]] := value
        }
    }

    ; _setupApplicationMenu()
    ; {
    ;     global
    ;     ; Get a reference to our events
    ;     openSettingsEvent := ObjBindMethod(this.Events, "openSettings")
    ;     ; Gui Menu setup
    ;     DashboardMenuBar := Menu()
    ;     DashboardMenuBar.Add("&Settings", openSettingsEvent)
    ;     this.guiObj.MenuBar := DashboardMenuBar
    ; }

    ; _setupTrayMenu()
    ; {
    ;     ; Get a reference to our events
    ;     openSettingsEvent := ObjBindMethod(this.Events, "openSettings")
    ;     applicationLogEvent := ObjBindMethod(this.Events, "applicationLog")
    ;     exitProgramEvent := ObjBindMethod(this.Events, "exitProgram")
    ;     ; Tray Menu Setup
    ;     Tray := A_TrayMenu
    ;     Tray.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning
    ;     Tray.Add("Settings", openSettingsEvent)
    ;     AdvancedSubMenu := Menu()
    ;     AdvancedSubMenu.Add("Application Log", applicationLogEvent)
    ;     Tray.Add("Advanced", AdvancedSubMenu)
    ;     Tray.Add("Exit", exitProgramEvent)
    ; }
    class Events {

        actions := Object()

        __New(actions)
        {
            this.actions := actions
        }

        handleAction(GuiCtrlObj, Info)
        {
            action := this.actions[GuiCtrlObj.Text]
            executable := Path.makeAbsolute(action["file"])
            MsgBox(executable)
            Run(executable)
        }
    }
}