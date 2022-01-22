BeforeAll {
  # Dependendencies
  . $PSScriptRoot/../../../src/Logger/Write-DevonLog.ps1

  # Mock dependencies
  Mock Write-DevonLog -Verifiable

  # Script under test
  . $PSScriptRoot/../../../src/Logger/Write-DevonLogInfo.ps1
}

Describe "Write-DevonLogInfo" -Tag "Unit" {
  It "writes logs with level 'Info' when called" {
    # Arrange
    $MessageToWrite = "This is a test message"
    
    # Act
    Write-DevonLogInfo $MessageToWrite

    # Assert
    Should -Invoke -CommandName Write-DevonLog -Times 1 -ParameterFilter { $Level -eq ([DevonLogLevel]::Info) -and $Message -eq $MessageToWrite }
  }
}