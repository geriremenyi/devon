BeforeAll {
  # Dependendencies
  . $PSScriptRoot/../../../src/Logger/Write-Log.ps1

  # Mock dependencies
  Mock Write-Log -Verifiable

  # Script under test
  . $PSScriptRoot/../../../src/Logger/Write-LogWarning.ps1
}

Describe "Write-LogWarning" -Tag "Unit" {
  It "writes logs with level 'Warning' when called" {
    # Arrange
    $MessageToWrite = "This is a test message"
    
    # Act
    Write-LogWarning $MessageToWrite

    # Assert
    Should -Invoke -CommandName Write-Log -Times 1 -ParameterFilter { $Level -eq ([LogLevel]::Warning) -and $Message -eq $MessageToWrite }
  }
}