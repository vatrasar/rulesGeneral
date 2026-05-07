#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <feature_ui_path> <screen_name>"
    exit 1
fi

FEATURE_UI_PATH=$1
SCREEN_NAME=$2
# We assume screens go into a 'Screens' subfolder within the UI folder
SCREEN_PATH="$FEATURE_UI_PATH/Screens/$SCREEN_NAME"

echo "Creating screen structure for: $SCREEN_NAME in $FEATURE_UI_PATH"

mkdir -p "$SCREEN_PATH/ScreenComponents"
mkdir -p "$SCREEN_PATH/ScreenStyles"

# Make them Python packages
touch "$SCREEN_PATH/__init__.py"
touch "$SCREEN_PATH/ScreenComponents/__init__.py"
touch "$SCREEN_PATH/ScreenStyles/__init__.py"

echo "Structure created at $SCREEN_PATH"
