Function Export-ADMXTemplatesFromMSI {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_})]
        [ValidateScript({$_.EndsWith(".msi")})]
        [String]$MsiPath,
        [Parameter(Mandatory,Position=1)]
        [String]$TargetDirectory
    )

    begin{
    }

    process{
        try {
            [string]$MsiPath = Resolve-Path $MsiPath | select -ExpandProperty Path
        }
        catch {
            throw $_
        }
        try {
            [string]$TargetDirectory = Resolve-Path $TargetDirectory | select -ExpandProperty Path
        }
        catch {
            throw $_
        }
        
        $ADMXInstallArgs = @(
            "/a"
            "`"$MSIPath`""
            "/qn"
            "TARGETDIR=`"$TargetDirectory`""
        )

        Write-Verbose "Extracting the contents of $MsiPath to $TargetDirectory"
        $Extract = Start-Process "msiexec.exe" -ArgumentList $ADMXInstallArgs -Wait -NoNewWindow -PassThru

        $CatchExitCode = switch ($Extract.ExitCode) {
            0 { "Success" }
            1 { "Failed" }
            Default { "Unknown"}
        }
        [PSCustomObject]@{
            Destination = "$TargetDirectory" + "PolicyDefinitions"
            Result = $CatchExitCode
        }
    }

    end{
    }
}