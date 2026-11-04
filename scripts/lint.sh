#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
QML_IMPORT_PATH="${QML_IMPORT_PATH:-/usr/lib/x86_64-linux-gnu/qt6/qml}"
export QML_IMPORT_PATH

mapfile -t FILES < <(find "$PROJECT_ROOT/package" -name '*.qml' | sort)

if [[ ${#FILES[@]} -eq 0 ]]; then
    echo "No QML files found." >&2
    exit 1
fi

status=0
for file in "${FILES[@]}"; do
    if ! qmllint "$file"; then
        status=1
    fi
done

exit "$status"
