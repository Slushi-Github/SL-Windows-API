# SL WINDOWS API

This library, actually called “Slushi Windows API”, is a library for Haxe, with a lot of Windows API functions, to use it in your Haxe projects.

the functions you can use can be found in ``winapi/WIndowsAPI.hx``

This is a simplified version of the Windows API that I have in my [Friday Night Funkin'](https://github.com/FunkinCrew/Funkin) Engine, [Slushi Engine](https://github.com/Slushi-Github/Slushi-Engine).

## How to use this:

For functions where something related to the window is modified, it is necessary to use this function to define the window title (it is recommended to leave this in an update function).

```haxe
// import the library
import winapi.WindowsAPI;

// Set the title of the main window
WindowsAPI.reDefineMainWindowTitle(lime.app.Application.current.window.title);
```

### Examples:
Set a custom color for the main window border

```haxe
import winapi.WindowsAPI;

WindowsAPI.setWindowBorderColor(255, 0, 0);
```