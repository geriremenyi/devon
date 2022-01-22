BeforeAll {
  # Dependendencies
  . $PSScriptRoot/../../../src/Logger/Write-DevonLog.ps1

  # Mock dependencies
  Mock Write-DevonLog -Verifiable

  # Script under test
  . $PSScriptRoot/../../../src/Logger/Write-DevonLogDebug.ps1
}

Describe "Write-DevonLogDebug" -Tag "Unit" {
  It "writes logs with level 'Debug' when called" {
    # Arrange
    $MessageToWrite = "This is a test message"
    
    # Act
    Write-DevonLogDebug $MessageToWrite

    # Assert
    Should -Invoke -CommandName Write-DevonLog -Times 1 -ParameterFilter { $Level -eq ([DevonLogLevel]::Debug) -and $Message -eq $MessageToWrite }
  }
}