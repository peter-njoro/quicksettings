#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE_DIR="$PROJECT_ROOT/package"
METADATA="$PACKAGE_DIR/metadata.json"

if [[ ! -f "$METADATA" ]]; then
    echo "metadata.json not found in $PACKAGE_DIR" >&2
    exit 1
fi

VERSION="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["KPlugin"]["Version"])' "$METADATA")"
OUTPUT="$PROJECT_ROOT/quick-settings-$VERSION.plasmoid"

rm -f "$OUTPUT"
(
    cd "$PACKAGE_DIR"
    zip -r -q "$OUTPUT" .
)

echo "Created $OUTPUT"
