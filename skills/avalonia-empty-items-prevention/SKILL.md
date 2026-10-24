---
name: avalonia-empty-items-prevention
description: Diagnoses and prevents empty/blank items in Avalonia UI collection controls (ComboBox, ListBox, ItemsControl, TabControl). Use when creating, binding, or styling collection controls with models or strings.
---

# Avalonia Empty / Blank Items Prevention in Collection Controls

## When to use this skill

Use this skill whenever:
- Creating, modifying, or binding collection controls (`ComboBox`, `ListBox`, `ItemsControl`, `AutoCompleteBox`, `TabControl`) in Avalonia UI.
- Items in a dropdown list or listbox appear blank/empty with no text, even though items exist, have height, and highlight/select when hovered or clicked.
- Binding `ItemsSource` in XAML or code-behind (`this.OneWayBind`) to collections of models, records, ViewModels, or strings.
- Working with `ComboBox` dropdown sizing (preventing popups from covering the entire window).
- Migrating WPF/Silverlight/MAUI code that relied on `DisplayMemberPath` or automatic `ToString()` fallback.

---

## Root Causes of Blank / Empty Items in Avalonia

### 1. Missing `ItemTemplate` (No Reliable Fallback)
In Avalonia 11, collection controls (such as `ComboBox` and `ListBox`) generate container items (`ComboBoxItem`, `ListBoxItem`) containing an internal `ContentPresenter`.

- Unlike WPF or Windows Forms, Avalonia **does not reliably fall back to wrapping `obj.ToString()` into a visible TextBlock** when a template is missing.
- When ReactiveUI's `ViewLocator` or a custom `IViewLocator` is registered, Avalonia queries it for data templates. Because `ViewLocator` only resolves `IViewFor<TViewModel>` for routed views, it returns `null` for models and strings, causing `ContentPresenter` to render blank content.
- **CRITICAL**: This applies even to collections of simple strings (`IReadOnlyList<string>`)! Without an explicit `ItemTemplate`, string items often have height and selection highlights, but render zero visible text.

### 2. The `DisplayMemberPath` Fallacy
In WPF, developers frequently write:
```xml
<!-- ❌ DOES NOT EXIST IN AVALONIA 11 -->
<ComboBox DisplayMemberPath="Name" ItemsSource="{Binding Items}" />
```
Avalonia 11 **does not have a `DisplayMemberPath` property**. Avalonia relies entirely on its `DataTemplate` system.

### 3. Missing `MaxDropDownHeight` on ComboBox
By default in Avalonia, `ComboBox` has an unbounded or extremely large dropdown height. When displaying collections with many items (e.g., hours or days), the popup can expand vertically across the entire window or screen.

---

## Solutions & Best Practices

### Pattern 1: Explicit `ItemTemplate` for Models and Records (Recommended)
Always declare `<Control.ItemTemplate>` directly inside the control when binding to domain models or records.

```xml
<ComboBox x:Name="AudioOutputDeviceComboBox"
          HorizontalAlignment="Stretch"
          MaxDropDownHeight="240">
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

---

### Pattern 2: Explicit `ItemTemplate` for Simple Strings (`x:String`)
Even when binding `ItemsSource` to a simple `IReadOnlyList<string>`, **ALWAYS** provide an explicit `DataTemplate` with `x:DataType="x:String"`. Do not rely on implicit string rendering.

```xml
<ComboBox x:Name="HoursComboBox"
          HorizontalAlignment="Stretch"
          MaxDropDownHeight="240">
    <ComboBox.ItemTemplate>
        <DataTemplate x:DataType="x:String">
            <TextBlock Text="{Binding}" VerticalAlignment="Center" />
        </DataTemplate>
    </ComboBox.ItemTemplate>
</ComboBox>
```

---

### Pattern 3: Window-Level or Control-Level `DataTemplates`
If a model is displayed in multiple places across the same screen:

```xml
<Window.DataTemplates>
    <DataTemplate DataType="models:AudioDevice">
        <TextBlock Text="{Binding Name}" VerticalAlignment="Center" />
    </DataTemplate>
</Window.DataTemplates>
```
With this in place, any `ComboBox`, `ListBox`, or `ContentControl` in that window presenting an `AudioDevice` will automatically use this template.

---

### Pattern 4: Always Restrict `MaxDropDownHeight` for Long Lists
Whenever a `ComboBox` can display more than 8–10 items, set `MaxDropDownHeight="200"` or `MaxDropDownHeight="240"`. This ensures a compact, scrollable dropdown menu that never covers the window.

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

- [ ] Does EVERY `ComboBox` or `ListBox` have an explicit `<Control.ItemTemplate>` containing a `<DataTemplate>` (even for plain `string` / `x:String` collections)?
- [ ] Is `x:DataType` specified on the `<DataTemplate>` (e.g. `x:DataType="models:YourModel"` or `x:DataType="x:String"`)?
- [ ] Does the `DataTemplate` contain an element (e.g. `<TextBlock Text="{Binding DisplayProp}" />` or `<TextBlock Text="{Binding}" />`)?
- [ ] Is `MaxDropDownHeight` explicitly configured (e.g. `MaxDropDownHeight="240"`) on `ComboBox` controls with many items?
- [ ] If using dark theme / custom styling, is text contrast preserved (e.g. `VerticalAlignment="Center"` and standard foreground)?
