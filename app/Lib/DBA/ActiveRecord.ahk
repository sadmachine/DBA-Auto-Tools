; === Script Information =======================================================
; Name .........: DBA.ActiveRecord
; Description ..: Handles a single record from the database
; AHK Version ..: 2.0.2 (Unicode 64-bit)
; Start Date ...: 08/05/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: ActiveRecord.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; DBA.ActiveRecord
class ActiveRecord
{

    _pk := ""
    _tableName := ""
    _exists := false

    pk
    {
        get
        {
            return this._pk
        }
        set
        {
            this._pk := value
            return this._pk
        }
    }

    tableName
    {
        get
        {
            if (this._tableName == "") {
                className := StrSplit(this.__Class, ".")
                className := className[className.MaxIndex()]
                return className
            }
            return this._tableName
        }
        set
        {
            this._tableName := value
            return this._tableName
        }
    }

    exists
    {
        get
        {
            return this._exists
        }
        set
        {
            this._exists := value
            return this._exists
        }
    }

    __New(criteria)
    {
        if (criteria == "") {
            this.exists := false
            return
        }
        if (IsObject(criteria)) {
            this._buildFromObject(criteria)
        } else {
            this._buildFromPk(criteria)
        }
    }

    _buildFromObject(options)
    {
        for name, value in options {
            this.exists := true
            this[name] := value
        }
    }

    _buildFromPk(searchPk)
    {
        local results := ""

        results := DBA.QueryBuilder
            .from(this.tableName)
            .where(this.pk " = '" searchPk "'")
            .run()

        if (!results.empty()) {
            this.exists := true
            firstRow := results.row(1)
            this._buildFromObject(firstRow)
        }
    }

    hasOne(criteria)
    {
        local results
        results := this.build(criteria)
        return results.exists
    }

    has(criteria)
    {
        local results
        results := this.build(criteria)
        return (results.Count() > 0)
    }

    build(where := "", orderBy := "", limit := "", page := "")
    {
        return DBA.RecordSet.build(this.tableName, where, orderBy, limit, page)
    }

}