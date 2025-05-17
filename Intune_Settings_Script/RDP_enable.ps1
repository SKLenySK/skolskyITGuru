Start-Transcript -Path "C:\Powershell.log" -NoClobber
Write-host Nastavujem povolenie RDP na pocitaci
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
Stop-Transcript