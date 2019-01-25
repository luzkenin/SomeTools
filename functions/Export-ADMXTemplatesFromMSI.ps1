Function Export-ADMXTemplates {
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
        if(-not($TargetDirectory)) {
            $currentDir = [System.IO.Path]::GetDirectoryName($MsiPath)
            Write-Warning "A target directory is not specified. The contents of the MSI will be extracted to the location, $currentDir\Temp"
            $TargetDirectory = Join-Path $currentDir "Temp"
        }
    
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
        
        Write-Verbose "Extracting the contents of $MsiPath to $TargetDirectory"
        $ADMXInstallArgs = @(
            "/a"
            "`"$MSIPath`""
            "/qn"
            "TARGETDIR=`"$TargetDirectory`""
        )

        Start-Process "msiexec.exe" -ArgumentList $ADMXInstallArgs -Wait -NoNewWindow
    }

    end{
    }
}