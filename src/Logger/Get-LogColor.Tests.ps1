BeforeAll {
  # Dependendencies

  # Mock dependencies

  # Script under test
  . $PSScriptRoot/Get-LogColor.ps1
}

Describe "Get-LogColor" {
  It "throws when invalid level is passed" {
    # Arrange
    $Level = "This is a made up log level"
    
    # Act
    # Assert
    { Get-LogColor $Level } | Should -Throw
  }

  It "returns 'Cyan' when 'Trace' level used" {
    # Arrange
    $Level = [LogLevel]::Trace
    
    # Act
    $LogColor = Get-LogColor $Level

    # Assert
    $LogColor | Should -Be "Cyan"
  }

  It "returns 'Yellow' when 'Debug' level used" {
    # Arrange
    $Level = [LogLevel]::Debug
    
    # Act
    $LogColor = Get-LogColor $Level

    # Assert
    $LogColor | Should -Be "Yellow"
  }

  It "returns 'White' when 'Info' level used" {
    # Arrange
    $Level = [LogLevel]::Info
    
    # Act
    $LogColor = Get-LogColor $Level

    # Assert
    $LogColor | Should -Be "White"
  }

  It "returns 'DarkYellow' when 'Warning' level used" {
    # Arrange
    $Level = [LogLevel]::Warning
    
    # Act
    $LogColor = Get-LogColor $Level

    # Assert
    $LogColor | Should -Be "DarkYellow"
  }

  It "returns 'Red' when 'Error' level used" {
    # Arrange
    $Level = [LogLevel]::Error
    
    # Act
    $LogColor = Get-LogColor $Level

    # Assert
    $LogColor | Should -Be "Red"
  }

  It "returns 'DarkRed' when 'Fatal' level used" {
    # Arrange
    $Level = [LogLevel]::Fatal
    
    # Act
    $LogColor = Get-LogColor $Level

    # Assert
    $LogColor | Should -Be "DarkRed"
  }

  It "returns 'White' when 'Off' level used" {
    # Arrange
    $Level = [LogLevel]::Off
    
    # Act
    $LogColor = Get-LogColor $Level

    # Assert
    $LogColor | Should -Be "White"
  }
}