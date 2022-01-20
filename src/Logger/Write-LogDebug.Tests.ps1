BeforeAll {
  # Dependendencies
  . $PSScriptRoot/Write-Log.ps1

  # Mock dependencies
  Mock Write-Log -Verifiable

  # Script under test
  . $PSScriptRoot/Write-LogDebug.ps1
}

Describe "Write-LogDebug" {
  It "writes logs with level 'Debug' when called" {
    # Arrange
    $MessageToWrite = "This is a test message"
    
    # Act
    Write-LogDebug $MessageToWrite

    # Assert
    Should -Invoke -CommandName Write-Log -Times 1 -ParameterFilter { $Level -eq ([LogLevel]::Debug) -and $Message -eq $MessageToWrite }
  }
}