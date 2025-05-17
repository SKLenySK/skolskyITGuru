Start-Transcript -Path "C:\Powershell.log" -NoClobber -Append
Write-Host Nastavovanie jazkya SK pre pocitace
Write-host Set-Culture sk-SK
Set-Culture sk-SK
Write-host Set-WinSystemLocale -SystemLocale sk-SK
Set-WinSystemLocale -SystemLocale sk-SK
Write-host Set-WinUILanguageOverride -Language sk-SK
Set-WinUILanguageOverride -Language sk-SK
Write-host Set-WinHomeLocation -GeoId 143
Set-WinHomeLocation -GeoId 143
Write-host Set-WinUserLanguageList -LanguageList "en-US", "sk-SK", "de-DE" -force
Set-WinUserLanguageList -LanguageList "en-US", "sk-SK", "de-DE" -force
Write-host Nastavujem keyboard pre logon screen
if((Test-Path -LiteralPath "Registry::\HKEY_USERS\.DEFAULT\Keyboard Layout\Preload") -ne $true) {  New-Item "Registry::\HKEY_USERS\.DEFAULT\Keyboard Layout\Preload" -force -ea SilentlyContinue };
New-ItemProperty -LiteralPath 'Registry::\HKEY_USERS\.DEFAULT\Keyboard Layout\Preload' -Name '1' -Value '0000041b' -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'Registry::\HKEY_USERS\.DEFAULT\Keyboard Layout\Preload' -Name '2' -Value '00000409' -PropertyType String -Force -ea SilentlyContinue;
Write-host Nastavujem InternationalSettings pre všetkých používateľov
Copy-UserInternationalSettingsToSystem -WelcomeScreen $True -NewUser $True
Stop-Transcript