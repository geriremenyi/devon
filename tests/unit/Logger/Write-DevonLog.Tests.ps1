BeforeAll {
  # Backup global variables
  $Global:DevonSettingsBackup = $Global:DevonSettings?.PsObject?.Copy()
  
  # Dependendencies
  . $PSScriptRoot/../../../src/Logger/Get-DevonLogColor.ps1

  # Mock dependencies
  Mock Get-Date -Verifiable -ParameterFilter { $Format -eq 'yyyy-MM-dd HH:mm:ss.ff' }
  Mock Get-DevonLogColor -Verifiable
  Mock Write-Host -Verifiable
  Mock Test-Path -Verifiable
  Mock Join-Path -Verifiable
  Mock New-Item -Verifiable
  Mock Add-Content -Verifiable

  # Script under test
  . $PSScriptRoot/../../../src/Logger/Write-DevonLog.ps1
}

Describe "Write-DevonLog" -Tag "Unit" {
  It "should skip logging if level set is lower severity than message" {
    # Arrange
    $Global:DevonSettings.LoggerLevel = ([DevonLogLevel]::Error)
    $Level = ([DevonLogLevel]::Warning)
    $Message = "This is a test message"
    
    # Act
    Write-DevonLog -Level $Level -Message $Message

    # Assert
    Should -Invoke -CommandName Get-Date -Times 0
  }

  It "should skip logging if level set is lower severity than message" {
    # Arrange
    $Global:DevonSettings.LoggerLevel = ([DevonLogLevel]::Error)
    $Level = ([DevonLogLevel]::Warning)
    $Message = "This is a test message"
    
    # Act
    Write-DevonLog -Level $Level -Message $Message

    # Assert
    Should -Invoke -CommandName Get-Date -ParameterFilter { $Format -eq 'yyyy-MM-dd HH:mm:ss.ff' } -Times 0
    Should -Invoke -CommandName Get-DevonLogColor -Times 0
    Should -Invoke -CommandName Write-Host -Times 0
    Should -Invoke -CommandName Test-Path -Times 0
    Should -Invoke -CommandName Join-Path -Times 0
    Should -Invoke -CommandName New-Item -Times 0
    Should -Invoke -CommandName Add-Content -Times 0
  }

  It "should log to host and skip logging to file if that is disabled" {
    # Arrange
    $Global:DevonSettings.LoggerLevel = ([DevonLogLevel]::Debug)
    $Global:DevonSettings.LoggerDirectory = $null
    $LevelForLog = ([DevonLogLevel]::Info)
    $MessageToWrite = "This is a test message"

    $MockDate = "1994-07-21 07:21:21.21"
    $MockColor = "White"

    Mock Get-Date -Verifiable -ParameterFilter { $Format -eq "yyyy-MM-dd HH:mm:ss.ff" } { return $MockDate }
    Mock Get-DevonLogColor -Verifiable -ParameterFilter { $Level -eq $LevelForLog } { return $MockColor }

    # Act
    Write-DevonLog -Level $LevelForLog -Message $MessageToWrite

    # Assert
    Should -Invoke -CommandName Get-Date -ParameterFilter { $Format -eq 'yyyy-MM-dd HH:mm:ss.ff' } -Times 1
    Should -Invoke -CommandName Get-DevonLogColor -ParameterFilter { $Level -eq $LevelForLog } -Times 1
    Should -Invoke -CommandName Write-Host -ParameterFilter { $object -eq "[$MockDate] $MessageToWrite" -and $ForegroundColor -eq $MockColor } -Times 1
    Should -Invoke -CommandName Test-Path -Times 0
    Should -Invoke -CommandName Join-Path -Times 0
    Should -Invoke -CommandName New-Item -Times 0
    Should -Invoke -CommandName Add-Content -Times 0
  }

  It "should log to host and skip logging to file if logger directory not found" {
    # Arrange
    $Global:DevonSettings.LoggerLevel = ([DevonLogLevel]::Debug)
    $Global:DevonSettings.LoggerDirectory = "test/path"
    $LevelForLog = ([DevonLogLevel]::Info)
    $MessageToWrite = "This is a test message"

    $MockDate = "1994-07-21 07:21:21.21"
    $MockColor = "White"

    Mock Get-Date -Verifiable -ParameterFilter { $Format -eq "yyyy-MM-dd HH:mm:ss.ff" } { return $MockDate }
    Mock Get-DevonLogColor -Verifiable -ParameterFilter { $Level -eq $LevelForLog } { return $MockColor }
    Mock Test-Path -Verifiable -ParameterFilter { $Path -eq $Global:DevonSettings.LoggerDirectory -and $PathType -eq "Container" } { return $false }

    # Act
    Write-DevonLog -Level $LevelForLog -Message $MessageToWrite

    # Assert
    Should -Invoke -CommandName Get-Date -ParameterFilter { $Format -eq 'yyyy-MM-dd HH:mm:ss.ff' } -Times 1
    Should -Invoke -CommandName Get-DevonLogColor -ParameterFilter { $Level -eq $LevelForLog } -Times 1
    Should -Invoke -CommandName Write-Host -ParameterFilter { $object -eq "[$MockDate] $MessageToWrite" -and $ForegroundColor -eq $MockColor } -Times 1
    Should -Invoke -CommandName Test-Path -ParameterFilter { $Path -eq $Global:DevonSettings.LoggerDirectory -and $PathType -eq "Container" } -Times 1
    Should -Invoke -CommandName Join-Path -Times 0
    Should -Invoke -CommandName New-Item -Times 0
    Should -Invoke -CommandName Add-Content -Times 0
  }

  It "should log to host and log to new file if file is not found for the timestamp" {
    # Arrange
    $Global:DevonSettings.LoggerLevel = ([DevonLogLevel]::Debug)
    $Global:DevonSettings.LoggerDirectory = "test/path"
    $LevelForLog = ([DevonLogLevel]::Info)
    $MessageToWrite = "This is a test message"

    $MockDate = "1994-07-21 07:21:21.21"
    $MockColor = "White"
    $MockFullPath = "fake/full/path/to/file.log"

    Mock Get-Date -Verifiable -ParameterFilter { $Format -eq "yyyy-MM-dd HH:mm:ss.ff" } { return $MockDate }
    Mock Get-DevonLogColor -Verifiable -ParameterFilter { $Level -eq $LevelForLog } { return $MockColor }
    Mock Test-Path -Verifiable -ParameterFilter { $Path -eq $Global:DevonSettings.LoggerDirectory -and $PathType -eq "Container" } { return $true }
    Mock Join-Path -Verifiable -ParameterFilter { $Path -eq $Global:DevonSettings.LoggerDirectory -and $ChildPath -eq "1994-07-21.log" } { return $MockFullPath }
    Mock Test-Path -Verifiable -ParameterFilter { $Path -eq $MockFullPath -and $PathType -eq "Leaf" } { return $false }

    # Act
    Write-DevonLog -Level $LevelForLog -Message $MessageToWrite

    # Assert
    Should -Invoke -CommandName Get-Date -ParameterFilter { $Format -eq 'yyyy-MM-dd HH:mm:ss.ff' } -Times 1
    Should -Invoke -CommandName Get-DevonLogColor -ParameterFilter { $Level -eq $LevelForLog } -Times 1
    Should -Invoke -CommandName Write-Host -ParameterFilter { $object -eq "[$MockDate] $MessageToWrite" -and $ForegroundColor -eq $MockColor } -Times 1
    Should -Invoke -CommandName Test-Path -ParameterFilter { $Path -eq $Global:DevonSettings.LoggerDirectory -and $PathType -eq "Container" } -Times 1
    Should -Invoke -CommandName Join-Path { $Path -eq $Global:DevonSettings.LoggerDirectory -and $ChildPath -eq "1994-07-21.log" } -Times 1
    Should -Invoke -CommandName Test-Path -ParameterFilter { $Path -eq $MockFullPath -and $PathType -eq "Leaf" } -Times 1
    Should -Invoke -CommandName New-Item -ParameterFilter { $Path -eq $MockFullPath } -Times 1
    Should -Invoke -CommandName Add-Content -ParameterFilter { $Path -eq $MockFullPath -and $Value -eq "[$MockDate][INFO] $MessageToWrite" } -Times 1
  }

  It "should log to host and append log to file if file is found for the timestamp" {
    # Arrange
    $Global:DevonSettings.LoggerLevel = ([DevonLogLevel]::Debug)
    $Global:DevonSettings.LoggerDirectory = "test/path"
    $LevelForLog = ([DevonLogLevel]::Info)
    $MessageToWrite = "This is a test message"

    $MockDate = "1994-07-21 07:21:21.21"
    $MockColor = "White"
    $MockFullPath = "fake/full/path/to/file.log"

    Mock Get-Date -Verifiable -ParameterFilter { $Format -eq "yyyy-MM-dd HH:mm:ss.ff" } { return $MockDate }
    Mock Get-DevonLogColor -Verifiable -ParameterFilter { $Level -eq $LevelForLog } { return $MockColor }
    Mock Test-Path -Verifiable -ParameterFilter { $Path -eq $Global:DevonSettings.LoggerDirectory -and $PathType -eq "Container" } { return $true }
    Mock Join-Path -Verifiable -ParameterFilter { $Path -eq $Global:DevonSettings.LoggerDirectory -and $ChildPath -eq "1994-07-21.log" } { return $MockFullPath }
    Mock Test-Path -Verifiable -ParameterFilter { $Path -eq $MockFullPath -and $PathType -eq "Leaf" } { return $true }

    # Act
    Write-DevonLog -Level $LevelForLog -Message $MessageToWrite

    # Assert
    Should -Invoke -CommandName Get-Date -ParameterFilter { $Format -eq 'yyyy-MM-dd HH:mm:ss.ff' } -Times 1
    Should -Invoke -CommandName Get-DevonLogColor -ParameterFilter { $Level -eq $LevelForLog } -Times 1
    Should -Invoke -CommandName Write-Host -ParameterFilter { $object -eq "[$MockDate] $MessageToWrite" -and $ForegroundColor -eq $MockColor } -Times 1
    Should -Invoke -CommandName Test-Path -ParameterFilter { $Path -eq $Global:DevonSettings.LoggerDirectory -and $PathType -eq "Container" } -Times 1
    Should -Invoke -CommandName Join-Path { $Path -eq $Global:DevonSettings.LoggerDirectory -and $ChildPath -eq "1994-07-21.log" } -Times 1
    Should -Invoke -CommandName Test-Path -ParameterFilter { $Path -eq $MockFullPath -and $PathType -eq "Leaf" } -Times 1
    Should -Invoke -CommandName New-Item -Times 0
    Should -Invoke -CommandName Add-Content -ParameterFilter { $Path -eq $MockFullPath -and $Value -eq "[$MockDate][INFO] $MessageToWrite" } -Times 1
  }
}

AfterAll {
  # Restore global variables
  $Global:DevonSettings = $Global:DevonSettingsBackup?.PsObject?.Copy()
  $Global:DevonSettingsBackup = $null
}