<#
.SYNOPSIS
Získanie zoznamu TICHÝCH odinštalačných príkazov pre aplikácie v systéme Windows (64-bit aj 32-bit).

.DESCRIPTION
Tento skript prehľadáva registre systému Windows, aby získal informácie o všetkých nainštalovaných aplikáciách. 
Zohľadňuje obe vetvy registra – pre 64-bitové aj 32-bitové aplikácie – a zhromažďuje údaje ako názov aplikácie, 
vydavateľ, dátum inštalácie, príkaz na odinštalovanie a umiestnenie inštalácie.

Výsledky sa zobrazia v tabuľke v konzole, prípadne je možné ich exportovať do CSV súboru.

.VYUŽITIE
- zistenie odinštalátora pre Deployment Intune Aplikácií

.COPYRIGHT
© 2025 skolskyIT.guru. Všetky práva vyhradené.
#>


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
