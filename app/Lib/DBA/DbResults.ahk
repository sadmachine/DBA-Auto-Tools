; === Script Information =======================================================
; Name .........: DBA.DbResults
; Description ..: Represents a set of raw results from the database
; AHK Version ..: 2.0.2 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: DbResults.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; DBA.DbResult
class DbResults
{
    answer := ""
    rawResult := ""
    delim := "|"
    rows := Array()
    columnHeaders := Array()

    __New(adoDbResultSet, outputType := 'object')
    {
        this.rawResult := adoDbResultSet
        if (outputType = 'object') {
            this._formatAsObject(adoDbResultSet)
        }
    }

    _formatAsObject(adoDbResultSet)
    {
        Loop adoDbResultSet.RecordCount {
            outer_index := A_Index
            row := OrderedMap()
            for field in adoDbResultSet.Fields {
                if (outer_index == 1) {
                    this.columnHeaders.push(field.name)
                }
                row[field.name] := field.value
            }
            this.rows.push(row)
            adoDbResultSet.MoveNext()
        }
    }

    _encodeNewLines(string)
    {
        return StrReplace(string, "`r`n", "\r\n")
    }

    _decodeNewLines(string)
    {
        return StrReplace(string, "\r\n", "`r`n")
    }

    count()
    {
        return this.rows.Length
    }

    row(row_num)
    {
        return this.rows[row_num]
    }

    raw()
    {
        return this.rawAnswer
    }

    empty()
    {
        return this.rows.Length == 0
    }

    data()
    {
        return this.rows
    }

    toString()
    {
        output := ''
        for index, header in this.columnHeaders {
            if (A_Index != 1) {
                output .= '|'
            }
            output .= header
        }

        output .= '`n'

        for index, row in this.rows {
            for key, val in row {
                if (A_Index != 1) {
                    output .= '|'
                }
                output .= val
            }
            output .= '`n'
        }
        return output
    }

    display()
    {
        Global
        DisplaySQL := Gui()
        DisplaySQL.New("hwndDisplaySQL +AlwaysOnTop")
        ogcListViewthislvHeaders := DisplaySQL.Add("ListView", "x8 y8 w500 r20 +LV0x4000i", [this.displayHeaders()])
        DisplaySQL.Default()

        for index, row in this.rows
        {
            data := Array()
            for header, record in row
            {
                data.push(record)
            }
            ogcListViewthislvHeaders.Add("", data*)
        }

        Loop this.colCount
        {
            ogcListViewthislvHeaders.ModifyCol(A_Index, "AutoHdr")
        }

        DisplaySQL.Show()
        return DisplaySQL
    }

    displayHeaders()
    {
        output := Array()
        for index, header in this.columnHeaders {
            output.push(StrReplace(header, "_", " "))
        }
        return output
    }
}