<#
#>
param([string]$WslDistroName)

Push-Location $PSScriptRoot

If($null -eq $WslDistroName) {
    Import-Module .\WslUtilityFunctions.psm1

    $WslDistroName = Get-DefaultDistro
}

# convert line endings from Windows style to Unix style
(Get-Content -Raw ".\get-azcli.sh") -Replace "`r`n","`n" | Set-Content -NoNewline ".\get-podman.sh"
wsl.exe -d $Distro -e ./get-azcli.sh

Pop-Location