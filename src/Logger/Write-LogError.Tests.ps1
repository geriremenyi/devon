BeforeAll {
  # Dependendencies
  . $PSScriptRoot/Write-Log.ps1

  # Mock dependencies
  Mock Write-Log -Verifiable

  # Script under test
  . $PSScriptRoot/Write-LogError.ps1
}

Describe "Write-LogError" {
  It "writes logs with level 'Error' when called" {
    # Arrange
    $MessageToWrite = "This is a test message"
    
    # Act
    Write-LogError $MessageToWrite

    # Assert
    Should -Invoke -CommandName Write-Log -Times 1 -ParameterFilter { $Level -eq ([LogLevel]::Error) -and $Message -eq $MessageToWrite }
  }
}