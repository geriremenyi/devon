BeforeAll {
  # Dependendencies
  . $PSScriptRoot/../../../src/Logger/Write-DevonLog.ps1

  # Mock dependencies
  Mock Write-DevonLog -Verifiable

  # Script under test
  . $PSScriptRoot/../../../src/Logger/Write-DevonLogError.ps1
}

Describe "Write-DevonLogError" -Tag "Unit" {
  It "writes logs with level 'Error' when called" {
    # Arrange
    $MessageToWrite = "This is a test message"
    
    # Act
    Write-DevonLogError $MessageToWrite

    # Assert
    Should -Invoke -CommandName Write-DevonLog -Times 1 -ParameterFilter { $Level -eq ([DevonLogLevel]::Error) -and $Message -eq $MessageToWrite }
  }
}