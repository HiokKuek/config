#!/bin/bash

source "$CONFIG_DIR/colors.sh"

sketchybar --remove '/front_window_.*/'

WORKSPACE="$(aerospace list-workspaces --focused | head -n 1)"
WINDOWS=$(aerospace list-windows --workspace "$WORKSPACE")
FOCUSED_ID=$(aerospace list-windows --focused | awk -F'|' '{print $1}' | xargs)

WINDOW_COUNT=$(echo "$WINDOWS" | wc -l)
WINDOW_LESS=$(echo "$WINDOW_COUNT * 3.9" | bc)
AVAILABLE_WIDTH=1470 # Total bar width minus padding (example: 1512 - 20)
ITEM_WIDTH=$(echo "scale=2; ($AVAILABLE_WIDTH / $WINDOW_COUNT) - $WINDOW_LESS" | bc | xargs printf "%.0f")

# Prepare arrays
PROJECTS=()
WINDOW_IDS=()

> "$HOME/.cache/project_window_map_${WORKSPACE}"

COUNTER=1

echo "$WINDOWS" | while IFS= read -r line; do
  ID=$(echo "$line" | awk -F'|' '{print $1}' | xargs)
  APP=$(echo "$line" | awk -F'|' '{print $2}' | xargs)
  RAW_TITLE=$(echo "$line" | awk -F'|' '{print $3}' | xargs)

  if [[ "$APP" == "Cursor" ]]; then
    if [[ "$RAW_TITLE" == *"—"* ]]; then
      TITLE=$(echo "$RAW_TITLE" | awk -F'—' '{print $2}' | xargs)
    else
      TITLE="$RAW_TITLE"
    fi
  else
    TITLE="$APP-$COUNTER"
  fi

  PROJECTS+=("$TITLE")
  WINDOW_IDS+=("$ID")

  if ! grep -q "|$ID" "$HOME/.cache/project_window_map_${WORKSPACE}"; then
    echo "$TITLE|$ID" >> "$HOME/.cache/project_window_map_${WORKSPACE}"
  fi

  ICON=$("$CONFIG_DIR/plugins/icon_map.sh" "$APP")
  ITEM_ID="front_window_$ID"

  if [ "$ID" = "$FOCUSED_ID" ]; then
    BG_COLOR=$POPUP_ACTIVE_BG_COLOR
  else
    BG_COLOR=$POPUP_BG_COLOR
  fi

  sketchybar --add item "$ITEM_ID" popup.front_app \
             --set "$ITEM_ID" \
               label="$TITLE" \
               label.align=center \
               label.padding_left=5 \
               label.font="Pro:Semibold:12.0" \
               label.padding_right=5 \
               icon="$("$CONFIG_DIR/plugins/icon_map_fn.sh" "$APP")" \
               icon.font="sketchybar-app-font:Regular:12.0" \
               padding_left=10 \
               padding_right=10 \
               width=$ITEM_WIDTH \
               click_script="aerospace focus --window-id $ID; sketchybar --trigger front_app_switched; sketchybar --trigger front_app_popup_trigger;" \
               background.color=$BG_COLOR

  COUNTER=$((COUNTER + 1))
done
