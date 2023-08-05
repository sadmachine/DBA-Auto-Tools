; === Script Information =======================================================
; Name .........: DBA.RecordSet
; Description ..: Handles a set of ActiveRecords returned from the database
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: RecordSet.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; DBA.RecordSet
class RecordSet
{
    records := []

    __New(records)
    {
        this.records := records
    }

    buildWith(classObjOrTable, fields, where := "", orderBy := "", limit := "", page := "")
    {
        local index, row
        tableName := classObjOrTable
        if (IsObject(classObjOrTable)) {
            tableName := classObjOrTable.tableName
        }

        results := DBA.QueryBuilder
            .from(tableName)
            .select(fields)
            .where(where)
            .orderBy(orderBy)
            .limit(limit)
            .page(page)
            .run()

        records := []

        for index, row in results.data() {
            records.push(DBA.ActiveRecord(row))
        }

        return records
    }

    build(classObjOrTable, where := "", orderBy := "", limit := "", page := "")
    {
        return this.buildWith(classObjOrTable, "*", where, orderBy, limit, page)
    }
}