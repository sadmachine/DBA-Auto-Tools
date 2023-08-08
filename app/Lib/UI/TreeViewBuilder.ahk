; === Script Information =======================================================
; Name .........: UI.TreeViewBuilder
; Description ..: Helper functions for building treeviews from other data
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/21/2023
; OS Version ...: Windows 10
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: TreeViewBuilder.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/21/2023)
; * Added This Banner
; * Update for ahk v2
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; UI.TreeViewBuilder
class TreeViewBuilder
{
    fromConfig(treeViewObj, ConfigObj)
    {
        for groupSlug, group in ConfigObj.groups {
            groupParent := treeViewObj.Add(group.Label)
            for fileSlug, file in group.files {
                fileParent := treeViewObj.Add(file.label, groupParent)
                for sectionSlug, section in file.sections {
                    sectionParent := treeViewObj.Add(section.label, fileParent)
                    for fieldSlug, field in section.fields {
                        treeViewObj.Add(field.label, sectionParent)
                    }
                }
            }
        }
    }
}