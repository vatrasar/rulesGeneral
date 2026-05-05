#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <featureName> <ScreenName>"
    echo "Example: $0 questionManagement ManagePanel"
    exit 1
fi

FEATURE_NAME=$1
SCREEN_NAME=$2
# Lowercase the first letter for the directory name
SCREEN_DIR_NAME="$(tr '[:upper:]' '[:lower:]' <<< ${SCREEN_NAME:0:1})${SCREEN_NAME:1}"
PACKAGE_NAME="com.example.flashcardexpress"
BASE_PATH="flashcardExpress/app/src/main/java/com/example/flashcardexpress/feature/$FEATURE_NAME/presentation/$SCREEN_DIR_NAME"

echo "Creating screen files for: $SCREEN_NAME in feature $FEATURE_NAME"

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
import com.example.flashcardexpress.common.viewModel.BaseScreenAndNavEffectsViewModel
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
