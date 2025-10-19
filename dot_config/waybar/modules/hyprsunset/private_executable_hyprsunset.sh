#!/usr/bin/env bash
# Requires: hyprctl, hyprsunset, notify-send (optional)

ON_TEMP=4000
OFF_TEMP=6000

ensure_running() {
  pgrep -x hyprsunset >/dev/null || setsid uwsm-app -- hyprsunset >/dev/null 2>&1 &
}

get_current_temp() {
  # returns number or empty string if unavailable
  hyprctl hyprsunset temperature 2>/dev/null | grep -oE '[0-9]+' || true
}

print_status_json() {
  local t="$1"
  local icon cls tip
  if [[ -z "$t" ]]; then
    icon="󰃠"; cls="off"; tip="Hyprsunset: unknown"
  elif (( t <= ON_TEMP )); then
    icon="󰃛"; cls="on";  tip="Hyprsunset: warm ${t}K"
  else
    icon="󰃠"; cls="off"; tip="Hyprsunset: cool ${t}K"
  fi
  printf '{"text":"%s","tooltip":"%s","class":["%s"]}\n' "$icon" "$tip" "$cls"
}

toggle() {
  local t
  t="$(get_current_temp)"
  if [[ -z "$t" || "$t" -gt "$ON_TEMP" ]]; then
    hyprctl hyprsunset temperature "$ON_TEMP" >/dev/null
    notify-send "  Nightlight: ${ON_TEMP}K"
  else
    hyprctl hyprsunset temperature "$OFF_TEMP" >/dev/null
    notify-send "  Daylight: ${OFF_TEMP}K"
  fi
}

cmd="${1:-status}"
ensure_running

case "$cmd" in
  toggle) toggle ;;
  status|*) print_status_json "$(get_current_temp)" ;;
esac
