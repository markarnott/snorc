<#
#>
param([string]$WslDistroName)

Push-Location $PSScriptRoot

If($null -eq $WslDistroName) {
    Import-Module .\WslUtilityFunctions.psm1

    $WslDistroName = Get-DefaultDistro
}

# convert line endings from Windows style to Unix style.  
#This is only needed if .gitconfig autocrlf=true, but that is the default.
(Get-Content -Raw ".\get-azcli.sh") -Replace "`r`n","`n" | Set-Content -NoNewline ".\get-azcli.sh"
wsl.exe -d $Distro -e ./get-azcli.sh

Pop-Location