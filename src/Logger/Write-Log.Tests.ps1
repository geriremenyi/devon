BeforeAll {
  # Backup global variables
  $Global:ProductivityScriptsSettingsBackup = $Global:ProductivityScriptsSettings.PsObject.Copy()
  
  # Dependendencies
  . $PSScriptRoot/Get-LogColor.ps1

  # Mock dependencies
  Mock Get-Date -Verifiable -ParameterFilter { $Format -eq 'yyyy-MM-dd HH:mm:ss.ff' }
  Mock Get-LogColor -Verifiable
  Mock Write-Host -Verifiable
  Mock Test-Path -Verifiable
  Mock Join-Path -Verifiable
  Mock New-Item -Verifiable
  Mock Add-Content -Verifiable

  # Script under test
  . $PSScriptRoot/Write-Log.ps1
}

Describe "Write-Log" {
  It "should skip logging if level set is lower severity than message" {
    # Arrange
    $Global:ProductivityScriptsSettings.LoggerLevel = ([LogLevel]::Error)
    $Level = ([LogLevel]::Warning)
    $Message = "This is a test message"
    
    # Act
    Write-Log -Level $Level -Message $Message

    # Assert
    Should -Invoke -CommandName Get-Date -Times 0
  }

  It "should skip logging if level set is lower severity than message" {
    # Arrange
    $Global:ProductivityScriptsSettings.LoggerLevel = ([LogLevel]::Error)
    $Level = ([LogLevel]::Warning)
    $Message = "This is a test message"
    
    # Act
    Write-Log -Level $Level -Message $Message

    # Assert
    Should -Invoke -CommandName Get-Date -ParameterFilter { $Format -eq 'yyyy-MM-dd HH:mm:ss.ff' } -Times 0
    Should -Invoke -CommandName Get-LogColor -Times 0
    Should -Invoke -CommandName Write-Host -Times 0
    Should -Invoke -CommandName Test-Path -Times 0
    Should -Invoke -CommandName Join-Path -Times 0
    Should -Invoke -CommandName New-Item -Times 0
    Should -Invoke -CommandName Add-Content -Times 0
  }

  It "should log to host and skip logging to file if that is disabled" {
    # Arrange
    $Global:ProductivityScriptsSettings.LoggerLevel = ([LogLevel]::Debug)
    $Global:ProductivityScriptsSettings.LoggerDirectory = $null
    $LevelForLog = ([LogLevel]::Info)
    $MessageToWrite = "This is a test message"

    $MockDate = "1994-07-21 07:21:21.21"
    $MockColor = "White"

    Mock Get-Date -Verifiable -ParameterFilter { $Format -eq "yyyy-MM-dd HH:mm:ss.ff" } { return $MockDate }
    Mock Get-LogColor -Verifiable -ParameterFilter { $Level -eq $LevelForLog } { return $MockColor }

    # Act
    Write-Log -Level $LevelForLog -Message $MessageToWrite

    # Assert
    Should -Invoke -CommandName Get-Date -ParameterFilter { $Format -eq 'yyyy-MM-dd HH:mm:ss.ff' } -Times 1
    Should -Invoke -CommandName Get-LogColor -ParameterFilter { $Level -eq $LevelForLog } -Times 1
    Should -Invoke -CommandName Write-Host -ParameterFilter { $object -eq "[$MockDate] $MessageToWrite" -and $ForegroundColor -eq $MockColor } -Times 1
    Should -Invoke -CommandName Test-Path -Times 0
    Should -Invoke -CommandName Join-Path -Times 0
    Should -Invoke -CommandName New-Item -Times 0
    Should -Invoke -CommandName Add-Content -Times 0
  }

  It "should log to host and skip logging to file if logger directory not found" {
    # Arrange
    $Global:ProductivityScriptsSettings.LoggerLevel = ([LogLevel]::Debug)
    $Global:ProductivityScriptsSettings.LoggerDirectory = "test/path"
    $LevelForLog = ([LogLevel]::Info)
    $MessageToWrite = "This is a test message"

    $MockDate = "1994-07-21 07:21:21.21"
    $MockColor = "White"

    Mock Get-Date -Verifiable -ParameterFilter { $Format -eq "yyyy-MM-dd HH:mm:ss.ff" } { return $MockDate }
    Mock Get-LogColor -Verifiable -ParameterFilter { $Level -eq $LevelForLog } { return $MockColor }
    Mock Test-Path -Verifiable -ParameterFilter { $Path -eq $Global:ProductivityScriptsSettings.LoggerDirectory -and $PathType -eq "Container" } { return $false }

    # Act
    Write-Log -Level $LevelForLog -Message $MessageToWrite

    # Assert
    Should -Invoke -CommandName Get-Date -ParameterFilter { $Format -eq 'yyyy-MM-dd HH:mm:ss.ff' } -Times 1
    Should -Invoke -CommandName Get-LogColor -ParameterFilter { $Level -eq $LevelForLog } -Times 1
    Should -Invoke -CommandName Write-Host -ParameterFilter { $object -eq "[$MockDate] $MessageToWrite" -and $ForegroundColor -eq $MockColor } -Times 1
    Should -Invoke -CommandName Test-Path -ParameterFilter { $Path -eq $Global:ProductivityScriptsSettings.LoggerDirectory -and $PathType -eq "Container" } -Times 1
    Should -Invoke -CommandName Join-Path -Times 0
    Should -Invoke -CommandName New-Item -Times 0
    Should -Invoke -CommandName Add-Content -Times 0
  }

  It "should log to host and log to new file if file is not found for the timestamp" {
    # Arrange
    $Global:ProductivityScriptsSettings.LoggerLevel = ([LogLevel]::Debug)
    $Global:ProductivityScriptsSettings.LoggerDirectory = "test/path"
    $LevelForLog = ([LogLevel]::Info)
    $MessageToWrite = "This is a test message"

    $MockDate = "1994-07-21 07:21:21.21"
    $MockColor = "White"
    $MockFullPath = "fake/full/path/to/file.log"

    Mock Get-Date -Verifiable -ParameterFilter { $Format -eq "yyyy-MM-dd HH:mm:ss.ff" } { return $MockDate }
    Mock Get-LogColor -Verifiable -ParameterFilter { $Level -eq $LevelForLog } { return $MockColor }
    Mock Test-Path -Verifiable -ParameterFilter { $Path -eq $Global:ProductivityScriptsSettings.LoggerDirectory -and $PathType -eq "Container" } { return $true }
    Mock Join-Path -Verifiable -ParameterFilter { $Path -eq $Global:ProductivityScriptsSettings.LoggerDirectory -and $ChildPath -eq "1994-07-21.log" } { return $MockFullPath }
    Mock Test-Path -Verifiable -ParameterFilter { $Path -eq $MockFullPath -and $PathType -eq "Leaf" } { return $false }

    # Act
    Write-Log -Level $LevelForLog -Message $MessageToWrite

    # Assert
    Should -Invoke -CommandName Get-Date -ParameterFilter { $Format -eq 'yyyy-MM-dd HH:mm:ss.ff' } -Times 1
    Should -Invoke -CommandName Get-LogColor -ParameterFilter { $Level -eq $LevelForLog } -Times 1
    Should -Invoke -CommandName Write-Host -ParameterFilter { $object -eq "[$MockDate] $MessageToWrite" -and $ForegroundColor -eq $MockColor } -Times 1
    Should -Invoke -CommandName Test-Path -ParameterFilter { $Path -eq $Global:ProductivityScriptsSettings.LoggerDirectory -and $PathType -eq "Container" } -Times 1
    Should -Invoke -CommandName Join-Path { $Path -eq $Global:ProductivityScriptsSettings.LoggerDirectory -and $ChildPath -eq "1994-07-21.log" } -Times 1
    Should -Invoke -CommandName Test-Path -ParameterFilter { $Path -eq $MockFullPath -and $PathType -eq "Leaf" } -Times 1
    Should -Invoke -CommandName New-Item -ParameterFilter { $Path -eq $MockFullPath } -Times 1
    Should -Invoke -CommandName Add-Content -ParameterFilter { $Path -eq $MockFullPath -and $Value -eq "[$MockDate][INFO] $MessageToWrite" } -Times 1
  }

  It "should log to host and append log to file if file is found for the timestamp" {
    # Arrange
    $Global:ProductivityScriptsSettings.LoggerLevel = ([LogLevel]::Debug)
    $Global:ProductivityScriptsSettings.LoggerDirectory = "test/path"
    $LevelForLog = ([LogLevel]::Info)
    $MessageToWrite = "This is a test message"

    $MockDate = "1994-07-21 07:21:21.21"
    $MockColor = "White"
    $MockFullPath = "fake/full/path/to/file.log"

    Mock Get-Date -Verifiable -ParameterFilter { $Format -eq "yyyy-MM-dd HH:mm:ss.ff" } { return $MockDate }
    Mock Get-LogColor -Verifiable -ParameterFilter { $Level -eq $LevelForLog } { return $MockColor }
    Mock Test-Path -Verifiable -ParameterFilter { $Path -eq $Global:ProductivityScriptsSettings.LoggerDirectory -and $PathType -eq "Container" } { return $true }
    Mock Join-Path -Verifiable -ParameterFilter { $Path -eq $Global:ProductivityScriptsSettings.LoggerDirectory -and $ChildPath -eq "1994-07-21.log" } { return $MockFullPath }
    Mock Test-Path -Verifiable -ParameterFilter { $Path -eq $MockFullPath -and $PathType -eq "Leaf" } { return $true }

    # Act
    Write-Log -Level $LevelForLog -Message $MessageToWrite

    # Assert
    Should -Invoke -CommandName Get-Date -ParameterFilter { $Format -eq 'yyyy-MM-dd HH:mm:ss.ff' } -Times 1
    Should -Invoke -CommandName Get-LogColor -ParameterFilter { $Level -eq $LevelForLog } -Times 1
    Should -Invoke -CommandName Write-Host -ParameterFilter { $object -eq "[$MockDate] $MessageToWrite" -and $ForegroundColor -eq $MockColor } -Times 1
    Should -Invoke -CommandName Test-Path -ParameterFilter { $Path -eq $Global:ProductivityScriptsSettings.LoggerDirectory -and $PathType -eq "Container" } -Times 1
    Should -Invoke -CommandName Join-Path { $Path -eq $Global:ProductivityScriptsSettings.LoggerDirectory -and $ChildPath -eq "1994-07-21.log" } -Times 1
    Should -Invoke -CommandName Test-Path -ParameterFilter { $Path -eq $MockFullPath -and $PathType -eq "Leaf" } -Times 1
    Should -Invoke -CommandName New-Item -Times 0
    Should -Invoke -CommandName Add-Content -ParameterFilter { $Path -eq $MockFullPath -and $Value -eq "[$MockDate][INFO] $MessageToWrite" } -Times 1
  }
}

AfterAll {
  # Restore global variables
  $Global:ProductivityScriptsSettings = $Global:ProductivityScriptsSettingsBackup.PsObject.Copy()
  $Global:ProductivityScriptsSettingsBackup = $null
}