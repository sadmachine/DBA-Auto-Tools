Param(
    [string]$versionNumber = $null,
    [string]$buildConfigPath = "$pwd\.build.ps1"
)

if (-not(Test-Path $buildConfigPath)) {
    Write-Output "Please supply a valid config path, found: `n`r`t$buildConfigPath"
    exit 1
}

# Setup some variables for use during build
$compiler = $Env:AHK_COMPILER;
$binFile = $Env:AHK2_COMPILER_BINFILE;

if ($null -ne $versionNumber) {
    $currentVersion = $versionNumber;
}
else {
    $currentVersion = git describe --tags --abbrev=0
    $currentVersion = $currentVersion + ".beta"
}

# Import out build config (once necessary variables are available)
. $buildConfigPath

# Prior to building, make sure we've updated the stored version
$settingsPath = Join-Path -Path $pwd -ChildPath "dist\app\settings.ini"
inifile $settingsPath [version] current=$currentVersion

# Build using the build rules in the build config
$buildRules | ForEach-Object {
    $processFilename = $_['process']
    Write-Output ('#' * ($Host.UI.RawUI.WindowSize.Width - 10))
    Write-Output "Check if process exists: $processFilename"
    $process = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "*$processFilename*" }
    if ($process) {
        Write-Output "  > Process exists, attempting to close gracefully"
        # try gracefully first
        $process.CloseMainWindow() | Out-Null
        # kill after five seconds
        Start-Sleep 1
        Write-Output "  > Could not close gracefully, forcing"
        if (!$process.HasExited) {
            $process | Stop-Process -Force
        }
    }
    Remove-Variable process
    if ($_.ContainsKey('before')) {
        Invoke-Expression $_['before']
    }
    & $compiler /base $binFile /in $_.in /out $_.out /icon $_.icon | Out-Null
    if ($_.ContainsKey('after')) {
        Invoke-Expression $_['after']
    }
}

