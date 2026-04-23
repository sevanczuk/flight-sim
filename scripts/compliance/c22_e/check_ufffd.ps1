# C2.2-E Compliance: U+FFFD replacement character detection (PowerShell).
# Equivalent to check_ufffd.py; used because Python is not available on this host.
# Per D-08 saved for audit trail.
param(
    [string]$FilePath = "docs\specs\fragments\GNX375_Functional_Spec_V1_part_E.md"
)

$bytes = [System.IO.File]::ReadAllBytes($FilePath)
$count = 0
for ($i = 0; $i -lt $bytes.Length - 2; $i++) {
    if ($bytes[$i] -eq 0xEF -and $bytes[$i+1] -eq 0xBF -and $bytes[$i+2] -eq 0xBD) {
        $count++
        $i += 2
    }
}
Write-Host "U+FFFD count in ${FilePath}: $count"
exit $(if ($count -eq 0) { 0 } else { 1 })
