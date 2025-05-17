# Define the path for 64-bit and 32-bit applications in the registry
$regPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)

# Create an empty array to hold the results
$results = @()

# Loop through each registry path
foreach ($path in $regPaths) {
    # Get all subkeys from the path
    $subKeys = Get-ChildItem -Path $path

    # Loop through each subkey to access application details
    foreach ($subKey in $subKeys) {
        # Get properties from each subkey
        $properties = Get-ItemProperty -Path $subKey.PSPath

        # Check if the DisplayName property exists to filter out non-application entries
        if ($properties.DisplayName) {
            $result = [PSCustomObject]@{
                Name = $properties.DisplayName
                Publisher = $properties.Publisher
                InstallDate = $properties.InstallDate
                UninstallCommand = $properties.UninstallString
                InstallLocation = $properties.InstallLocation
            }

            # Add the result to the results array
            $results += $result
        }
    }
}

# Output the results to the console or export to a CSV file
$results | Format-Table -AutoSize # You can replace this with `Export-Csv -Path "path_to_output.csv" -NoTypeInformation` to save the results to a CSV file
