#!/bin/bash

# Open a new tab in iTerm2 and execute the command './tssh.sh'

# Create an AppleScript command to open a new iTerm2 tab and run the script
osascript -e '
tell application "iTerm"
    activate
    tell current window
        create tab with default profile
        tell current session of last tab
            write text "tssh.sh"
        end tell
    end tell
end tell
'
