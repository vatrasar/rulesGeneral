#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <feature_name>"
    exit 1
fi

FEATURE_NAME=$1
# We assume the project structure starts with Src/Features/
FEATURE_PATH="Src/Features/$FEATURE_NAME"

echo "Creating feature structure for: $FEATURE_NAME"

mkdir -p "$FEATURE_PATH/UI/FeatureStyles"
mkdir -p "$FEATURE_PATH/UI/FeatureComponents"
mkdir -p "$FEATURE_PATH/Domain"
mkdir -p "$FEATURE_PATH/Resources"

echo "Structure created at $FEATURE_PATH"
