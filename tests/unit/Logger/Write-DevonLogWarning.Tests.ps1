BeforeAll {
  # Dependendencies
  . $PSScriptRoot/../../../src/Logger/Write-DevonLog.ps1

  # Mock dependencies
  Mock Write-DevonLog -Verifiable

  # Script under test
  . $PSScriptRoot/../../../src/Logger/Write-DevonLogWarning.ps1
}

Describe "Write-DevonLogWarning" -Tag "Unit" {
  It "writes logs with level 'Warning' when called" {
    # Arrange
    $MessageToWrite = "This is a test message"
    
    # Act
    Write-DevonLogWarning $MessageToWrite

    # Assert
    Should -Invoke -CommandName Write-DevonLog -Times 1 -ParameterFilter { $Level -eq ([DevonLogLevel]::Warning) -and $Message -eq $MessageToWrite }
  }
}