Start-Transcript -Path c:\printerinstall.log

########################################################################################################
#If Powershell is running the 32-bit version on a 64-bit machine, we need to force powershell to run in
#64-bit mode to allow the OleDb access to function properly.
########################################################################################################
if ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
    write-warning "Y'arg Matey, we're off to 64-bit land....."
    if ($myInvocation.Line) {
        &"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe" -NonInteractive -NoProfile $myInvocation.Line
    }else{
        &"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe" -NonInteractive -NoProfile -file "$($myInvocation.InvocationName)" $args
    }
exit $lastexitcode
}

## nastavenia
#meno súboru pre inf driveru tlačiarne
$PrinterDriver = 'KOBxxK__01.inf' 
#IP adresa alebo FQDN tlaciarne
$PrinterPortAddress = '10.50.10.10'
$PrinterPortName = 'IP_' + $PrinterPort
$PrintDriverName = "KONICA MINOLTA Universal V4 PCL"
$PrinterName = "KM Bizhub C224 (Zborovňa)"

& pnputil.exe /add-driver $PrinterDriver

# Skontrolujte, či ovládač tlačiarne existuje
if (-Not (Get-PrinterDriver -Name $PrintDriverName -ErrorAction SilentlyContinue)) {
    # Ak ovládač neexistuje, nainštalujte ho
    Add-PrinterDriver -Name $PrintDriverName
    Write-Host "[Install] Ovládač tlačiarne $PrintDriverName bol nainštalovaný." -ForegroundColor Red
} else {
    Write-Host "[Info] Ovládač tlačiarne $PrintDriverName už existuje." -ForegroundColor Yellow
}

# Skontrolujte, či port tlačiarne existuje
if (-Not (Get-PrinterPort -Name $PrinterPortName -ErrorAction SilentlyContinue)) {
    # Ak port neexistuje, vytvorte ho
    Add-PrinterPort -Name $PrinterPortName -PrinterHostAddress $PrinterPortAddress
    Write-Host "[Install] Port tlačiarne $PrinterPortName bol vytvorený." -ForegroundColor Red
} else {
    Write-Host "[Info] Port tlačiarne $PrinterPortName už existuje." -ForegroundColor Yellow
}

# Skontrolujte, či tlačiareň existuje
if (-Not (Get-Printer -Name $PrinterName -ErrorAction SilentlyContinue)) {
    # Ak tlačiareň neexistuje, vytvorte ju
    Add-Printer -Name $PrinterName -DriverName $PrintDriverName -PortName $PrinterPortName
    Write-Host "[Install] Tlačiareň $PrinterName bola vytvorená." -ForegroundColor Red
} else {
    Write-Host "[Install] Tlačiareň $PrinterName už existuje." -ForegroundColor Yellow
}

Stop-Transcript