#!/bin/bash

sketchybar --add item central right

sketchybar --set central \
    icon=􀵴 \
    click_script="$CONFIG_DIR/plugins/central.sh" \
    icon.padding_left=12 \
    icon.padding_right=0 \
