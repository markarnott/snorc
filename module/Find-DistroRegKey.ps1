<# 
    .SYNOPSIS
    Return the path to the registry key for a wsl distribution
#>
Function Find-DistroRegKey{
    param([Parameter(Mandatory)][string]$DistroName)

    ForEach($RegKey in (Get-ChildItem -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss\")){
        $RegValues = Get-ItemProperty -Path "Registry::$($RegKey.Name)" -Name "DistributionName"
        If($RegValues.DistributionName -eq $DistroName) {
            Return $RegValues.PSPath
        }
    }
}