$taskName = 'DailyShutdown'

# Check if the scheduled task already exists
if (-not (Get-ScheduledTask | Where-Object {$_.TaskName -eq $taskName})) {
    $action = New-ScheduledTaskAction -Execute 'shutdown.exe' -Argument '/s /t 0'
    $trigger = New-ScheduledTaskTrigger -Daily -At '21:00'
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

    # Register the scheduled task
    Register-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -TaskName $taskName -Description 'Shuts down the computer daily at 6:00 PM' -User 'SYSTEM'
    Write-Host "Scheduled task '$taskName' created."
} else {
    Write-Host "Scheduled task '$taskName' already exists."
}
