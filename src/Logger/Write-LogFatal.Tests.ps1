BeforeAll {
  # Dependendencies
  . $PSScriptRoot/Write-Log.ps1

  # Mock dependencies
  Mock Write-Log -Verifiable

  # Script under test
  . $PSScriptRoot/Write-LogFatal.ps1
}

Describe "Write-LogFatal" {
  It "writes logs with level 'Fatal' when called" {
    # Arrange
    $MessageToWrite = "This is a test message"
    
    # Act
    Write-LogFatal $MessageToWrite

    # Assert
    Should -Invoke -CommandName Write-Log -Times 1 -ParameterFilter { $Level -eq ([LogLevel]::Fatal) -and $Message -eq $MessageToWrite }
  }
}