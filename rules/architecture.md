```yaml

```

# Project Architecture

## Folders architecture

### Src

In this folder, you can find folders in which you will work most often.

- **Features:** Here we keep folders related to specific features. Each feature must have a separate folder. Inside this folder, there should be the following folders:
  
  - UI - here should be folders for the screens, FeatureStyles and FeatureComponents.
  - Domain - and in that folder you can add folders for services, models ,usecases, enums and ect if needed
  - Resources here you put file with strings
    you can also add additional folders (like for example "services" for services related to feature) if needed.
    Additionally, all features (except the feature named Shell) must have a file named NameModule.cs (e.g., for a feature named Malpa, it should be the file MalpaModule.cs). This file should contain the registration of routes for the given feature. The modules themselves are later registered in the AppBootstrapper.cs file.

- **Infrastructure:** Here we have two files: AppBootstrapper and IFeatureModule. AppBootstrapper is used for registering modules. It also contains the routing state. IFeatureModule is the base interface for all modules.

- **Shared:** It is best to put here UI elements that are shared across multiple features.You can find there folders like
  
  - Resources with GlobalStrings.resx file inside it.
  - GlobalStyles with styles files used across several features in app
  - GlobalComponents for custom components (for example custom buttons)

- **Core:** Here you can put some services, enums, models shared by several features, and it also contains the ViewModelBase. each category (i mean services, models, enums ect) should have own separated subfolder

### Assets

Here you can store things like icons images and ect

### Tests

here you should place all tests. inside there is folder [ProjectNamespace].Tests and inside of this folder there are:

- **CoreTests:** here you put tests related to things from Src/Core
- **FeaturesTests:** and here in subfolders you put tests realted to each feature (for example tests of services from Malpa feature you should place in folder FeaturesTests/MalpaTests/ServicesTests)

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

## ViewModels

1. All view models extends ViewModelBase

2. HostViewModel which is "owner of routing" implements IScreen interface.

3. every other view model other than HostViewModel
   
   - should implement IRoutableViewModel
   
   - should have constructor which takes IScreen arg and then assing its value to its property with name HostScreen
   
   - has property UrlPathSegment which has type String and should contains name of Screen in kebab case (for example for screen WielkaMalpa it would be "wielka-malpa")

Example view model

```csharp
public class EmployeeListViewModel : ViewModelBase, IRoutableViewModel
{
    // Mandatory: Unique identifier for this view in the navigation stack
    public string? UrlPathSegment => "employee-list";

    // Mandatory: The navigation host
    public IScreen HostScreen { get; }

    // Command to navigate to the editor
    public ReactiveCommand<Unit, IRoutableViewModel> GoToEditor { get; }

    public EmployeeListViewModel(IScreen hostScreen)
    {
        HostScreen = hostScreen;

        // Navigation logic: Creating a new instance of the target ViewModel 
        // and passing the HostScreen (IScreen) to it.
        GoToEditor = ReactiveCommand.CreateFromObservable(() => 
            HostScreen.Router.Navigate.Execute(new EmployeeEditorViewModel(HostScreen))
        );
    }
}
```

## Strings

strings used in UI of app shouldn't be hardcoded in axaml or cs files. instead they should be stored in .resx files. Strings used in one fetature should be placed in file FeatureNameStrings.resx in FeatureName/Resources folder and strings used across several features should be placed in GlobalStrings.resx in Shared/Resources\

Strings used in the application shouldn't be hardcoded in .axaml or .cs files. Instead, they must be stored in .resx files.

- Strings specific to a single feature should be placed in a .resx file located at: `FeatureName/Resources/FeatureNameStrings.resx`.

- Strings shared across multiple features (e.g., generic buttons like Save, Cancel, Error) should be placed in: `Src/Shared/Resources/GlobalStrings.resx`.

- In .axaml files, use the `{x:Static}` markup extension to bind strings from the generated .resx classes (e.g., `Text="{x:Static res:GlobalStrings.SaveButton}"`). Do not use `{StaticResource}` or `{DynamicResource}` for localized texts.

- Internal strings that are never visible to the user (e.g., dictionary keys, cache keys, event names, configuration names and ect) shouldn't be placed in .resx files. Localizing logic-bound strings breaks the application.

- Instead, these internal strings should be defined as `const string` or `public const string`. Do not leave inline "magic strings" in the code."

- Before adding a new localized string to a feature-specific .resx file, you should check if an equivalent string already exists in `Src/Shared/Resources/GlobalStrings.resx`. If it does, reuse the global string.

- You shouldn't add new strings to `GlobalStrings.resx` unless I explicitly command you to do so. If I do not explicitly state to put it in global strings, always default to adding new strings to the active feature's local .resx file.

- To use a localized string in an .axaml file, you first declare the namespace of the .resx file at the root element using the `using:` syntax (do not use the legacy WPF `clr-namespace:` syntax).
  
  Example of correct usage:

```xml
<Window xmlns:res="using:[ProjectNamespace].Shared.Resources" ...>

<TextBlock Text="{x:Static res:GlobalStrings.SaveButtonText}" />
  </Window>
```

### resx file

resx file example

```xml
<?xml version="1.0" encoding="utf-8"?>
<root>
  <xsd:schema id="root" xmlns="" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
    </xsd:schema>
  <resheader name="resmimetype">
    <value>text/microsoft-resx</value>
  </resheader>
  <resheader name="version">
    <value>2.0</value>
  </resheader>
  <resheader name="reader">
    <value>System.Resources.ResXResourceReader, System.Windows.Forms, ...</value>
  </resheader>
  <resheader name="writer">
    <value>System.Resources.ResXResourceWriter, System.Windows.Forms, ...</value>
  </resheader>

  <data name="AppTitle" xml:space="preserve">
    <value>[Project Name] - [App Title]</value>
    <comment>Główny tytuł okna aplikacji widoczny na pasku</comment>
  </data>

  <data name="SaveButton" xml:space="preserve">
    <value>Save</value>
  </data>

  <data name="CancelButton" xml:space="preserve">
    <value>Cancle</value>
  </data>
</root>
```

## Enums

files with enums should be stored in "Enums" folder in Core or FeatureName/Domain. 
i mean for example if we have feature Animals and we want to have enum Tygrys we should place it in Features/Animals/Domain/Enums/Tygrys.cs

# 
