$version = Get-Content $(Join-Path $PSScriptRoot "version.txt") -First 1
nuget pack -BasePath "ref/" -Version $version