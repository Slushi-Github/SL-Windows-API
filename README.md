# SL WINDOWS API

This library, actually called "Slushi Windows API", is a library for Haxe, with a lot of Windows API functions, to use it in your Haxe projects.

the functions you can use can be found in `winapi/WIndowsAPI.hx`.

This is a simplified version of the Windows API that I have in my [Friday Night Funkin'](https://github.com/FunkinCrew/Funkin) Engine, [Slushi Engine](https://github.com/Slushi-Github/Slushi-Engine).

Define `WINDOWS_API_LOGS` for enable logs of this library.

## How to use this:

For functions where something related to the window is modified, it is necessary to use this function to define the window title (it is recommended to leave this in an update function).

```haxe
// import the library.
import winapi.WindowsAPI;

// Set the title of the main window, this example is with Lime.
WindowsAPI.reDefineMainWindowTitle(lime.app.Application.current.window.title);
```

### Examples:
Set a custom color for the main window border

```haxe
// import the library.
import winapi.WindowsAPI;

// Set the color of the main window border, in RGB format.
WindowsAPI.setWindowBorderColor(255, 0, 0);
```

### GDI Effects:
Windows GDI effects are effects that, in this case, run in full screen mode.
This comes from the latest and final version of [Slushi Engine](https://github.com/Slushi-Github/Slushi-Engine) (for the [second-year anniversary song “C18H27NO3”](https://www.youtube.com/watch?v=t_KBhgGeu7g)), now ported outside the engine to this library.

As far as I know, only one effect can be used at a time.

List of usable effects:
- `DrawIcons`: This effect is based on the MENZ malware source code, it is a very fast effect that can be used to draw icons on the screen and wherever you drag the Windows cursor.
- `ScreenGlitches`: This effect is based on the MENZ malware source code, it is a very fast effect that can be used to make glitches in the screen.
- `ScreenBlink`: This effect is based on the MENZ malware source code, it is a very fast effect that can be used to invert the colors of the screen.
- `ScreenShake`: This effect is based on the ??? (I don't remember the name) malware source code, it is a very fast effect that can be used to make screen shakes.
- `ScreenTunnel`: This effect is based on the MENZ malware source code, it is a very fast effect that can be used to make tunnel effect in the screen.
- `SetTitleTextToWindowsTitle`: (INCOMPLETE) This effect is based on the MENZ malware source code, that can be used to change the text of the window title of ALL visible windows.

```haxe
// import the library
import winapi.gdi.WindowsGDI;
import winapi.gdi.WindowsGDIThread;

// Start the thread
WindowsGDIThread.startWindowsGDIThread();

// Prepare/Set the effect
WindowsGDI.prepareGDIEffect('ScreenGlitches', 0);

// Enable the effect
WindowsGDI.enableGDIEffect('ScreenGlitches', true);

// When you want to disable the effect
WindowsGDI.enableGDIEffect('ScreenGlitches', false);

// Stop the thread for stopping the effects
WindowsGDIThread.stopWindowsGDIThread();
```

# License 


This project is released under the [MIT license](./LICENSE.md).
