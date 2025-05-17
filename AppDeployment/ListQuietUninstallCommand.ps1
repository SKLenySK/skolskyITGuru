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

        # Check if the DisplayName property exists and QuietUninstallString is present
        if ($properties.DisplayName -and $properties.QuietUninstallString) {
            $result = [PSCustomObject]@{
                Name = $properties.DisplayName
                QuietUninstallCommand = $properties.QuietUninstallString
            }

            # Add the result to the results array
            $results += $result
        }
    }
}

# Output the results to the console or export to a CSV file
$results | Format-Table 
