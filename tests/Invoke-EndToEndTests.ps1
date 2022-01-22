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

# Import module
Import-Module (Join-Path $PSScriptRoot ".." "src" "Devon.psd1" -Resolve) -Force

# Set Pester config
$PesterConfig = [PesterConfiguration]::Default
$PesterConfig.Run.Path = Join-path $PSScriptRoot "e2e" -Resolve
$PesterConfig.Run.Throw = $true
$PesterConfig.TestResult.Enabled = $true
$PesterConfig.TestResult.OutputPath = Join-Path $PSScriptRoot ".." ".." "out" "e2e" "results.xml"
$PesterConfig.TestResult.TestSuiteName = "E2E Tests"

# Run pester
Invoke-Pester -Configuration $PesterConfig