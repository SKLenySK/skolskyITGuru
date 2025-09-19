Start-Transcript -Path "C:\PowerShell.log" -NoClobber -Append

Write-Host "Zobrazujem ikonu Tento počítač na ploche..." -ForegroundColor Cyan

# CLSID pre This PC
$clsid_ThisPC = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"

# Nastavenie pre aktuálneho používateľa
$regPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
New-Item -Path $regPath -Force | Out-Null
Set-ItemProperty -Path $regPath -Name $clsid_ThisPC -Value 0 -Type DWord

# Nastavenie pre klasickú ponuku Štart (ak by bola použitá)
$regPathClassic = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"
New-Item -Path $regPathClassic -Force | Out-Null
Set-ItemProperty -Path $regPathClassic -Name $clsid_ThisPC -Value 0 -Type DWord

# Refresh plochy bez pádu Exploreru
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class RefreshDesktop {
    [DllImport("shell32.dll")] public static extern void SHChangeNotify(int wEventId, int uFlags, IntPtr dwItem1, IntPtr dwItem2);
}
"@
[RefreshDesktop]::SHChangeNotify(0x8000000, 0, [IntPtr]::Zero, [IntPtr]::Zero)

Write-Host "Hotovo – ikona Tento počítač je teraz na ploche." -ForegroundColor Green

# Pre nových používateľov
$regPathDefault = "HKU:\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
New-Item -Path $regPathDefault -Force | Out-Null
Set-ItemProperty -Path $regPathDefault -Name $clsid_ThisPC -Value 0 -Type DWord

# Pre všetkých existujúcich používateľov
$subKey = "Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"

Get-ChildItem "Registry::HKEY_USERS" | ForEach-Object {
    try {
        $regPath = "Registry::$($_.Name)\$subKey"
        if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
        Set-ItemProperty -Path $regPath -Name $clsid_ThisPC -Value 0 -Type DWord
        Write-Host "Nastavené pre SID $($_.PSChildName)"
    } catch {
        Write-Warning "Nepodarilo sa nastaviť pre $($_.PSChildName): $_"
    }
}


Stop-Transcript
