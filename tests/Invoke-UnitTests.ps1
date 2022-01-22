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

# Collect data for Pester config
$SourceFolders = (Get-ChildItem (Join-Path $PSScriptRoot ".." "src" -Resolve) -Directory).FullName
$TargetCoveragePercentage = 100

# Set Pester config
$PesterConfig = [PesterConfiguration]::Default
$PesterConfig.Run.Path = (Join-path $PSScriptRoot "unit" -Resolve)
$PesterConfig.Run.Throw = $true
$PesterConfig.Run.PassThru = $true
$PesterConfig.CodeCoverage.Enabled = $true
$PesterConfig.CodeCoverage.Path = $SourceFolders
$PesterConfig.CodeCoverage.CoveragePercentTarget = $TargetCoveragePercentage
$PesterConfig.CodeCoverage.OutputPath = Join-Path $PSScriptRoot ".." ".." "out" "unit" "coverage.xml"
$PesterConfig.TestResult.Enabled = $true
$PesterConfig.TestResult.OutputPath = Join-Path $PSScriptRoot ".." ".." "out" "unit" "results.xml"
$PesterConfig.TestResult.TestSuiteName = "Unit Tests"

# Run pester
$PesterResults = Invoke-Pester -Configuration $PesterConfig

# Throw on low coverage
if ($PesterResults.CodeCoverage.CoveragePercent -lt $TargetCoveragePercentage)
{
  throw `
    "The target unit test coverage $($TargetCoveragePercentage.ToString("#.##"))% wasn't reached. " `
    + "Unit tests only cover $($PesterResults.CodeCoverage.CoveragePercent.ToString("#.##"))% of the source code."
}