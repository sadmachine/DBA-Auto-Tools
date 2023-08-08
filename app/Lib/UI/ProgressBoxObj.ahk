; === Script Information =======================================================
; Name .........: ProgressBoxObj
; Description ..: Utility class for easily creating progress GUIs
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 02/27/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: ProgressBoxObj.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (02/27/2023)
; * Added This Banner
;
; Revision 2 (02/27/2023)
; * Don't allow count to show more than max count
;
; Revision 3 (04/21/2023)
; * Update for ahk v2
; 
; === TO-DOs ===================================================================
; ==============================================================================
class ProgressBoxObj extends UI.Base
{

    _indeterminate := true
    _startValue := ""
    _barFGColor := "Lime"
    _barBGColor := "Silver"
    _currentCount := 0

    __New(displayText, title := "", options := "-SysMenu +AlwaysOnTop")
    {
        this.displayText := displayText
        this.title := (title ? title : displayText)
        super.__New(title, options)
    }

    SetRange(firstVal, secondVal := "")
    {
        this._indeterminate := false

        if (secondVal == "") {
            this._minCount := 0
            this._maxCount := firstVal
        } else {
            this._minCount := firstVal
            this._maxCount := secondVal
        }
    }

    SetStartValue(value)
    {
        this._startValue := value
        this._currentCount := value
    }

    SetBarFGColor(colorVal)
    {
        this._barFGColor := colorVal
    }

    SetBarBGColor(colorVal)
    {
        this._barBGColor := colorVal
    }

    _getRangeOption()
    {
        if (this._indeterminate) {
            return "0x8"
        } else {
            return "range" this._minCount "-" this._maxCount
        }
    }

    _getStartValue()
    {
        return (this._startValue == "" ? this._minCount : this._startValue)
    }

    Show(options := "", title := -1)
    {
        this.ApplyFont()
        this.Add("Text", "Center w280", this.displayText)
        this.ProgressBar := this.Add("Progress", "w280 h20 background" this._barBGColor " c" this._barFGColor " " this._getRangeOption(), 1)
        if (!this._indeterminate) {
            this.ProgressText := this.Add("Text", "Center w280 r1", this._getStartValue() " / " this._maxCount)
        }
        super.Show(options, title)
    }

    Update(progressBarValue, textValue)
    {
        progressBar := this.ProgressBar
        progressText := this.ProgressText
        if (this._indeterminate) {
            progressBar.Value := 1
        } else {
            progressBar.Value := progressBarValue
            progressText.Text := textValue " / " this._maxCount
        }
    }

    Increment()
    {
        progressBar := this.ProgressBar
        progressText := this.ProgressText
        if (this._indeterminate) {
            progressBar.Value := 1
        } else {
            this._currentCount += 1
            if (this._currentCount > this._maxCount) {
                this._currentCount := this._maxCount
            }
            progressBar.Value := this._currentCount
            progressText.Text := this._currentCount " / " this._maxCount
        }
    }
}