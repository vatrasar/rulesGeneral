#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <feature_name>"
    exit 1
fi

FEATURE_NAME=$1
# We assume the project structure starts with src/features/
FEATURE_PATH="src/features/$FEATURE_NAME"

echo "Creating feature structure for: $FEATURE_NAME"

mkdir -p "$FEATURE_PATH/ui/feature_styles"
mkdir -p "$FEATURE_PATH/ui/feature_components"
mkdir -p "$FEATURE_PATH/domain"
mkdir -p "$FEATURE_PATH/resources"

echo "Structure created at $FEATURE_PATH"
