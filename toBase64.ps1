# Define the original string and the output file path
$OriginalString = Get-Content -Path $args[0] -Raw

#Convert CRLF to LF
$OriginalString = $OriginalString -replace "`r`n", "`n"

$LuaminString = & "$PSScriptRoot\tools\luamin\bin\luamin.ps1" "--file" "$((Resolve-Path $args[0]).Path)"

Write-Host "Pre Luamin String Char Count: " $OriginalString.Length
Write-Host "Post Luamin String Char Count: " $LuaminString.Length

function ToBase64 {
    param (
        [Parameter(Mandatory=$true)]
        [string]$InputString
    )

    # 1. Convert the string to a byte array using the appropriate encoding (e.g., UTF-8 is efficient)
	$Bytes = [System.Text.Encoding]::UTF8.GetBytes($InputString)

	# 2. Convert the byte array to a standard Base64 string
	$Base64String = [Convert]::ToBase64String($Bytes)

	# 3. Convert the standard Base64 string to Base64URL format
	$Base64UrlString = $Base64String.Replace('+', '-').Replace('/', '_').TrimEnd('=')

    # Return the result
    return $Base64UrlString
}


$PreLuaminBase64 = ToBase64 -InputString $OriginalString
$PostLuaminBase64 = ToBase64 -InputString $LuaminString

Write-Host "Pre Luamin Base64 Char Count: " $PreLuaminBase64.Length
Write-Host "Post Luamin Base64 Char Count: " $PostLuaminBase64.Length

# Display the Base64URL string
Set-Clipboard -Value ("!bset tweakdefs "+ $Base64UrlString)

Write-Host "Copied '!bset tweakdefs base64' to clipboard!"

# 4. Write the resulting Base64 string to a file
$OutputPath = $args[1] # Use an absolute path
$Base64UrlString | Out-File -FilePath $OutputPath -Encoding Utf8