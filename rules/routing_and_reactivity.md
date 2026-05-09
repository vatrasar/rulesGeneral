# Routing and Reactivity

## Routing

The routing paths for a given feature should be registered in the NameModule.cs file of the given module.

Example:
For the "Malpa" feature for which the "pies" screen exists, we have the file MalpaModule.cs.

This file should generally look like this:

```cs
// skipping imports
namespace [ProjectNamespace].Features.Malpa;

public class MalpaModule : IFeatureModule
{
    public void Register(IMutableDependencyResolver services)
    {
         services.Register(() => new PiesView(), typeof(IViewFor<PiesViewModel>));
    }
}
```

Each module is automaticaly register using reflection in AppBootstrapper (you don't have to do it).

### rxui:RoutedViewHost

rxui:RoutedViewHost (that is, the place where views will change) is located in the shell feature, in the Host screen. The job of MainWindow is just to display the Host screen.

### Navigation between screens

If we want to navigate to the pies screen from some viewModel, we do this:

```cs
HostScreen.Router.Navigate.Execute(new PiesViewModel(HostScreen));
```

where HostScreen is an object of type IScreen. Every viewModel should have a property containing the IScreen, and it should be passed between viewModels during navigation in the constructor.


## Reactive State Management

### UI State Management Pattern (MVI-like)

When creating or modifying ViewModels for Screens or complex components, you MUST strictly adhere to the following State pattern rules:

1. **State Encapsulation**: Do not clutter the ViewModel with multiple `[Reactive]` properties. Instead, encapsulate all view-specific data into a single state class.
2. **State Definition**: The state MUST be defined as an immutable `record` (e.g., `DayDetailsState`). Use `init` setters for all properties. Place this file in the same folder as the ViewModel.
3. **Base Class**: The ViewModel MUST inherit from `ViewModelBase<TState>` located in `Src/Core/Mvvm/ViewModelBase.cs`. 
4. **State Updates**: To mutate the state, you MUST use the `UpdateState` method inherited from the base class, utilizing the `with` expression. 
   * *Correct*: `UpdateState(s => s with { IsLoading = true });`
   * *Incorrect*: `State.IsLoading = true;` or recreating the whole object manually without `UpdateState`.
5. **Collections**: Never use mutable collections like `List<T>` or `ObservableCollection<T>` inside the state record. You MUST use immutable collections from the `System.Collections.Immutable` namespace (e.g., `ImmutableList<T>`).
6. **XAML Bindings**: Always remember to prefix bindings in `.axaml` files with `State.`. 
   * *Correct*: `<TextBlock Text="{Binding State.EmployeeCount}" />`
   * *Incorrect*: `<TextBlock Text="{Binding EmployeeCount}" />`

### Binding strategy

* **Strict Prohibition**: Do not use `{Binding ...}` syntax in XAML (`.axaml`) files for dynamic data. - 

* **Code-Behind Bindings**: All data bindings, command bindings, and event-to-command mappings must be implemented in the View's Code-Behind (`.axaml.cs`) using ReactiveUI's type-safe binding methods. -

* **Required Pattern**: Use `this.Bind()`, `this.OneWayBind()`, and `this.BindCommand()` inside a `this.WhenActivated()` block. - 

* **Memory Management**: Every binding must be followed by `.DisposeWith(disposables)` to ensure proper cleanup and prevent memory leaks.

### reactive UI

- **ReactiveUI Source Generators (Fody/Generation):** Direct implementation of `INotifyPropertyChanged`, manual `RaiseAndSetIfChanged`, or manual `ReactiveCommand` instantiation is strictly forbidden.
  - **Property Declaration (For simple ViewModels only):** Use the `[Reactive]` attribute on private fields. For Screens and complex components, use the State Pattern described above instead.
  - **ReadOnly Properties (OAPH):** Use the `[ObservableAsProperty]` attribute.
  - **Commands:** Use the `[ReactiveCommand]` attribute on private methods. This automatically generates a `ReactiveCommand` property with the appropriate name

Correct Pattern:

```csharp
//...
using System.Reactive.Linq;
using ReactiveUI;
using ReactiveUI.SourceGenerators;

//...

public partial class ExampleViewModel : ViewModelBase
{
    [Reactive]
    private string _firstName = string.Empty;

    [ObservableAsProperty]
    private string? _fullName;

    // ✅ The generator creates "public IReactiveCommand SaveCommand"
    [ReactiveCommand]
    private async Task Save()
    {
        // Business logic for McDonald's Roster
        await Task.Delay(100); 
    }

    public ExampleViewModel()
    {
        this.WhenAnyValue(x => x.FirstName)
            .Select(name => $"User: {name}")
            .ToProperty(this, x => x.FullName);
    }
}
```

### ReactiveUI 20.x Binding Lifecycle



- **NO `.DisposeWith()` on Bind/OneWayBind/BindCommand:** In ReactiveUI 20.x, these methods return `IReactiveBinding<T>` which does NOT implement `IDisposable`. Do NOT chain `.DisposeWith(disposables)`. Bindings are automatically cleaned up when the view deactivates via `WhenActivated`.

- **`.DisposeWith()` ONLY for `IDisposable`:** Use `.DisposeWith(disposables)` only on `IDisposable` results (e.g., `Subscribe()` on `IObservable<T>`). Requires `using System.Reactive.Disposables;`.

### Subscribe in View Code-Behind

- **Use `Observer.Create<T>(action)` instead of bare lambda in `.Subscribe()`:** When subscribing to `IObservable<T>` inside a View's `WhenActivated` block, use `Observer.Create<T>(lambda)` instead of passing a bare lambda. The `Subscribe(Action<T>)` extension method may not resolve correctly in View code-behind files.

```csharp
this.WhenAnyValue(x => x.ViewModel!.MyProperty)
    .Subscribe(Observer.Create<bool>(value => MyControl.Classes.Set("my-class", value)))
    .DisposeWith(disposables);
```
