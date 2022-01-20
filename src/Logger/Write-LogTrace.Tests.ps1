BeforeAll {
  # Dependendencies
  . $PSScriptRoot/Write-Log.ps1

  # Mock dependencies
  Mock Write-Log -Verifiable

  # Script under test
  . $PSScriptRoot/Write-LogTrace.ps1
}

Describe "Write-LogTrace" {
  It "writes logs with verbose when called" {
    # Arrange
    $MessageToWrite = "This is a test message"
    
    # Act
    Write-LogTrace $MessageToWrite

    # Assert
    Should -Invoke -CommandName Write-Log -Times 1 -ParameterFilter { $Level -eq ([LogLevel]::Trace) -and $Message -eq $MessageToWrite }
  }
}