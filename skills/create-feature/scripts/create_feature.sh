#!/bin/bash

# Skill script to generate initial feature structure in an Android project.

FEATURE_NAME=$1

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ -z "$FEATURE_NAME" ]; then
    echo "Android Feature Creator"
    echo "Usage: bash create_feature.sh <feature_name> [base_feature_path] [package_name]"
    echo ""
    echo "Arguments:"
    echo "  feature_name         camelCase name of the new feature (e.g. userProfile, billing)"
    echo "  base_feature_path    (Optional) Path to feature directory (e.g. project/app/src/main/java/com/example/app/feature)"
    echo "  package_name         (Optional) Base package name (e.g. com.example.app)"
    echo ""
    echo "Example:"
    echo "  bash create_feature.sh userProfile"
    if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        exit 0
    else
        exit 1
    fi
fi

FEATURE_NAME_PASCAL="$(tr '[:lower:]' '[:upper:]' <<< ${FEATURE_NAME:0:1})${FEATURE_NAME:1}"

# Try to auto-detect base feature path and package name if not provided
FEATURE_ROOT_DIR="$2"
PACKAGE_NAME="$3"

if [ -z "$FEATURE_ROOT_DIR" ]; then
    # Look for existing feature directory under src/main (ignoring build folders)
    DETECTED_DIR=$(find . -maxdepth 8 -type d \( -name "feature" -o -name "features" \) 2>/dev/null | grep -v "/build/" | head -n 1)
    if [ -n "$DETECTED_DIR" ]; then
        FEATURE_ROOT_DIR="$DETECTED_DIR"
    elif [ -d "app/src/main/java" ]; then
        FEATURE_ROOT_DIR="app/src/main/java/[ProjectPackage]/feature"
    elif [ -d "project/app/src/main/java" ]; then
        FEATURE_ROOT_DIR="project/app/src/main/java/[ProjectPackage]/feature"
    else
        FEATURE_ROOT_DIR="app/src/main/java/[ProjectPackage]/feature"
    fi
fi

BASE_PATH="$FEATURE_ROOT_DIR/$FEATURE_NAME"

if [ -z "$PACKAGE_NAME" ]; then
    if [[ "$FEATURE_ROOT_DIR" =~ src/main/(java|kotlin)/(.+)/feature[s]? ]]; then
        PACKAGE_NAME=$(echo "${BASH_REMATCH[2]}" | tr '/' '.')
    elif [[ "$FEATURE_ROOT_DIR" =~ src/main/(java|kotlin)/(.+) ]]; then
        PACKAGE_NAME=$(echo "${BASH_REMATCH[2]}" | tr '/' '.')
    else
        PACKAGE_NAME="[ProjectPackage]"
    fi
fi

echo "Creating feature structure for: $FEATURE_NAME"
echo "Location: $BASE_PATH"
echo "Package: $PACKAGE_NAME.feature.$FEATURE_NAME"

mkdir -p "$BASE_PATH/domain"
mkdir -p "$BASE_PATH/presentation/components"
mkdir -p "$BASE_PATH/navigation"

cat <<EOF > "$BASE_PATH/navigation/${FEATURE_NAME_PASCAL}Navigation.kt"
package $PACKAGE_NAME.feature.$FEATURE_NAME.navigation

import androidx.navigation.NavController
import androidx.navigation.NavGraphBuilder

fun NavGraphBuilder.setup${FEATURE_NAME_PASCAL}Navigation(navController: NavController) {
    // TODO: Setup navigation graph for $FEATURE_NAME
}
EOF

cat <<EOF > "$BASE_PATH/navigation/${FEATURE_NAME_PASCAL}Screen.kt"
package $PACKAGE_NAME.feature.$FEATURE_NAME.navigation

import kotlinx.serialization.Serializable

@Serializable
sealed interface ${FEATURE_NAME_PASCAL}Screen {
    // TODO: Define screens here
}
EOF

echo "Feature structure and navigation files created successfully at $BASE_PATH"
