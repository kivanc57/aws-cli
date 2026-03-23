#!/bin/bash
set -euo pipefail

log() {
        printf '\n[%s] %s\n' "$(date -Is)" "$*"
}

