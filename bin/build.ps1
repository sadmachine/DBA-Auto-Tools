# Set our parameters
Param(
    [string]$BuildConfigPath = "$pwd\.build.ps1"
)

# Set some default environmen variables
$compiler = $Env:AHK_COMPILER;
$binFile = $Env:AHK2_COMPILER_BINFILE;

# Do some config setup

if (-not(Test-Path $buildConfigPath)) {
    Write-Output "Please supply a valid config path, found: `n`r`t$buildConfigPath"
    exit 1
}

if ($args[0]) {
    $currentVersion = $args[0];
}
else {
    $currentVersion = git describe --tags --abbrev=0
    $currentVersion = $currentVersion + ".beta"
}

$settingsPath = Join-Path -Path $pwd -ChildPath "dist\app\settings.ini"

inifile $settingsPath [version] current=$currentVersion

# Import out build config (once necessary variables are available)
. $buildConfigPath

# get Firefox process
$buildRules | ForEach-Object {
    $processFilename = $_['process']
    Write-Output ('#' * ($Host.UI.RawUI.WindowSize.Width - 10))
    Write-Output "Check if process exists: $processFilename"
    $process = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "*$processFilename*" }
    if ($process) {
        Write-Output "`t- Process exists, attempting to close gracefully"
        # try gracefully first
        $process.CloseMainWindow() | Out-Null
        # kill after five seconds
        Start-Sleep 1
        Write-Output "`t- Could not close gracefully, forcing"
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

