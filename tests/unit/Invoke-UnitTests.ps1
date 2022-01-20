# Import types
Import-Module (Join-Path $PSScriptRoot ".." ".." "src" "Logger" "LogLevel.ps1" -Resolve) -Force

# Set default global variables
$Global:ProductivityScriptsSettings = [PSCustomObject]@{
  LoggerLevel           = [LogLevel]::Trace
  LoggerDirectory       = $null
}

# Set Pester config
$PesterConfig = [PesterConfiguration]::Default
$PesterConfig.Run.Path = Join-Path $PSScriptRoot ".." ".." "src" -Resolve
$PesterConfig.CodeCoverage.Enabled = $true
$PesterConfig.CodeCoverage.CoveragePercentTarget = 100
$PesterConfig.CodeCoverage.OutputPath = Join-Path $PSScriptRoot ".." ".." "out" "coverage.xml"
$PesterConfig.TestResult.Enabled = $true
$PesterConfig.TestResult.OutputPath = Join-Path $PSScriptRoot ".." ".." "out" "testResults.xml"

# Run pester
Invoke-Pester -Configuration $PesterConfig