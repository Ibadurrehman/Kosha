# Regenerates freezed / json_serializable / drift / riverpod code.
# Usage: .\tool\gen.ps1        (one-off build)
#        .\tool\gen.ps1 watch  (rebuild on change)
param([string]$mode = "build")
Set-Location (Join-Path $PSScriptRoot "..")
if ($mode -eq "watch") {
  dart run build_runner watch --delete-conflicting-outputs
} else {
  dart run build_runner build --delete-conflicting-outputs
}
