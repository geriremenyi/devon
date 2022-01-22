# Make sure Pester is installed and imported
. $PSScriptRoot/../Install-Pester.ps1

# Import types
$TypesDefined = Get-ChildItem (Join-Path $PSScriptRoot ".." ".." "src" -Resolve) -Recurse -Include "*.ps1" -Exclude "*-*.ps1", "*.Tests.ps1"
foreach ($Type in $TypesDefined)
{
  Import-Module $Type.FullName -Force
}

# Set default global variables
$Global:ProductivityScriptsSettings = [PSCustomObject]@{
  LoggerLevel           = [LogLevel]::Trace
  LoggerDirectory       = $null
}

# Collect data for Pester config
$UnitTestsFolders = (Get-ChildItem (Resolve-Path $PSScriptRoot) -Directory).FullName
$SourceFolders =  (Get-ChildItem (Join-Path $PSScriptRoot ".." ".." "src" -Resolve) -Directory).FullName
$TargetCoveragePercentage = 100

# Set Pester config
$PesterConfig = [PesterConfiguration]::Default
$PesterConfig.Run.Path = $UnitTestsFolders
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
    "The target coverage $($TargetCoveragePercentage.ToString("#.##"))% wasn't reached. " `
    + "Unit tests only cover $($PesterResults.CodeCoverage.CoveragePercent.ToString("#.##"))% of the source code."
}