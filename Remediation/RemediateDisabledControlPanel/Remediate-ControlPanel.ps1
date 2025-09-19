# Remediation script - Unblock Control Panel & Task Manager in ALL user profiles

$results = @()

# Enum all loaded user hives
$hives = Get-ChildItem "Registry::HKEY_USERS" -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -notmatch "_Classes" }

foreach ($hive in $hives) {
    $sid = Split-Path $hive.PSChildName -Leaf
    
    # --- Control Panel fix ---
    $cpPath = "Registry::${sid}\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    $cpName = "NoControlPanel"

    try {
        if (Get-ItemProperty -Path $cpPath -Name $cpName -ErrorAction Stop) {
            Remove-ItemProperty -Path $cpPath -Name $cpName -ErrorAction SilentlyContinue
            $results += "[$sid] Control Panel entry removed"
        }
    }
    catch {
        # ignore if not present
    }

    # --- Task Manager fix ---
    $tmPath = "Registry::${sid}\Software\Microsoft\Windows\CurrentVersion\Policies\System"
    $tmName = "DisableTaskMgr"

    try {
        if (Get-ItemProperty -Path $tmPath -Name $tmName -ErrorAction Stop) {
            Remove-ItemProperty -Path $tmPath -Name $tmName -ErrorAction SilentlyContinue
            $results += "[$sid] Task Manager entry removed"
        }
    }
    catch {
        # ignore if not present
    }
}

if ($results.Count -gt 0) {
    Write-Output "Remediated:`n$($results -join "`n")"
} else {
    Write-Output "Nothing to remediate"
}
