#!/bin/bash

# Skill script to generate initial screen structure for Rust + Slint.

FEATURE_PATH=$1
SCREEN_NAME_INPUT=$2

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ -z "$FEATURE_PATH" ] || [ -z "$SCREEN_NAME_INPUT" ]; then
    echo "Slint + Rust Screen Creator"
    echo "Usage: bash create_screen.sh <feature_path> <screen_name>"
    echo ""
    echo "Arguments:"
    echo "  feature_path       Path to the feature folder (e.g., src/features/reports)"
    echo "  screen_name        Name of the new screen (e.g., Overview or MonthlyReport)"
    echo ""
    echo "Example:"
    echo "  bash create_screen.sh src/features/reports MonthlyReport"
    
    if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        exit 0
    else
        exit 1
    fi
fi

# Clean trailing slashes
FEATURE_PATH=$(echo "$FEATURE_PATH" | sed 's:/*$::')

# Convert screen name to snake_case and PascalCase
SNAKE_SCREEN=$(echo "$SCREEN_NAME_INPUT" | sed -r 's/([a-z0-9])([A-Z])/\1_\2/g' | tr '[:upper:]' '[:lower:]')
PASCAL_SCREEN=$(echo "$SNAKE_SCREEN" | perl -pe 's/(^|_)./uc($&)/ge;s/_//g')

DEST_DIR="$FEATURE_PATH/ui/screens/$SNAKE_SCREEN"
mkdir -p "$DEST_DIR/ScreenComponents"

# 1. Generate Slint screen file
SLINT_FILE="$DEST_DIR/${PASCAL_SCREEN}Screen.slint"
cat <<EOF > "$SLINT_FILE"
import { Button, VerticalBox } from "std-widgets.slint";

export component ${PASCAL_SCREEN}Screen inherits Rectangle {
    in property <string> title: "${PASCAL_SCREEN} Screen";
    callback back_clicked();

    VerticalBox {
        alignment: center;
        spacing: 16px;

        Text {
            text: root.title;
            font-size: 20px;
            font-weight: 700;
            horizontal-alignment: center;
        }

        Button {
            text: @tr("Back");
            clicked => { root.back_clicked(); }
        }
    }
}
EOF

# 2. Generate Rust controller file
CONTROLLER_FILE="$DEST_DIR/${SNAKE_SCREEN}_controller.rs"
cat <<EOF > "$CONTROLLER_FILE"
//! Controller for the ${PASCAL_SCREEN} screen.

use slint::ComponentHandle;
use crate::ui::AppWindow;

pub struct ${PASCAL_SCREEN}ScreenController;

impl ${PASCAL_SCREEN}ScreenController {
    /// Sets up Slint callbacks for ${PASCAL_SCREEN}Screen.
    pub fn setup(ui: &AppWindow) {
        let _ui_weak = ui.as_weak();

        // Register screen callbacks here
    }
}
EOF

# 3. Generate Screen.md documentation
MD_FILE="$DEST_DIR/Screen.md"
cat <<EOF > "$MD_FILE"
# ${PASCAL_SCREEN} Screen

## Purpose
[Describe the purpose of this screen here]

## Functionalities
- [List functionalities here]

## Key UI Elements
- [List key UI elements here]

## Navigation
- **Navigate From:** [Screens that lead to this screen]
- **Navigate To:** [Screens accessible from this screen]
EOF

echo "Successfully created Screen: ${PASCAL_SCREEN}Screen ($SNAKE_SCREEN)"
echo "Location: $DEST_DIR"
