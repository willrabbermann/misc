#!/bin/bash

# This script disables AI features and the new sidebar in Firefox.
# It works by modifying the user's prefs.js file.

killall firefox

# Find the Firefox profile directory.
# This assumes a default installation on Linux/macOS.
FIREFOX_PROFILE_DIR=$(find ~/.mozilla/firefox/ -name "*.default-release")

if [ -z "$FIREFOX_PROFILE_DIR" ]; then
    echo "Error: Could not find the Firefox profile directory."
    exit 1
fi

PREFS_FILE="$FIREFOX_PROFILE_DIR/prefs.js"

if [ ! -f "$PREFS_FILE" ]; then
    echo "Error: prefs.js not found in the profile directory."
    exit 1
fi

echo "Found Firefox profile: $FIREFOX_PROFILE_DIR"
echo "Modifying $PREFS_FILE"
echo "Disabling AI and sidebar features..."

# List of AI preferences to disable new features.
AI_PREFS=(
    # Disables machine learning features
    'user_pref("browser.ml.enable", false);'
    # Disables the new chat/AI features
    'user_pref("browser.ml.chat.enabled", false);'
    # Disables the chat option in the context menu
    'user_pref("browser.ml.chat.menu", false);'
    # Disables the AI page for chat
    'user_pref("browser.ml.chat.page", false);'
    # Removes the badge in the footer of the chat page
    'user_pref("browser.ml.chat.page.footerBadge", false);'
    # Removes the badge on the chat menu button
    'user_pref("browser.ml.chat.page.menuBadge", false);'
    # Disables keyboard shortcuts for chat
    'user_pref("browser.ml.chat.shortcuts", false);'
    # Disables the chat sidebar
    'user_pref("browser.ml.chat.sidebar", false);'
    # Disables link previews that use AI
    'user_pref("browser.ml.linkPreview.enabled", false);'
    # Disables smart tab grouping
    'user_pref("browser.tabs.groups.smart.enabled", false);'
    # Disables AI extensions
    'user_pref("extensions.ml.enabled", false);'
)

# A function to update or add a preference line.
update_pref() {
    local pref_line="$1"
    local pref_name=$(echo "$pref_line" | awk -F'"' '{print $2}')

    if grep -q "$pref_name" "$PREFS_FILE"; then
        # Preference exists, so update it.
        sed -i "s|.*$pref_name.*|$pref_line|" "$PREFS_FILE"
        echo "Updated preference: $pref_name"
    else
        # Preference does not exist, so add it.
        echo "$pref_line" >> "$PREFS_FILE"
        echo "Added new preference: $pref_name"
    fi
}

# Process new preferences.
for pref in "${AI_PREFS[@]}"; do
    update_pref "$pref"
done
