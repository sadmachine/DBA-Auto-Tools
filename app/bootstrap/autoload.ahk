; === TO-DOs ===================================================================
; ==============================================================================
; === Script Information =======================================================
; Name .........: Autoload
; Description ..: File for autoloading necessary files across entrypoints
; AHK Version ..: 2.0.2 (Unicode 64-bit)
; Start Date ...: 08/05/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: _autoload.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (08/05/2023)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================

; Start in the root directory
#Include ../

; --- Library includes ---------------------------------------------------------
#Include <DBA>
#Include <Vendor/Json>
#Include <Path>
#Include <UI>

; --- Local includes -----------------------------------------------------------
#Include src/Dashboard.ahk