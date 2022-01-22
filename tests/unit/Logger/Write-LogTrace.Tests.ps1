BeforeAll {
  # Dependendencies
  . $PSScriptRoot/../../../src/Logger/Write-Log.ps1

  # Mock dependencies
  Mock Write-Log -Verifiable

  # Script under test
  . $PSScriptRoot/../../../src/Logger/Write-LogTrace.ps1
}

Describe "Write-LogTrace" -Tag "Unit" {
  It "writes logs with verbose when called" {
    # Arrange
    $MessageToWrite = "This is a test message"
    
    # Act
    Write-LogTrace $MessageToWrite

    # Assert
    Should -Invoke -CommandName Write-Log -Times 1 -ParameterFilter { $Level -eq ([LogLevel]::Trace) -and $Message -eq $MessageToWrite }
  }
}