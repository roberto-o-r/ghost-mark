#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
app_dir="$repo_dir/ghost_mark"
registrant="$app_dir/android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java"

cd "$app_dir"

echo "Resolving Flutter dependencies and regenerating Android plugins..."
flutter pub get

if [[ ! -f "$registrant" ]]; then
  echo "Android plugin registrant was not generated: $registrant" >&2
  exit 1
fi

for plugin in FilePickerPlugin SharedPreferencesPlugin UrlLauncherPlugin; do
  if ! grep -Fq "$plugin" "$registrant"; then
    echo "Required Android plugin is missing from the registrant: $plugin" >&2
    exit 1
  fi
done

echo "Android plugin registration verified."
flutter analyze --no-pub
flutter test --no-pub
# Let the build refresh plugin registration for release mode. A preceding
# integration test can leave debug-only plugins in generated registration.
flutter build appbundle --release
if grep -Fq 'IntegrationTestPlugin' "$registrant"; then
  echo "Release registrant still contains the debug integration-test plugin." >&2
  exit 1
fi
for plugin in FilePickerPlugin SharedPreferencesPlugin UrlLauncherPlugin; do
  if ! grep -Fq "$plugin" "$registrant"; then
    echo "Release registrant is missing required plugin: $plugin" >&2
    exit 1
  fi
done
