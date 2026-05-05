#!/bin/bash

# Skill script to generate initial screen structure.

FEATURE_UI_PATH=$1
SCREEN_NAME=$2

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ -z "$FEATURE_UI_PATH" ] || [ -z "$SCREEN_NAME" ]; then
    echo "AvaloniaUI Screen Creator"
    echo "Usage: bash create_screen.sh <feature_ui_path> <screen_name>"
    echo ""
    echo "Arguments:"
    echo "  feature_ui_path    Path to the UI folder of a feature (e.g., Src/Features/Malpa/UI)"
    echo "  screen_name        Name of the new screen in PascalCase (e.g., MyNewScreen)"
    echo ""
    echo "Example:"
    echo "  bash create_screen.sh Src/Features/Malpa/UI Pies"
    
    if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        exit 0
    else
        exit 1
    fi
fi

if [[ "$FEATURE_UI_PATH" == /* ]]; then
    # is absolute
    FEATURE_UI_PATH=${FEATURE_UI_PATH#*[ProjectNamespace]/}
fi

# Remove trailing slashes and "[ProjectNamespace]/" from the beginning
FEATURE_UI_PATH=$(echo "$FEATURE_UI_PATH" | sed 's:/*$::')
if [[ "$FEATURE_UI_PATH" == [ProjectNamespace]/* ]]; then
    FEATURE_UI_PATH=${FEATURE_UI_PATH#[ProjectNamespace]/}
fi

DEST_DIR="$FEATURE_UI_PATH/Screens/$SCREEN_NAME"
mkdir -p "$DEST_DIR/ScreenStyles"

# Replace slashes with dots for namespace
REL_DOTS=$(echo "$DEST_DIR" | tr '/' '.')

NAMESPACE="[ProjectNamespace].$REL_DOTS"

# Convert to kebab-case (e.g. WielkaMalpa -> wielka-malpa)
KEBAB_NAME=$(echo "$SCREEN_NAME" | sed -r 's/([a-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')

VM_FILE="$DEST_DIR/${SCREEN_NAME}ViewModel.cs"
CB_FILE="$DEST_DIR/${SCREEN_NAME}View.axaml.cs"
XAML_FILE="$DEST_DIR/${SCREEN_NAME}View.axaml"

cat <<EOF > "$VM_FILE"
using ReactiveUI;
using ReactiveUI.SourceGenerators;
using [ProjectNamespace].Src.Core.Mvvm;

namespace $NAMESPACE;

public partial class ${SCREEN_NAME}ViewModel : ViewModelBase, IRoutableViewModel
{
    public string? UrlPathSegment => "$KEBAB_NAME";
    public IScreen HostScreen { get; }

    public ${SCREEN_NAME}ViewModel(IScreen hostScreen)
    {
        HostScreen = hostScreen;
    }
}
EOF

cat <<EOF > "$CB_FILE"
using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using Avalonia.ReactiveUI;
using ReactiveUI;

namespace $NAMESPACE;

public partial class ${SCREEN_NAME}View : ReactiveUserControl<${SCREEN_NAME}ViewModel>
{
    public ${SCREEN_NAME}View()
    {
        InitializeComponent();
        this.WhenActivated(disposables => 
        { 
        });
    }
}
EOF

cat <<EOF > "$XAML_FILE"
<rxui:ReactiveUserControl x:TypeArguments="local:${SCREEN_NAME}ViewModel"
                          x:DataType="local:${SCREEN_NAME}ViewModel"
                          xmlns="https://github.com/avaloniaui"
                          xmlns:local="using:$NAMESPACE"
                          xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
                          xmlns:rxui="http://reactiveui.net"
                          x:Class="$NAMESPACE.${SCREEN_NAME}View">

    <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center">
        <TextBlock Text="${SCREEN_NAME} Screen" FontSize="20" FontWeight="Bold"/>
    </StackPanel>
</rxui:ReactiveUserControl>
EOF

MD_FILE="$DEST_DIR/Screen.md"

cat <<EOF > "$MD_FILE"
# ${SCREEN_NAME} Screen

## Purpose
[Describe the purpose of this screen here]

## Functionalities
- [List functionalities here]

## Key UI Elements
- [List key UI elements here]
EOF

echo "Successfully created Screen: $SCREEN_NAME"
echo "Location: $DEST_DIR"
echo "Namespace: $NAMESPACE"
