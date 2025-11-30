@{
    RootModule        = 'EndpointEngineeringTools.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = '00000000-0000-0000-0000-000000000001'
    Author            = 'Your Name'
    CompanyName       = 'YourCompany'
    Description       = 'Sample PowerShell module for endpoint engineering automation.'
    PowerShellVersion = '5.1'

    FunctionsToExport = @(
        'Get-EndpointInventory',
        'Set-EndpointSecurityBaseline'
    )

    PrivateData = @{
        PSData = @{
            Tags       = @('Intune','Endpoint','MDM','Automation')
            ProjectUri = 'https://github.com/yourusername/client-platform-engineering-samples'
        }
    }
}
