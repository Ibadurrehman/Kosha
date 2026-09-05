#!/usr/bin/env sh
# Regenerates freezed / json_serializable / drift / riverpod code.
# Usage: tool/gen.sh          (one-off build)
#        tool/gen.sh watch    (rebuild on change)
cd "$(dirname "$0")/.." || exit 1
if [ "$1" = "watch" ]; then
  dart run build_runner watch --delete-conflicting-outputs
else
  dart run build_runner build --delete-conflicting-outputs
fi
