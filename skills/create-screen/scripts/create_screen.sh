#!/bin/bash

# Skill script to generate initial screen structure in an Android project.

FEATURE_NAME=$1
SCREEN_NAME=$2

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ -z "$FEATURE_NAME" ] || [ -z "$SCREEN_NAME" ]; then
    echo "Android Screen Creator"
    echo "Usage: bash create_screen.sh <feature_name> <ScreenName> [base_feature_path] [package_name]"
    echo ""
    echo "Arguments:"
    echo "  feature_name         camelCase name of the feature (e.g. questionManagement)"
    echo "  ScreenName           PascalCase name of the screen (e.g. ManagePanel)"
    echo "  base_feature_path    (Optional) Path to feature directory"
    echo "  package_name         (Optional) Base package name"
    echo ""
    echo "Example:"
    echo "  bash create_screen.sh questionManagement ManagePanel"
    if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        exit 0
    else
        exit 1
    fi
fi

SCREEN_DIR_NAME="$(tr '[:upper:]' '[:lower:]' <<< ${SCREEN_NAME:0:1})${SCREEN_NAME:1}"

FEATURE_ROOT_DIR="$3"
PACKAGE_NAME="$4"

if [ -z "$FEATURE_ROOT_DIR" ]; then
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

BASE_PATH="$FEATURE_ROOT_DIR/$FEATURE_NAME/presentation/$SCREEN_DIR_NAME"

if [ -z "$PACKAGE_NAME" ]; then
    if [[ "$FEATURE_ROOT_DIR" =~ src/main/(java|kotlin)/(.+)/feature[s]? ]]; then
        PACKAGE_NAME=$(echo "${BASH_REMATCH[2]}" | tr '/' '.')
    elif [[ "$FEATURE_ROOT_DIR" =~ src/main/(java|kotlin)/(.+) ]]; then
        PACKAGE_NAME=$(echo "${BASH_REMATCH[2]}" | tr '/' '.')
    else
        PACKAGE_NAME="[ProjectPackage]"
    fi
fi

echo "Creating screen files for: $SCREEN_NAME in feature $FEATURE_NAME"
echo "Location: $BASE_PATH"
echo "Package: $PACKAGE_NAME.feature.$FEATURE_NAME.presentation.$SCREEN_DIR_NAME"

mkdir -p "$BASE_PATH"

# Contract
cat <<EOF > "$BASE_PATH/${SCREEN_NAME}Contract.kt"
package $PACKAGE_NAME.feature.$FEATURE_NAME.presentation.$SCREEN_DIR_NAME

import androidx.compose.runtime.Immutable

sealed class ${SCREEN_NAME}Effect {
}

sealed class ${SCREEN_NAME}NavEffect {
}

sealed class ${SCREEN_NAME}Event {
}

@Immutable
data class ${SCREEN_NAME}State(
    val isLoading: Boolean = false
)
EOF

# ViewModel
cat <<EOF > "$BASE_PATH/${SCREEN_NAME}ViewModel.kt"
package $PACKAGE_NAME.feature.$FEATURE_NAME.presentation.$SCREEN_DIR_NAME

import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject
import $PACKAGE_NAME.common.viewModel.BaseScreenAndNavEffectsViewModel
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

@HiltViewModel
class ${SCREEN_NAME}ViewModel @Inject constructor() : BaseScreenAndNavEffectsViewModel<${SCREEN_NAME}Effect, ${SCREEN_NAME}NavEffect>() {

    private val _state = MutableStateFlow(${SCREEN_NAME}State())
    val state: StateFlow<${SCREEN_NAME}State> = _state.asStateFlow()

    fun onEvent(event: ${SCREEN_NAME}Event) {
        when (event) {
            // TODO: Handle events
            else -> {}
        }
    }
}
EOF

# Screen
cat <<EOF > "$BASE_PATH/${SCREEN_NAME}Screen.kt"
package $PACKAGE_NAME.feature.$FEATURE_NAME.presentation.$SCREEN_DIR_NAME

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Modifier
import kotlinx.coroutines.flow.Flow

@Composable
fun ${SCREEN_NAME}Screen(
    state: ${SCREEN_NAME}State, 
    onEventFromViewModel: (${SCREEN_NAME}Event) -> Unit, 
    effectFromViewModel: Flow<${SCREEN_NAME}Effect>
) {
    LaunchedEffect(Unit) {
        effectFromViewModel.collect { effect ->
            // TODO: Handle effects
        }
    }

    Scaffold(
        modifier = Modifier.fillMaxSize()
    ) { paddingValues ->
        Column(modifier = Modifier.padding(paddingValues)) {
            Text("${SCREEN_NAME} Screen")
        }
    }
}
EOF

echo "Screen files created at $BASE_PATH"
