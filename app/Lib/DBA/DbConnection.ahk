; === Script Information =======================================================
; Name .........: DBA.DbConnection
; Description ..: Handles the database connection to DBA
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: DbConnection.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; DBA.DbConnection
class DbConnection extends SimpleAdoDbConnection
{
    DSN := "DBA NG"
    UID := "SYSDBA"
    PWD := "masterkey"
    RO := true
    colDelim := "||"
    connectionStr := ""
    __New(DSN?, UID?, PWD?, colDelim?)
    {
        if (IsSet(DSN)) {
            this.DSN := DSN
        }
        if (IsSet(UID)) {
            this.UID := UID
        }
        if (IsSet(PWD)) {
            this.PWD := PWD
        }

        if (IsSet(colDelim)) {
            this.colDelim := colDelim
        }
        this._buildConnectionStr()

        super.__New(this.connectionStr)
    }

    ReadOnly(is_ro)
    {
        this.RO := is_ro
    }

    _buildConnectionStr()
    {
        ro_str := (this.RO ? "READONLY=YES" : "")
        colDelim := this.colDelim
        this.connectionStr := "DSN=" this.DSN ";UID=" this.UID ";PWD=" this.PWD ";" ro_str ";coldelim=" colDelim
    }

    query(qStr)
    {
        this._buildConnectionStr()
        thisResult := DBA.DbResults(super.query(qStr))
        return thisResult
    }
}