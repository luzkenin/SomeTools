function Import-PolicyDefinitions {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        # Parameter help description
        [Parameter()]
        [ValidateScript({Test-Path $_})]
        [string]$Destination = ".\testing", #"\\$env:USERDNSDOMAIN\sysvol\$env:USERDNSDOMAIN\Policies\",
        # Parameter help description
        [Parameter(ParameterSetName = 'MSI')]
        [switch]$FromMSI,
        # Parameter help description
        [Parameter(ParameterSetName = 'MSI')]
        [string]$MSIPath,
        # Parameter help description
        [Parameter(ParameterSetName = 'FromSource')]
        [string]$Source
    )
    
    begin {
    }
    
    process {
        if($PSCmdlet.ShouldProcess("ShouldProcess?") {
            if($FromMSI) {
                Export-ADMXTemplatesFromMSI -MSIPath $MSIPath -TargetDirectory $env:TEMP
            }
            else {

            }
        }

        get-childitem "\\$env:USERDNSDOMAIN\sysvol\$env:USERDNSDOMAIN\Policies\"
    }
    
    end {
    }
}