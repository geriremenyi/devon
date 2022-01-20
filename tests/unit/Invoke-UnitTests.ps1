$PesterConfig = [PesterConfiguration]::Default
$PesterConfig.Run.Path = Join-Path $PSScriptRoot ".." ".." "src" -Resolve
$PesterConfig.CodeCoverage.Enabled = $true
$PesterConfig.CodeCoverage.CoveragePercentTarget = 100
$PesterConfig.CodeCoverage.OutputPath = Join-Path $PSScriptRoot ".." ".." "out" "coverage.xml"
$PesterConfig.TestResult.Enabled = $true
$PesterConfig.TestResult.OutputPath = Join-Path $PSScriptRoot ".." ".." "out" "testResults.xml"

Invoke-Pester -Configuration $PesterConfig