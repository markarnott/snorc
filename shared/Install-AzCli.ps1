<#
.SYNOPSIS
A helper script that installs the az cli in a WSL instance
#>
param(
    [string]
    $WslDistroName
)

Push-Location $PSScriptRoot

# convert line endings from Windows style to Unix style.  
# This is only needed if .gitconfig autocrlf=true, but that is the default.
(Get-Content -Raw ".\get-azcli.sh") -Replace "`r`n","`n" | Set-Content -NoNewline ".\get-azcli.sh"
wsl.exe -d $Distro -e ./get-azcli.sh

Pop-Location