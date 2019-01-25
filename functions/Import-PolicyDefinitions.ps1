function Import-PolicyDefinitions {
    <#
    .SYNOPSIS
    Imports ADMX Policy definition files into the central store.
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Destination
    Destination of files. Defaults to central store
    
    .PARAMETER FromMSI
    Extracts the ADMX files from the MSI and stores them in the user temp.
    
    .PARAMETER MSIPath
    Path to MSI
    
    .PARAMETER Source
    Path to Source files.
    
    .EXAMPLE
    Import-PolicyDefinitions -FromMSI -MSIPath '.\Administrative Templates (.admx) for Windows 10 October 2018 Update.msi' -Verbose
    
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
    }
    
    end {
    }
}