<# 
    .SYNOPSIS
    Copy a Property (AKA Value) from one registry key to another
#>
Function Copy-RegKeyValue{
    param(
        [Parameter(Mandatory)][string]
        $FromKey,
        [Parameter(Mandatory)][string]
        $ToKey,
        [Parameter(Mandatory)][string]
        $ValueName,
        [Switch]
        $Silent
        )

        $SourceKey = Get-Item -Path $FromKey
        If($null -eq $SourceKey){
            Write-Warning "Registry Key $FromKey not found"
            Return
        }
        $ValueNames = $SourceKey.GetValueNames()
        If($ValueNames -notcontains $ValueName) {
            If(-not $Silent) {
                Write-Warning "Could not copy Registry Value $ValueName.`n$ValueName not found at $FromKey"
            }
            Return
        }
        $ValueType = $SourceKey.GetValueKind($ValueName)
        $ValueData = $SourceKey.GetValue($ValueName)

        Set-ItemProperty -Path $ToKey -Name $ValueName -Value $ValueData -Type $ValueType
}