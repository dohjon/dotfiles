#!/usr/bin/env bash

# Checks if an external monitor is connected
if hyprctl monitors | grep -q 'DP-3'; then
    if [[ "$1" == "close" ]]; then
        # Disable laptop screen when lid is closed
        hyprctl keyword monitor "eDP-1, disable"
    elif [[ "$1" == "open" ]]; then
        # Enable laptop screen when lid is open
        hyprctl keyword monitor "eDP-1, 2880x1920@120, auto, 2"
    fi
fi
