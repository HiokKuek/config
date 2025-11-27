#!/bin/bash

sketchybar --add event front_app_popup_trigger
sketchybar --add event front_app_popup_open
sketchybar --add event front_app_popup_close

sketchybar --add item front_app left \
           --set front_app \
             icon.font="sketchybar-app-font:Regular:16.0" \
             background.color=$ITEM_BG_COLOR \
             script="$PLUGIN_DIR/front_app.sh" \
             popup.drawing=off \
             popup.align=left \
             popup.height=30 \
             popup.horizontal=on \
             popup.blur_radius=30 \
             popup.y_offset=-15 \
             popup.background.align=center \
             popup.background.padding_left=5 \
             popup.background.padding_right=5 \
             popup.background.corner_radius=8 \
             popup.background.color=$POPUP_BG_COLOR \
             click_script="POPUP_STATE=\$(sketchybar --query front_app | jq -r '.popup.drawing')
if [ \"\$POPUP_STATE\" = \"on\" ]; then
  sketchybar --animate sin 10 --set front_app popup.drawing=off popup.y_offset=-15
else
  sketchybar --animate sin 10 --set front_app popup.drawing=on popup.y_offset=10
fi" \
           --subscribe front_app front_app_switched aerospace_workspace_change front_app_popup_open front_app_popup_close
