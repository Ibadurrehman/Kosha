#!/usr/bin/env bash
# Refreshes the two drift assets the web build needs: web/sqlite3.wasm and
# web/drift_worker.js. Both are published with each drift release, so the
# version is read from pubspec.lock and they always match the drift the app
# actually depends on. Run this after upgrading drift; a stale worker against a
# newer drift fails at runtime with an unhelpful message.
#
# Usage: tool/fetch_web_assets.sh
set -euo pipefail
cd "$(dirname "$0")/.."

version=$(awk '/^  drift:$/{f=1} f&&/^    version:/{gsub(/[",]/,"",$2); print $2; exit}' pubspec.lock)
if [ -z "${version:-}" ]; then
  echo "Could not find the drift version in pubspec.lock. Run 'flutter pub get' first." >&2
  exit 1
fi
release="https://github.com/simolus3/drift/releases/download/drift-$version"
echo "Fetching drift $version web assets"

for asset in sqlite3.wasm drift_worker.js; do
  curl -sL --fail -o "web/$asset" "$release/$asset"
  printf '  %-16s %9s bytes\n' "$asset" "$(wc -c <"web/$asset" | tr -d ' ')"
done

echo "Done. Commit the files if they changed."
