#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <feature_ui_path> <screen_name>"
    exit 1
fi

FEATURE_UI_PATH=$1
SCREEN_NAME=$2
# We assume screens go into a 'screens' subfolder within the UI folder
SCREEN_PATH="$FEATURE_UI_PATH/screens/$SCREEN_NAME"

echo "Creating screen structure for: $SCREEN_NAME in $FEATURE_UI_PATH"

mkdir -p "$SCREEN_PATH/screen_components"
mkdir -p "$SCREEN_PATH/screen_styles"

echo "Structure created at $SCREEN_PATH"
