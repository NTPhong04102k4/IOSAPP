#!/usr/bin/env bash
#
# Installs the developer tooling required to format and lint the project.
# Safe to run repeatedly — it only installs what is missing.
#
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "error: Homebrew is required but was not found. Install it from https://brew.sh" >&2
  exit 1
fi

for tool in swiftformat swiftlint; do
  if command -v "$tool" >/dev/null 2>&1; then
    echo "✓ $tool already installed ($($tool --version 2>/dev/null | head -1))"
  else
    echo "→ installing $tool..."
    brew install "$tool"
  fi
done

echo "Bootstrap complete."
