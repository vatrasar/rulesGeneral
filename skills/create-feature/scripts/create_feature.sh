#!/bin/bash

# Skill script to generate initial feature structure for Rust + Slint.

FEATURE_INPUT=$1

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ -z "$FEATURE_INPUT" ]; then
    echo "Slint + Rust Feature Creator"
    echo "Usage: bash create_feature.sh <feature_name>"
    echo ""
    echo "Arguments:"
    echo "  feature_name       Name of the new feature (e.g., Reports or employee_management)"
    echo ""
    echo "Example:"
    echo "  bash create_feature.sh Reports"
    
    if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        exit 0
    else
        exit 1
    fi
fi

# Convert to snake_case for directories/modules and PascalCase for structs
SNAKE_NAME=$(echo "$FEATURE_INPUT" | sed -r 's/([a-z0-9])([A-Z])/\1_\2/g' | tr '[:upper:]' '[:lower:]')
PASCAL_NAME=$(echo "$SNAKE_NAME" | perl -pe 's/(^|_)./uc($&)/ge;s/_//g')

BASE_DIR="src/features/$SNAKE_NAME"

mkdir -p "$BASE_DIR/ui/screens"
mkdir -p "$BASE_DIR/ui/components"
mkdir -p "$BASE_DIR/domain/models"
mkdir -p "$BASE_DIR/domain/services"
mkdir -p "$BASE_DIR/domain/usecases"
mkdir -p "$BASE_DIR/domain/enums"

# 1. Create controller.rs
CONTROLLER_FILE="$BASE_DIR/controller.rs"
cat <<EOF > "$CONTROLLER_FILE"
//! Controller and Slint callback wiring for the ${PASCAL_NAME} feature.

use std::sync::Arc;
use slint::ComponentHandle;
use crate::ui::AppWindow;

pub struct ${PASCAL_NAME}Controller;

impl ${PASCAL_NAME}Controller {
    /// Sets up Slint UI callbacks and event listeners for ${PASCAL_NAME}.
    pub fn setup(ui: &AppWindow) {
        let _ui_weak = ui.as_weak();

        // Register feature callbacks here
    }
}
EOF

# 2. Create mod.rs
MOD_FILE="$BASE_DIR/mod.rs"
cat <<EOF > "$MOD_FILE"
pub mod controller;
pub mod domain;

pub use controller::${PASCAL_NAME}Controller;
EOF

# 3. Create domain/mod.rs
cat <<EOF > "$BASE_DIR/domain/mod.rs"
pub mod models;
pub mod services;
pub mod usecases;
pub mod enums;
EOF

# 4. Create feature .slint file
SLINT_FILE="$BASE_DIR/ui/${SNAKE_NAME}.slint"
cat <<EOF > "$SLINT_FILE"
import { Button, VerticalBox } from "std-widgets.slint";

export component ${PASCAL_NAME}View inherits Rectangle {
    in property <string> title: "${PASCAL_NAME}";
    callback action_clicked();

    VerticalBox {
        alignment: center;
        spacing: 12px;

        Text {
            text: root.title;
            font-size: 18px;
            horizontal-alignment: center;
        }

        Button {
            text: @tr("Action");
            clicked => { root.action_clicked(); }
        }
    }
}
EOF

echo "Successfully created Feature: $PASCAL_NAME ($SNAKE_NAME)"
echo "Location: $BASE_DIR"
