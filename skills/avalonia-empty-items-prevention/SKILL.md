---
name: avalonia-empty-items-prevention
description: Diagnoses and prevents empty/blank items in Avalonia UI collection controls (ComboBox, ListBox, ItemsControl, TabControl). Use when binding ItemsSource to complex objects/models
---

# Avalonia Empty / Blank Items Prevention in Collection Controls

## When to use this skill

Use this skill whenever:
- Creating, modifying, or binding collection controls (`ComboBox`, `ListBox`, `ItemsControl`, `AutoCompleteBox`, `TabControl`) in Avalonia UI.
- Items in a dropdown list or listbox appear blank/empty with no text, even though items exist, have height, and highlight/select when hovered or clicked.
- Binding `ItemsSource` in XAML or code-behind (`this.OneWayBind`) to a collection of complex objects, records, models, or ViewModels.
- Migrating WPF/Silverlight/MAUI code that relied on `DisplayMemberPath` or automatic `ToString()` fallback.

---

## Root Causes of Blank / Empty Items in Avalonia

### 1. Missing `ItemTemplate` for Complex Objects (No Automatic `ToString()`)
In Avalonia 11, collection controls (such as `ComboBox` and `ListBox`) generate container items (`ComboBoxItem`, `ListBoxItem`) containing an internal `ContentPresenter`.

When `ContentPresenter.Content` is set to an object that is **not a `string` and not an Avalonia `Control`** (such as a domain model or record):
- Avalonia looks for an `IDataTemplate` matching the object's type in `ItemTemplate`, local `Resources`, `Window.DataTemplates`, or `Application.DataTemplates`.
- Unlike WPF or Windows Forms, Avalonia **does not automatically fall back to wrapping `obj.ToString()` into a visible TextBlock** when a template is missing.
- When no template matches, the `ContentPresenter` renders empty content. The item exists, occupies vertical space, and responds to pointer selection (e.g. blue accent background), but displays **no text**.

### 2. The `DisplayMemberPath` Fallacy
In WPF, developers frequently write:
```xml
<!-- ❌ DOES NOT EXIST IN AVALONIA 11 -->
<ComboBox DisplayMemberPath="Name" ItemsSource="{Binding Items}" />
```
Avalonia 11 **does not have a `DisplayMemberPath` property**. Avalonia relies entirely on its `DataTemplate` system.

### 3. Custom `IViewLocator` Returns `null` for Models
When ReactiveUI's `ViewLocator` or a custom `IViewLocator` is registered, Avalonia queries it for data templates. Because `ViewLocator` only resolves `IViewFor<TViewModel>` for routed views, it returns `null` for domain models, leaving the item unrendered.

---

## Solutions & Best Practices

### Pattern 1: Explicit `ItemTemplate` with Typed `DataTemplate` (Recommended)
Always declare `<Control.ItemTemplate>` directly inside the control when binding to domain models or records.

```xml
<ComboBox x:Name="AudioOutputDeviceComboBox"
          HorizontalAlignment="Stretch">
    <ComboBox.ItemTemplate>
        <DataTemplate x:DataType="models:AudioDevice">
            <TextBlock Text="{Binding Name}" VerticalAlignment="Center" />
        </DataTemplate>
    </ComboBox.ItemTemplate>
</ComboBox>
```

#### Key Requirements:
1. **Declare the namespace** at the root element:
   ```xml
   xmlns:models="using:MyProject.Core.Domain.Models"
   ```
2. **Specify `x:DataType`** on `<DataTemplate>` for compile-time safety and optimal performance.
3. **Use `{Binding PropertyName}`** inside the `DataTemplate` for the specific display property.

### Pattern 2: Window-Level or Control-Level `DataTemplates`
If a model is displayed in multiple places across the same screen:

```xml
<Window.DataTemplates>
    <DataTemplate DataType="models:AudioDevice">
        <TextBlock Text="{Binding Name}" VerticalAlignment="Center" />
    </DataTemplate>
</Window.DataTemplates>
```
With this in place, any `ComboBox`, `ListBox`, or `ContentControl` in that window presenting an `AudioDevice` will automatically use this template without needing a repeated `<ComboBox.ItemTemplate>`.

### Pattern 3: Simple String Collections (When No Metadata Needed)
If the items do not need accompanying IDs or metadata, bind `ItemsSource` to a simple `IReadOnlyList<string>`. Avalonia's `ContentPresenter` natively renders strings inside a TextBlock without requiring an explicit template.

---

## Code-Behind Binding Pattern (ReactiveUI)

When adhering to code-behind binding rules (no `{Binding ...}` on root controls):

```csharp
this.WhenActivated(disposables =>
{
    // Bind items collection to ItemsSource
    this.OneWayBind(ViewModel, vm => vm.AvailableAudioDevices, view => view.AudioOutputDeviceComboBox.ItemsSource);

    // Two-way bind selected item with explicit converter
    this.Bind(ViewModel, vm => vm.SelectedAudioDevice, view => view.AudioOutputDeviceComboBox.SelectedItem, dev => dev, obj => obj as AudioDevice);
});
```

---

## Checklist for Collection Controls

- [ ] Is `ItemsSource` bound to a collection of objects (records, classes, models) rather than plain strings?
- [ ] Does the control have an explicit `<Control.ItemTemplate>` containing a `<DataTemplate>`?
- [ ] Is `x:DataType="models:YourModel"` specified on the `<DataTemplate>`?
- [ ] Is the model's namespace declared on the root element with `xmlns:models="using:..."`?
- [ ] Does the `DataTemplate` contain an element (e.g. `<TextBlock Text="{Binding DisplayProp}" />`) to render the text?
- [ ] If using dark theme / custom styling, is text contrast preserved (e.g. `VerticalAlignment="Center"` and standard foreground)?
