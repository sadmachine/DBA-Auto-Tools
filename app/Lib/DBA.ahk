; ==== Script Information ======================================================
; Name .........: DBA
; Description ..: The parent class for DBA related classes
; AHK Version ..: 2.0.2 (Unicode 64-bit)
; Start Date ...: 08/06/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: DBA.ahk
; ==============================================================================

; ==== Revision History ========================================================
; Revision 1 (08/06/2023)
; * Added This Banner
;
; ==== TO-DOs ==================================================================
; ==============================================================================
#Include Database/SimpleAdoDbConnection.ahk
#Include DataTypes/OrderedMap.ahk

class DBA {
    #Include DBA/Windows.ahk
    #Include DBA/ActiveRecord.ahk
    #Include DBA/RecordSet.ahk
    #Include DBA/DbConnection.ahk
    #Include DBA/DbResults.ahk
    #Include DBA/QueryBuilder.ahk
}