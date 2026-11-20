#!/usr/bin/env bash
set -euo pipefail
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_dir/ghost_mark"
flutter pub get
flutter analyze --no-pub
flutter test --no-pub
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist --dart-define=IOS_APP_STORE_ID=6836976147
