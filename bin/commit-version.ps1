# Save and clear the prompt (better clarity for echoing)
$compiler = $Env:AHK_COMPILER;
$binFile = $Env:AHK2_COMPILER_BINFILE;

if ($args.count -ne 2) (
  Write-Output "Usage: commit-version.ps1 <versionNumber> <commitMessage>"
)

$currentBranch = git branch --show-current

if ($currentBranch -ne "main") {
  Write-Output "Current branch is '$currentBranch', please merge all changes into the main branch before committing a version."
  exit
}

& $PSScriptRoot\build.ps1 $args[0]

git add .
git commit -m $args[1]
git tag -a %~1 -m $args[1]
git push
git push origin $args[0]