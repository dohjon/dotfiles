#!/usr/bin/env bash
set -euo pipefail

# Usage: moncount.sh [active|all]
SCOPE="${1:-active}"

case "$SCOPE" in
  active|all) ;;
  *)
    # Waybar-safe error payload
    printf '{"text":"?","tooltip":"invalid scope: %s","class":"error"}\n' "$SCOPE"
    exit 0
    ;;
esac

# Choose hyprctl command based on scope
if [ "$SCOPE" = "all" ]; then
  J="$(hyprctl -j monitors all 2>/dev/null || echo '[]')"
else
  J="$(hyprctl -j monitors 2>/dev/null || echo '[]')"
fi

# Parse with jq (fallbacks if jq fails)
COUNT="$(printf '%s' "$J" | jq 'length' 2>/dev/null || echo 0)"
NAMES="$(printf '%s' "$J" | jq -r '.[].name' 2>/dev/null | paste -sd',' - || echo "")"

CLASS="single"
[ "$COUNT" -ge 2 ] && CLASS="multi"

printf '{"text":"%s","tooltip":"%s (%s)","class":"%s"}\n' \
  "$COUNT" \
  "${NAMES:-no monitors}" \
  "$SCOPE" \
  "$CLASS"
