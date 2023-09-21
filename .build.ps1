#### List of build rules for the build.ps1 file
## Data Format
#   process             The name of the process, to close if running
#   in                  The source ahk file to compile
#   out                 The target location for the generated executable
#   icon                The icon that should be associated with the executable
#   before              Any code that should be run before compilation
#   after               Any code that should be run after compilation 
#
##  Available Variables:
#   $currentVersion     Contains the current version number
#   $pwd                Returns the path the build command is being run from
####

$buildRules = @(
    @{
        process = "DBA AutoTools.exe"
        in      = "$pwd\app\framework\DBA AutoTools.ahk"
        out     = "$pwd\dist\DBA AutoTools.exe"
        icon    = "$pwd\app\framework\assets\Prag Logo.ico"
    }
    @{
        process = "Job Receipts.exe"
        in      = "$pwd\app\Job Receipts.ahk"
        out     = "$pwd\dist\app\modules\Job Receipts.exe"
        icon    = "$pwd\app\framework\assets\Prag Logo.ico"
    }
    @{
        process = "ClientInstall.exe"
        in      = "$pwd\app\framework\ClientInstaller.ahk"
        out     = "$pwd\dist\client\ClientInstall.exe"
        icon    = "$pwd\app\framework\assets\Installer.ico"
    }
    @{
        process = "DBA-AutoTools-ServerInstall-$currentVersion.exe"
        in      = "$pwd\app\framework\ServerInstaller.ahk"
        out     = "$pwd\installers\DBA-AutoTools-$currentVersion\DBA-AutoTools-ServerInstall-$currentVersion.exe"
        icon    = "$pwd\app\framework\assets\Installer.ico"
        before  = @"
if (Test-Path "$pwd\installers\DBA-AutoTools-$currentVersion\") {
    Remove-Item "$pwd\installers\DBA-AutoTools-$currentVersion" -Recurse -Force
}
if (Test-Path "$pwd\installers\DBA-AutoTools-$currentVersion.zip") {
    Remove-Item "$pwd\installers\DBA-AutoTools-$currentVersion.zip" -Recurse -Force
}
New-Item -ItemType Directory -Force -Path "$pwd\installers\DBA-AutoTools-$currentVersion\"
"@
        after   = @"
& 'C:\Program Files\7-Zip\7z.exe' a -tzip "$pwd\installers\DBA-AutoTools-$currentVersion.zip" "$pwd\installers\DBA-AutoTools-$currentVersion"
Remove-Item "$pwd\installers\DBA-AutoTools-$currentVersion" -Recurse -Force
"@
    }
)