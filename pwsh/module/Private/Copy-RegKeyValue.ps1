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
        $ValueName
        )

        $SourceKey = Get-Item -Path $FromKey
        If($null -eq $SourceKey){
            Write-Warning "Registry Key $FromKey not found"
            Return
        }
        $ValueType = $SourceKey.GetValueKind($ValueName)
        If($null -eq $ValueType) {
            Write-Warning "Could not copy Registry Value $ValueName.`n$ValueName not found at $FromKey"
            Return
        }
        $ValueData = $SourceKey.GetValue($ValueName)

        Set-ItemProperty -Path $ToKey -Name $ValueName -Value $ValueData -Type $ValueType
}