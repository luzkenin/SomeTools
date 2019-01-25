function Import-PolicyDefinitions {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Destination
    Parameter description
    
    .PARAMETER FromMSI
    Parameter description
    
    .PARAMETER MSIPath
    Parameter description
    
    .PARAMETER Source
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        # Parameter help description
        [Parameter()]
        [ValidateScript({Test-Path $_})]
        [string]$Destination = "\\$env:USERDNSDOMAIN\sysvol\$env:USERDNSDOMAIN\Policies\",
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
        [string]$Destination = Resolve-Path $Destination | select -ExpandProperty Path
        if($FromMSI) {
            [string]$MsiPath = Resolve-Path $MsiPath | select -ExpandProperty Path
            $Export = Export-ADMXTemplatesFromMSI -MSIPath $MSIPath -TargetDirectory $env:TEMP
            if($Export.Result -eq "Success") {
                if($null -eq (Test-Path -Path $Destination\PolicyDefinitions)) {
                    try {
                        New-Item -Path $Destination -Name "PolicyDefinitions"-Force
                    }
                    catch {
                        throw $_
                    }
                    Write-Verbose "Copying Policy Definitions to $Destination"
                    if($PSCmdlet.ShouldProcess("Copy","$Destiniation")) {
                        Copy-Item -Path "$env:TEMP\PolicyDefinitions" -Destination $Destination -Recurse
                    }
                }
                else {
                    Write-Verbose "Copying Policy Definitions to $Destination"
                    if($PSCmdlet.ShouldProcess("Copy","$Destiniation")) {
                        Copy-Item -Path "$env:TEMP\PolicyDefinitions" -Destination $Destination -Recurse
                    }
                }
            }
            
            #then copy from temp to policydef
        }
        else {
            if($null -eq (Test-Path -Path $Destination\PolicyDefinitions)) {
                try {
                    New-Item -Path $Destination -Name "PolicyDefinitions"-Force
                }
                catch {
                    throw $_
                }
                Write-Verbose "Copying Policy Definitions to $Destination"
                if($PSCmdlet.ShouldProcess("Copy","$Destiniation")) {
                    Copy-Item -Path "$Source" -Destination $Destination -Recurse
                }
            }
            else {
                Write-Verbose "Copying Policy Definitions to $Destination"
                if($PSCmdlet.ShouldProcess("Copy","$Destiniation")) {
                    Copy-Item -Path "$Source" -Destination $Destination -Recurse
                }
            }
        }
        

        #get-childitem "\\$env:USERDNSDOMAIN\sysvol\$env:USERDNSDOMAIN\Policies\"
    }
    
    end {
    }
}