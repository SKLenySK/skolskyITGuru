# Detection script - Checks if Control Panel or Task Manager blocked in ANY user profile

$blocked = $false

$hives = Get-ChildItem "Registry::HKEY_USERS" -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -notmatch "_Classes" }

foreach ($hive in $hives) {
    $sid = Split-Path $hive.PSChildName -Leaf

    $cpPath = "Registry::${sid}\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    $tmPath = "Registry::${sid}\Software\Microsoft\Windows\CurrentVersion\Policies\System"

    try {
        $cpValue = (Get-ItemProperty -Path $cpPath -Name "NoControlPanel" -ErrorAction Stop).NoControlPanel
        if ($cpValue -eq 1) { $blocked = $true }
    } catch {}

    try {
        $tmValue = (Get-ItemProperty -Path $tmPath -Name "DisableTaskMgr" -ErrorAction Stop).DisableTaskMgr
        if ($tmValue -eq 1) { $blocked = $true }
    } catch {}
}

if ($blocked) {
    Write-Output "Blocked"
    exit 1
} else {
    Write-Output "Not blocked"
    exit 0
}
