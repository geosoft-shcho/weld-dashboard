#!/usr/bin/env bash
# Agent / local verification for weld-dashboard feature work.
# Usage:
#   ./scripts/agent_check.sh
#   ./scripts/agent_check.sh test/foo_test.dart [more_test_paths...]
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

echo "==> dart analyze"
dart analyze

if [[ "$#" -gt 0 ]]; then
  echo "==> flutter test $*"
  flutter test "$@"
fi

echo "==> agent_check ok"
