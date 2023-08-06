; ==== Script Information ======================================================
; Name .........: DBA.Windows
; Description ..: A class used to manage various windows within DBA
; AHK Version ..: 2.* (Unicode 64-bit)
; Start Date ...: 08/06/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: Windows.ahk
; ==============================================================================

; ==== Revision History ========================================================
; Revision 1 (08/06/2023)
; * Added This Banner
;
; ==== TO-DOs ==================================================================
; ==============================================================================
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