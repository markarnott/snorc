@{

RootModule = 'Posh-Wsl.psm1'
ModuleVersion = '0.0.1'
GUID = 'dfe5f7f2-507e-47a2-a72b-4be4bcbad5dc'
Author = 'Mark Arnott'
Copyright = '(c) 2023 Mark Arnott. All rights reserved.'
Description = 'Helper functions for managing Windows Subsystem for Linux instances'
CompatiblePSEditions = @('Desktop','Core')
PowerShellVersion = '5.1'
DotNetFrameworkVersion = '4.7.1'

# Assemblies that must be loaded prior to importing this module
RequiredAssemblies = @()

# Format files (.ps1xml) to be loaded when importing this module
#FormatsToProcess = 'Posh-Wsl.Format.ps1xml'

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    'Copy-DistroSettings'
    'Get-DefaultDistro'
    'Get-Distros'
    'Stop-Distro'
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()
    
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'WSL','Linux'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/markarnott/snorc/blob/main/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/markarnott/snorc/pwsh'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = @'
## 0.0.1 (2023-05-16)
'@
    }
    
}
}
    