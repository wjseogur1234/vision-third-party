#!/usr/bin/env bash
# submodule을 고정된 커밋으로 받는다.
set -euo pipefail
cd "$(dirname "$0")/.."
git submodule sync --recursive
git submodule update --init --recursive
git submodule status
