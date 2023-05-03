<# .SYNOPSIS
    Return the name of the default wsl distribution
#>
Function Get-DefaultDistro {
    $DefaultDistroId = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss\").DefaultDistribution
    $DefaultDistroName = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss\$DefaultDistroId").DistributionName
    Return $DefaultDistroName
}