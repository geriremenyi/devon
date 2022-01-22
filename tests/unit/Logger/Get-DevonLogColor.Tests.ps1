BeforeAll {
  # Script under test
  . $PSScriptRoot/../../../src/Logger/Get-DevonLogColor.ps1
}

Describe "Get-DevonLogColor" -Tag "Unit" {
  It "throws when invalid level is passed" {
    # Arrange
    $Level = "This is a made up log level"
    
    # Act
    # Assert
    { Get-DevonLogColor $Level } | Should -Throw
  }

  It "returns 'Cyan' when 'Trace' level used" {
    # Arrange
    $Level = [DevonLogLevel]::Trace
    
    # Act
    $LogColor = Get-DevonLogColor $Level

    # Assert
    $LogColor | Should -Be "Cyan"
  }

  It "returns 'Yellow' when 'Debug' level used" {
    # Arrange
    $Level = [DevonLogLevel]::Debug
    
    # Act
    $LogColor = Get-DevonLogColor $Level

    # Assert
    $LogColor | Should -Be "Yellow"
  }

  It "returns 'White' when 'Info' level used" {
    # Arrange
    $Level = [DevonLogLevel]::Info
    
    # Act
    $LogColor = Get-DevonLogColor $Level

    # Assert
    $LogColor | Should -Be "White"
  }

  It "returns 'DarkYellow' when 'Warning' level used" {
    # Arrange
    $Level = [DevonLogLevel]::Warning
    
    # Act
    $LogColor = Get-DevonLogColor $Level

    # Assert
    $LogColor | Should -Be "DarkYellow"
  }

  It "returns 'Red' when 'Error' level used" {
    # Arrange
    $Level = [DevonLogLevel]::Error
    
    # Act
    $LogColor = Get-DevonLogColor $Level

    # Assert
    $LogColor | Should -Be "Red"
  }

  It "returns 'DarkRed' when 'Fatal' level used" {
    # Arrange
    $Level = [DevonLogLevel]::Fatal
    
    # Act
    $LogColor = Get-DevonLogColor $Level

    # Assert
    $LogColor | Should -Be "DarkRed"
  }

  It "returns 'White' when 'Off' level used" {
    # Arrange
    $Level = [DevonLogLevel]::Off
    
    # Act
    $LogColor = Get-DevonLogColor $Level

    # Assert
    $LogColor | Should -Be "White"
  }
}