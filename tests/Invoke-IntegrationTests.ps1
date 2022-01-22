# Make sure Pester is installed and imported
$ModuleName = "Pester"
if (!(Get-Module | Where-Object {$_.Name -eq $ModuleName})) 
{
  if (Get-Module -ListAvailable | Where-Object {$_.Name -eq $m})
  {
    Import-Module Pester -PassThru
  }
  else 
  {
    Install-Module Pester -Force -ErrorAction "Stop"
    Import-Module Pester -PassThru
  }
}

# Import types
$TypesPaths = Get-ChildItem (Join-Path $PSScriptRoot ".." "src" -Resolve) -Recurse -Include "*.ps1" -Exclude "*-*.ps1", "*.Tests.ps1"
foreach ($TypePath in $TypesPaths)
{
  Write-Host $TypePath
  Import-Module $TypePath.FullName -Force
}

# Set default global variables
$Global:DevonSettings = [PSCustomObject]@{
  LoggerLevel           = [DevonLogLevel]::Trace
  LoggerDirectory       = $null
}

# Set Pester config
$PesterConfig = [PesterConfiguration]::Default
$PesterConfig.Run.Path = Join-path $PSScriptRoot "integration" -Resolve
$PesterConfig.Run.Throw = $true
$PesterConfig.TestResult.Enabled = $true
$PesterConfig.TestResult.OutputPath = Join-Path $PSScriptRoot ".." ".." "out" "integration" "results.xml"
$PesterConfig.TestResult.TestSuiteName = "Integration Tests"

# Run pester
Invoke-Pester -Configuration $PesterConfig