BeforeAll {
  # Dependendencies
  . $PSScriptRoot/../../../src/Logger/Write-DevonLog.ps1

  # Mock dependencies
  Mock Write-DevonLog -Verifiable

  # Script under test
  . $PSScriptRoot/../../../src/Logger/Write-DevonLogFatal.ps1
}

Describe "Write-DevonLogFatal" -Tag "Unit" {
  It "writes logs with level 'Fatal' when called" {
    # Arrange
    $MessageToWrite = "This is a test message"
    
    # Act
    Write-DevonLogFatal $MessageToWrite

    # Assert
    Should -Invoke -CommandName Write-DevonLog -Times 1 -ParameterFilter { $Level -eq ([DevonLogLevel]::Fatal) -and $Message -eq $MessageToWrite }
  }
}