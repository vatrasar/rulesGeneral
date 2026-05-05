#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <featureName>"
    echo "Example: $0 userProfile"
    exit 1
fi

FEATURE_NAME=$1
FEATURE_NAME_PASCAL="$(tr '[:lower:]' '[:upper:]' <<< ${FEATURE_NAME:0:1})${FEATURE_NAME:1}"
PACKAGE_NAME="com.example.flashcardexpress"
BASE_PATH="flashcardExpress/app/src/main/java/com/example/flashcardexpress/feature/$FEATURE_NAME"

echo "Creating feature structure for: $FEATURE_NAME"

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

echo "Feature structure and navigation files created at $BASE_PATH"
