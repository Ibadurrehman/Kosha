# Refreshes the two drift assets the web build needs: web/sqlite3.wasm and
# web/drift_worker.js. Both are published with each drift release, so the
# version is read from pubspec.lock and they always match the drift the app
# actually depends on. Run this after upgrading drift; a stale worker against a
# newer drift fails at runtime with an unhelpful message.
#
# Usage: .\tool\fetch_web_assets.ps1
$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

$lock = Get-Content pubspec.lock -Raw
if ($lock -notmatch '(?m)^  drift:\r?\n(?:.*\r?\n)*?    version: "([^"]+)"') {
  throw "Could not find the drift version in pubspec.lock. Run 'flutter pub get' first."
}
$version = $Matches[1]
$release = "https://github.com/simolus3/drift/releases/download/drift-$version"
Write-Host "Fetching drift $version web assets"

foreach ($asset in @("sqlite3.wasm", "drift_worker.js")) {
  $target = Join-Path "web" $asset
  Invoke-WebRequest -Uri "$release/$asset" -OutFile $target
  $size = (Get-Item $target).Length
  Write-Host ("  {0,-16} {1,9:N0} bytes" -f $asset, $size)
}

Write-Host "Done. Commit the files if they changed."
