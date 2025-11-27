#!/bin/bash

if [ "$SENDER" = "front_app_popup_open" ]; then
  ~/.config/aerospace/scripts/aero_top_down.sh
  "$CONFIG_DIR/plugins/build_front_popup.sh"
  sketchybar --animate sin 10 --set front_app \
    popup.y_offset=10 \
    popup.drawing=on \
    label="${INFO:-$APP_NAME}" \
    icon="$("$CONFIG_DIR/plugins/icon_map_fn.sh" "${INFO:-$APP_NAME}")"
  exit 0
fi

if [ "$SENDER" = "front_app_popup_close" ]; then
  sketchybar --animate sin 15 --set front_app popup.y_offset=-60
  sleep 0.3
  ~/.config/aerospace/scripts/aero_top_up.sh
  sleep 0.1
  sketchybar --set front_app \
    popup.drawing=off \
    label="${INFO:-$APP_NAME}" \
    icon="$("$CONFIG_DIR/plugins/icon_map_fn.sh" "${INFO:-$APP_NAME}")"
  exit 0
fi

# 1. User clicked the icon → Toggle menu + rebuild
if [ "$SENDER" = "front_app_popup_trigger" ]; then
  "$CONFIG_DIR/plugins/build_front_popup.sh"

  POPUP_STATE=$(sketchybar --query front_app | jq -r '.popup.drawing')
  if [ "$POPUP_STATE" = "on" ]; then
    sketchybar --animate sin 10 --set front_app popup.y_offset=-15 popup.drawing=off label="$INFO" icon="$("$CONFIG_DIR/plugins/icon_map_fn.sh" "$INFO")"
  else
    sketchybar --animate sin 10 --set front_app popup.y_offset=10 popup.drawing=on label="$INFO" icon="$("$CONFIG_DIR/plugins/icon_map_fn.sh" "$INFO")"
  fi
  exit 0
fi

# 2. App focus changed (within same workspace)
if [ "$SENDER" = "front_app_switched" ]; then
  APP="${APP_NAME:-$INFO}"
  sketchybar --set front_app \
    label="$APP" \
    icon="$("$CONFIG_DIR/plugins/icon_map_fn.sh" "$APP")"

  "$CONFIG_DIR/plugins/build_front_popup.sh"
  exit 0
fi

# 3. Workspace changed
if [ "$SENDER" = "aerospace_workspace_change" ]; then
  "$CONFIG_DIR/plugins/build_front_popup.sh"
  # sketchybar --set front_app popup.drawing=off
  exit 0
fi
