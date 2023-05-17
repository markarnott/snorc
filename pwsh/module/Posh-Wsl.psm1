$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction Ignore )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction Ignore )

# Dot source the files
Foreach($Function in @($Public + $Private))
{
    Try { . $Function.fullname }
    Catch
    {
        Write-Error -Message "Failed to import function $($Function.fullname): $_"
    }
}