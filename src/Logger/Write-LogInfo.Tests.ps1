BeforeAll {
  # Dependendencies
  . $PSScriptRoot/Write-Log.ps1

  # Mock dependencies
  Mock Write-Log -Verifiable

  # Script under test
  . $PSScriptRoot/Write-LogInfo.ps1
}

Describe "Write-LogInfo" {
  It "writes logs with level 'Info' when called" {
    # Arrange
    $MessageToWrite = "This is a test message"
    
    # Act
    Write-LogInfo $MessageToWrite

    # Assert
    Should -Invoke -CommandName Write-Log -Times 1 -ParameterFilter { $Level -eq ([LogLevel]::Info) -and $Message -eq $MessageToWrite }
  }
}