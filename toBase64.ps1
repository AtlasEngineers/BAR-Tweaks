# Define the original string and the output file path
$OriginalString = Get-Content -Path $args[0] -Raw

#Convert CRLF to LF
$StringToConvert = $OriginalString -replace "`r`n", "`n"

$OutputPath = $args[1] # Use an absolute path

# 1. Convert the string to a byte array using the appropriate encoding (e.g., UTF-8 is efficient)
$Bytes = [System.Text.Encoding]::UTF8.GetBytes($StringToConvert)

# 2. Convert the byte array to a standard Base64 string
$Base64String = [Convert]::ToBase64String($Bytes)

# 3. Convert the standard Base64 string to Base64URL format
$Base64UrlString = $Base64String.Replace('+', '-').Replace('/', '_').TrimEnd('=')

# Display the Base64URL string
Set-Clipboard -Value ("!bset tweakdefs "+ $Base64UrlString)

Write-Host "opied '!bset tweakdefs base64' to clipboard!"

# 4. Write the resulting Base64 string to a file
$Base64UrlString | Out-File -FilePath $OutputPath -Encoding Utf8