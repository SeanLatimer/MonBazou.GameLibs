param ($version)
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 1520370"
$dlls = "Assembly-CSharp.dll", "Assembly-CSharp-firstpass.dll", "HSVPicker.dll"
$output = Join-Path $PSScriptRoot "ref"

while ($version -eq $null) {
  $version = read-host -Prompt "Please enter a game version"
}

try {
  $monBazouPath = Get-ItemPropertyValue $registryPath "InstallLocation" -ErrorAction Stop
} catch {
  Write-Host "Mon Bazou could not be detected. Please install it via Steam and try again."
  exit 1
}

Write-Host "Mon Bazou detected at $monBazouPath"
pushd $monBazouPath
$dllPaths = @()
$dlls | % {
  $dllPaths += Join-Path "Mon Bazou_Data\Managed" $_
}

if ((Get-Command "refasmer" -ErrorAction SilentlyContinue) -eq $null)
{
  Write-Host "Unable to find refasmer.exe. Please install it by running the following command:`n`n dotnet tool install -g JetBrains.Refasmer.CliTool"
  popd
  exit 1
}

refasmer --all -v -O $output -c $dllPaths

popd

Set-Content -Path 'version.txt' -Value $version