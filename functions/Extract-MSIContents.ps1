Function Export-MsiContents
{
       [CmdletBinding()]
       param
       (
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_})]
        [ValidateScript({$_.EndsWith(".msi")})]
        [String]$MsiPath,
        [Parameter(Position=1)]
        [String]$TargetDirectory
       )

    if(-not($TargetDirectory))
    {
        $currentDir = [System.IO.Path]::GetDirectoryName($MsiPath)
        Write-Warning "A target directory is not specified. The contents of the MSI will be extracted to the location, $currentDir\Temp"
        $TargetDirectory = Join-Path $currentDir "Temp"
    }

    $MsiPath = Resolve-Path $MsiPath
    Write-Verbose "Extracting the contents of $MsiPath to $TargetDirectory"
    Start-Process "MSIEXEC" -ArgumentList "/a $MsiPath /qn TARGETDIR=$TargetDirectory" -Wait -NoNewWindow
}