class Windows {
    static DBA_EXE := "ahk_exe ejsme.exe"
    static Main := "ahk_exe ejsme.exe ahk_class TfrmAppMain"
    static POReceiptLookup := "ahk_exe ejsme.exe ahk_class TFrmPopDrpPORecLook"
    static POReceipts := "ahk_exe ejsme.exe ahk_class TFrmPOReceipts"
    static JobReceipts := "ahk_exe ejsme.exe ahk_class "

    static MenuOpen(menuPath)
    {
        menus := StrSplit(menuPath, ".")
        if (menus.Length > 7) {
            throw Error("InvalidParametersError", A_ThisFunc, "Menu Path should not contain more than 7 levels.", A_LineFile, A_LineNumber)
        }
        MenuSelect(this.DBA_EXE, , menus*)
    }
}