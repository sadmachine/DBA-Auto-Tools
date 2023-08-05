; === Script Information =======================================================
; Name .........: DBA.QueryBuilder
; Description ..: Utility class for querying the DBA database
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/19/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: QueryBuilder.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/19/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; DBA.QueryBuilder
class QueryBuilder
{
    _connection := ""
    _fields := "*"
    _table := ""
    _conditions := ""
    _ordering := ""
    _limit := ""
    _page := ""

    connection
    {
        get
        {
            if (this._connection == "") {
                this.connection := DBA.DbConnection()
            }
            return this._connection
        }
        set
        {
            this._connection := value
            return this._connection
        }
    }

    __New(table, connection := "")
    {
        this._table := table
        if (connection != "") {
            this.connection := connection
        }
    }

    from(table, connection := "")
    {
        builder := DBA.QueryBuilder(table, connection)
        return builder
    }

    Select(fields)
    {
        this._fields := fields
        return this
    }

    Where(conditions)
    {
        this._conditions := ""
        if (IsObject(conditions)) {
            for field, value in conditions {
                if (A_Index != 1) {
                    this._conditions .= "AND "
                }
                this._conditions .= field "'" value "' "
            }
        } else {
            this._conditions := conditions
        }
        return this
    }

    OrderBy(ordering)
    {
        this._ordering := ordering
        return this
    }

    Limit(limit)
    {
        this._limit := limit
        return this
    }

    Page(page)
    {
        this._page := page
        return this
    }

    _buildQuery()
    {
        local query := "SELECT"

        ; Limit and page, if those variables are specified
        if (this._limit != "") {
            query .= " FIRST " this._limit

            if (this._page != "") {
                query .= " SKIP " (this._limit * (this._page - 1))
            }
        }

        ; Get all columns from the specified table name
        query .= " " this._fields " FROM " this._table

        ; Add our where statement, if specified
        if (this._conditions != "") {
            query .= " WHERE " this._conditions
        }

        ; Add our order by statement, if specified
        if (this._ordering != "") {
            query .= " ORDER BY " this._ordering
        }

        query .= ";"

        return query
    }

    Run()
    {
        query := this._buildQuery()
        if (IsSet(Env) && Env["SHOW_QUERIES"]) {
            MsgBox(query)
        }
        return this.connection.query(query)
    }
}