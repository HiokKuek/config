#!/bin/bash

sketchybar --add item script_button right

sketchybar --set script_button \
    icon=􀪏 \
    click_script="$CONFIG_DIR/plugins/teleport.sh" \
    icon.padding_left=12 \
    icon.padding_right=0 \
