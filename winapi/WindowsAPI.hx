package winapi;

import sys.io.File;
import sys.FileSystem;
import sys.io.Process;

import haxe.io.Path;


using StringTools;

/**
 * Icon of the message box.
 */
enum abstract MessageBoxIcon(Null<Int>) from Int to Int {
	var ERROR = 0x00000010;
	var QUESTION = 0x00000020;
	var WARNING = 0x00000030;
	var INFORMATION = 0x00000040;
}

/**
 * Round of the window.
 */
enum abstract WindowRound(Null<Int>) from Int to Int {
	var DWMWCP_DEFAULT = 0;
	var DWMWCP_DONOTROUND = 1;
	var DWMWCP_ROUND = 2;
	var DWMWCP_ROUNDSMALL = 3;
}

/**
 * Version of the Windows OS.
 */
enum WindowsVersion {
	Windows_11;
	Windows_10;
	Windows_8_1;
	Windows_8;
	Windows_7;
	Unknown;
}

/**
 * Specific mode of the window to set in the layered mode.
 */
enum abstract WindowLayeredMode(Null<Int>) from Int to Int {
	var DESKTOP_WINDOW = 0;
	var TASKBAR_WINDOW = 1;
}

/**
 * Main class of the Windows API.
 */
class WindowsAPI {

	/**
	 * Obtain the RAM of the system.
	 * @return Int
	 */
	public static function obtainRAM():Int {
		#if HX_WINDOWS
		return WindowsCPP.obtainRAM();
		#else
		return 0;
		#end
	}

	/**
	 * Show a message box.
	 * @param message The message to show.
	 * @param caption The title of the message box.
	 * @param icon The icon of the message box.
	 */
	public static function showMessageBox(message:String, caption:String, icon:MessageBoxIcon = 0x00000030):Void {
		#if HX_WINDOWS 
		if (icon == null)
			return;

		final realNumber:Int = cast icon;

		WindowsCPP.showMessageBox(caption, message, realNumber);
		#end
	}

	/**
	 * Makes a specific color in the window fully transparent using color keying.
	 * 
	 * Any pixel matching the given RGB color will be rendered as transparent
	 * at the OS level, similar to a chroma key effect.
	 * 
	 * The default color is RGB(25, 25, 25), a near-black that is unlikely
	 * to appear in normal UI content.
	 * 
	 * @param r The red component of the key color (0-255). Default: 25.
	 * @param g The green component of the key color (0-255). Default: 25.
	 * @param b The blue component of the key color (0-255). Default: 25.
	 */
	public static function setWindowTransparent(r:Null<Int> = 25, g:Null<Int> = 25, b:Null<Int> = 25):Void {
		#if HX_WINDOWS

		if ((r == null || g == null || b == null) || (r < 0 || g < 0 || b < 0))
			return;

		final realR:Int = cast r;
		final realG:Int = cast g;
		final realB:Int = cast b;

		WindowsCPP.setWindowTransparent(realR, realG, realB);
		#end
	}

	/**
	 * Disables the window transparency.
	 */
	public static function disableWindowTransparent():Void {
		#if HX_WINDOWS
		WindowsCPP.disableWindowTransparent();
		#end
	}

	/**
	 * Show or hide the window.
	 * @param mode True to show the window, false to hide it.
	 */
	public static function setWindowVisible(mode:Bool):Void {
		#if HX_WINDOWS
		WindowsCPP.setWindowVisible(mode);
		#end
	}

	/**
	 * Set the window opacity.
	 * @param a The opacity of the window.
	 */
	public static function setWindowOppacity(a:Null<Float>):Void {
		#if HX_WINDOWS
		if (a == null || a < 0 || a > 1)
			return;

		WindowsCPP.setWindowAlpha(a);
		#end
	}

	/**
	 * Obtain the window opacity.
	 * @return Float
	 */
	public static function getWindowOppacity():Float {
		#if HX_WINDOWS
		return WindowsCPP.getWindowAlpha();
		#else
		return 0;
		#end
	}

	/**
	 * Set the window layered mode.
	 */
	public static function setWindowLayered():Void {
		#if HX_WINDOWS
		WindowsCPP._setWindowLayered();
		#end
	}

	/**
	 * Center the window on the screen.
	 */
	public static function centerWindow():Void {
		#if HX_WINDOWS
		WindowsCPP.centerWindow();
		#end
	}

	/**
	 * Set the window border color. (Only in Windows 11)
	 * @param r The red component of the color (0-255).
	 * @param g The green component of the color (0-255).
	 * @param b The blue component of the color (0-255).
	 */
	public static function setWindowBorderColor(r:Null<Int>, g:Null<Int>, b:Null<Int>):Void {
		#if HX_WINDOWS
		if ((r == null || g == null || b == null) || (r < 0 || g < 0 || b < 0))
			return;

		WindowsCPP.setWindowBorderColor(r, g, b);
		#end
	}

	/**
	 * Set the window border thickness. (Only in Windows 11)
	 * @param th The thickness of the border.
	 */
	public static function setWindowthickness(th:Null<Int>):Void {
		#if HX_WINDOWS
		if (th == null || th < 0)
			return;

		WindowsCPP.setWindowthickness(th);
		#end
	}

	/**
	 * Set the window text color. (Only in Windows 11)
	 * @param r The red component of the color (0-255).
	 * @param g The green component of the color (0-255).
	 * @param b The blue component of the color (0-255).
	 */
	public static function setWindowTextColor(r:Null<Int>, g:Null<Int>, b:Null<Int>):Void {
		#if HX_WINDOWS
		if ((r == null || g == null || b == null) || (r < 0 || g < 0 || b < 0))
			return;
		
		WindowsCPP.setWindowTextColor(r, g, b);
		#end
	}

	/**
	 * Set the window round mode. (Only in Windows 11)
	 * @param pmode The round mode of the window.
	 */
	public static function setWindowRound(pmode:Null<WindowRound>):Void
	{
		#if HX_WINDOWS
		if (pmode == null)
			return;

		final realNumber:Int = cast pmode;

		WindowsCPP.setWindowRound(realNumber);
		#end
	}

	/**
	 * Set the window dark mode.
	 * @param dmode The dark mode of the window.
	 */
	public static function windowDarkMode(dmode:Null<Bool>):Void
	{
		#if HX_WINDOWS
		if (dmode == null)
			return;

		WindowsCPP.windowDarkMode(dmode);
		#end
	}

	/**
	 * Hide or show the Windows task bar.
	 * @param hide True to hide the task bar, false to show it.
	 */
	public static function hideTaskbar(hide:Null<Bool>):Void {
		#if HX_WINDOWS
		if (hide == null)
			return;

		WindowsCPP.hideTaskbar(hide);
		#end
	}

	/**
	 * Set the wallpaper.
	 * @param path The absolute path to the wallpaper image.
	 */
	public static function setWallpaper(path:String):Void {
		#if HX_WINDOWS
		WindowsCPP.setWallpaper(path);
		#end
	}

	/**
	 * Hide or show the Windows desktop icons.
	 * @param hide True to hide the desktop icons, false to show them.
	 */
	public static function hideDesktopIcons(hide:Null<Bool>):Void {
		#if HX_WINDOWS
		WindowsCPP.hideDesktopIcons(hide);
		#end
	}

	/**
	 * Move the Windows desktop in the X axis.
	 * @param x The new X position of the desktop windows.
	 */
	public static function moveDesktopWindowsInX(x:Null<Int>):Void {
		#if HX_WINDOWS
		if (x == null)
			return;

		WindowsCPP.moveDesktopWindowsInX(x);
		#end
	}

	/**
	 * Move the Windows desktop in the Y axis.
	 * @param y The new Y position of the desktop windows.
	 */
	public static function moveDesktopWindowsInY(y:Null<Int>):Void {
		#if HX_WINDOWS
		if (y == null)
			return;

		WindowsCPP.moveDesktopWindowsInY(y);
		#end
	}

	/**
	 * Move the Windows desktop in the X and Y axis.
	 * @param x The new X position of the desktop windows.
	 * @param y The new Y position of the desktop windows.
	 */
	public static function moveDesktopWindowsInXY(x:Null<Int>, y:Null<Int>):Void {
		#if HX_WINDOWS
		if (x == null || y == null)
			return;

		WindowsCPP.moveDesktopWindowsInXY(x, y);
		#end
	}

	/**
	 * Get the X position of the Windows desktop.
	 */
	public static function getDesktopWindowsXPos():Int {
		#if HX_WINDOWS
		return WindowsCPP.returnDesktopWindowsX();
		#else
		return 0;
		#end
	}

	/**
	 * Get the Y position of the Windows desktop.
	 */
	public static function getDesktopWindowsYPos():Int {
		#if HX_WINDOWS
		return WindowsCPP.returnDesktopWindowsY();
		#else
		return 0;
		#end
	}

	/**
	 * Set the alpha of the Windows desktop, use ``WindowsAPI.setWindowLayeredMode(WindowLayeredMode.DESKTOP_WINDOW)`` first.
	 * @param alpha The new alpha of the desktop windows.
	 */
	public static function setDesktopWindowsAlpha(alpha:Null<Float>):Void {
		#if HX_WINDOWS
		if (alpha == null || alpha < 0 || alpha > 1)
			return;

		WindowsCPP._setDesktopWindowsAlpha(alpha);
		#end
	}

	/**
	 * Set the alpha of the Windows task bar, use ``WindowsAPI.setWindowLayeredMode(WindowLayeredMode.TASKBAR_WINDOW)`` first.
	 * @param alpha The new alpha of the task bar.
	 */
	public static function setTaskBarAlpha(alpha:Null<Float>):Void {
		#if HX_WINDOWS
		if (alpha == null || alpha < 0 || alpha > 1)
			return;

		WindowsCPP._setTaskBarAlpha(alpha);
		#end
	}

	/**
	 * Set the layered mode of the window.
	 * @param window The window to set the layered mode.
	 */
	public static function setWindowLayeredMode(window:Null<WindowLayeredMode>):Void {
		#if HX_WINDOWS
		if (window == null)
			return;

		final numberMode:Int = switch (window) {
			case WindowLayeredMode.DESKTOP_WINDOW:
				0;
			case WindowLayeredMode.TASKBAR_WINDOW:
				1;
		}

		WindowsCPP._setWindowLayeredMode(numberMode);
		#end
	}

	/**
	 * Get the X position of the cursor.
	 * @return Int The X position of the cursor.
	 */
	public static function getCursorPositionX():Int {
		#if HX_WINDOWS
		return WindowsCPP.getCursorPositionX();
		#else
		return 0;
		#end
	}

	/**
	 * Get the Y position of the cursor.
	 * @return Int The Y position of the cursor.
	 */
	public static function getCursorPositionY():Int {
		#if HX_WINDOWS
		return WindowsCPP.getCursorPositionY();
		#else
		return 0;
		#end
	}

	/**
	 * Set the title of the main window.
	 * @param windowTitle The new title of the main window.
	 */
	public static function reDefineMainWindowTitle(windowTitle:String):Void {
		#if HX_WINDOWS
		WindowsCPP.reDefineMainWindowTitle(windowTitle);
		#end
	}

	/**
	 * Take a screenshot of the entire screen.
	 * @param path The absolute path to save the screenshot.
	 */
	public static function windowsScreenShot(path:String):Void {
		#if HX_WINDOWS
		WindowsCPP.windowsScreenShot(path);
		#end
	}

	/**
	 * Check if the program is running as administrator.
	 * @return True if the program is running as administrator.
	 */
	public static function isRunningAsAdministrator():Bool {
		#if HX_WINDOWS
		return WindowsCPP.isRunningAsAdmin();
		#else
		return false;
		#end
	}

	/**
	 * Check if the program is running in Wine
	 * 
	 * Please don't use this function for malicious purposes.
	 * Preventing the program from running just because it isn't on Windows is bad practice.
	 * 
	 * @return True if the program is running in Wine.
	 */
	public static function isRunningInWine():Bool {
		#if HX_WINDOWS
		return WindowsCPP.isRunningInWine();
		#else
		return false;
		#end
	}

	/**
	 * Get the current window border color. (Only in Windows 11)
	 * @return {r:Int, g:Int, b:Int} The current border color.
	 */
	public static function getWindowBorderColor():{r:Int, g:Int, b:Int} {
		#if HX_WINDOWS
		return unpackColor(WindowsCPP.getWindowBorderColor());
		#else
		return {r: 0, g: 0, b: 0};
		#end
	}

	/**
	 * Get the current window text color. (Only in Windows 11)
	 * @return {r:Int, g:Int, b:Int} The current text color.
	 */
	public static function getWindowTextColor():{r:Int, g:Int, b:Int} {
		#if HX_WINDOWS
		return unpackColor(WindowsCPP.getWindowTextColor());
		#else
		return {r: 0, g: 0, b: 0};
		#end
	}

	/**
	 * Get the current window border thickness. (Only in Windows 11)
	 * @return Int The current border thickness.
	 */
	public static function getWindowThickness():Int {
		#if HX_WINDOWS
		return WindowsCPP.getWindowThickness();
		#else
		return 0;
		#end
	}

	/**
	 * Get the current window corner mode. (Only in Windows 11)
	 * @return WindowRound The current corner mode.
	 */
	public static function getWindowRound():WindowRound {
		#if HX_WINDOWS
		return cast WindowsCPP.getWindowCornerMode();
		#else
		return DWMWCP_DEFAULT;
		#end
	}

	// Windows Terminal Functions ////////////////////

	/**
	 * Clear the WIndows terminal.
	 */
	public static function clearTerminal():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.clearTerminal();
		#end
	}

	/**
	 * Allocate the Windows terminal (shows the terminal).
	 */
	public static function allocConsole():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.allocConsole();
		#end
	}

	/**
	 * Hide the main window of your program.
	 */
	public static function hideMainWindow():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.hideMainWindow();
		#end
	}

	/**
	 * Set the title of the Windows terminal window.
	 * @param title The new title of the Windows terminal window.
	 */
	public static function setConsoleTitle(title:String):Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.setConsoleTitle(title);
		#end
	}

	/**
	 * Set the icon of the Windows terminal window.
	 * @param path The absolute path to the icon.
	 */
	public static function setConsoleWindowIcon(path:String):Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.setConsoleWindowIcon(path);
		#end
	}

	/**
	 * Center the Windows terminal window on the screen.
	 */
	public static function centerConsoleWindow():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.centerConsoleWindow();
		#end
	}

	/**
	 * Disable the ability to resize the Windows terminal window.
	 */
	public static function disableResizeConsoleWindow():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.disableResizeConsoleWindow();
		#end
	}

	/**
	 * Disable the ability to close the Windows terminal window.
	 */
	public static function disableCloseConsoleWindow():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.disableCloseConsoleWindow();
		#end
	}

	/**
	 * Maximize the Windows terminal window.
	 */
	public static function maximizeConsoleWindow():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.maximizeConsoleWindow();
		#end
	}

	/**
	 * Get the width of the Windows terminal window.
	 * @return Int
	 */
	public static function getConsoleWindowWidth():Int {
		#if HX_WINDOWS
		return WindowsTerminalCPP.returnConsoleWindowWidth();
		#else
		return 0;
		#end
	}

	/**
	 * Get the height of the Windows terminal window.
	 * @return Int
	 */
	public static function getConsoleWindowHeight():Int {
		#if HX_WINDOWS
		return WindowsTerminalCPP.returnConsoleWindowHeight();
		#else
		return 0;
		#end
	}

	/**
	 * Set the position of the Windows terminal cursor.
	 * @param x The X position of the Windows terminal cursor.
	 * @param y The Y position of the Windows terminal cursor.
	 */
	public static function setConsoleCursorPosition(x:Null<Int>, y:Null<Int>):Void {
		#if HX_WINDOWS
		if (x == null || y == null)
			return;

		WindowsTerminalCPP.setConsoleCursorPosition(x, y);
		#end
	}

	/**
	 * Get the X position of the Windows terminal cursor.
	 * @return Int
	 */
	public static function getConsoleCursorPositionInX():Int {
		#if HX_WINDOWS
		return WindowsTerminalCPP.getConsoleCursorPositionInX();
		#else
		return 0;
		#end
	}

	/**
	 * Get the Y position of the Windows terminal cursor.
	 * @return Int
	 */
	public static function getConsoleCursorPositionInY():Int {
		#if HX_WINDOWS
		return WindowsTerminalCPP.getConsoleCursorPositionInY();
		#else
		return 0;
		#end
	}

	/**
	 * Set the position of the Windows terminal window.
	 * @param posX The X position of the Windows terminal window.
	 */
	public static function setConsoleWindowPositionX(posX:Null<Int>):Void {
		#if HX_WINDOWS
		if (posX == null)
			return;

		WindowsTerminalCPP.setConsoleWindowPositionX(posX);
		#end
	}

	/**
	 * Set the position of the Windows terminal window.
	 * @param posY The Y position of the Windows terminal window.
	 */
	public static function setConsoleWindowPositionY(posY:Null<Int>):Void {
		#if HX_WINDOWS
		if (posY == null)
			return;

		WindowsTerminalCPP.setConsoleWindowPositionY(posY);
		#end
	}

	/**
	 * Hide the Windows terminal window.
	 */
	public static function hideConsoleWindow():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.hideConsoleWindow();
		#end
	}

	/////////////////////////////////
	@:noPrivateAccess private static var _windowsWallpaperPath:String = null;
	@:noPrivateAccess private static var changedWallpaper:Null<Bool> = false;

	/**
	 * Change the Windows wallpaper.
	 * Automatically saves the original wallpaper the first time it's called.
	 * @param path Path to the wallpaper relative to the program directory.
	 */
	public static function changeWindowsWallpaper(path:String):Void {
		#if HX_WINDOWS
		if (_windowsWallpaperPath == null)
			saveCurrentWindowsWallpaper();

		final allPath:String = Path.directory(Sys.programPath()).replace("\\", "/") + path;
		setWallpaper(allPath);
		_changedWallpaper = true;
		#end
	}


	/**
	 * Take a screenshot of the whole screen.
	 * @param path Normal path to the screenshot (Starts of your program path).
	 */
	public static function screenCapture(path:String):Void {
		#if HX_WINDOWS
		if (path == null || path == "")
			return;

		final allPath:String = Path.directory(Sys.programPath()).replace("\\", "/") + path;
		windowsScreenShot(allPath);
		#end
	}

	/**
	 * Save the current Windows wallpaper to a hidden cache folder.
	 * This is called automatically by ``changeWindowsWallpaper`` the first time,
	 * but can also be called manually before any changes are made.
	 * Calling it more than once has no effect, the original is always preserved.
	 */
	public static function saveCurrentWindowsWallpaper():Void {
		#if HX_WINDOWS
		if (_windowsWallpaperPath != null)
			return;

		final cacheDir = Path.directory(Sys.programPath()) + "\\.cache";
		createHiddenFolder(cacheDir);

		final wallpaperSrc = '${Sys.getEnv("AppData")}\\Microsoft\\Windows\\Themes\\TranscodedWallpaper';
		final wallpaperDst = cacheDir + "\\wallpaper.jpg";

		File.copy(wallpaperSrc, wallpaperDst);
		_windowsWallpaperPath = wallpaperDst;
		#end
	}

	/**
	 * Restore the original Windows wallpaper saved before any changes were made.
	 * Does nothing if the wallpaper was never changed.
	 */
	public static function restoreWindowsWallpaper():Void {
		#if HX_WINDOWS
		if (!_changedWallpaper || _windowsWallpaperPath == null)
			return;

		setWallpaper(_windowsWallpaperPath);
		_changedWallpaper = false;
		#end
	}

	public static function sendWindowsNotification(title:String, desc:String):Void {
		#if HX_WINDOWS
		final powershellCommand = "powershell -Command \"& {$ErrorActionPreference = 'Stop';"
			+ "$title = '"
			+ desc
			+ "';"
			+ "[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null;"
			+ "$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText01);"
			+ "$toastXml = [xml] $template.GetXml();"
			+ "$toastXml.GetElementsByTagName('text').AppendChild($toastXml.CreateTextNode($title)) > $null;"
			+ "$xml = New-Object Windows.Data.Xml.Dom.XmlDocument;"
			+ "$xml.LoadXml($toastXml.OuterXml);"
			+ "$toast = [Windows.UI.Notifications.ToastNotification]::new($xml);"
			+ "$toast.Tag = 'Test1';"
			+ "$toast.Group = 'Test2';"
			+ "$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('"
			+ title
			+ "');"
			+ "$notifier.Show($toast);}\"";

		if (title != null && title != "" && desc != null && desc != "")
			new Process(powershellCommand);
		#end
	}

	/**
	 * Get the version of the Windows OS (Requires Lime).
	 * @return WindowsVersion The version of the Windows OS.
	 */
	public static function getWindowsVersion():WindowsVersion {
		#if (HX_WINDOWS || lime)
		var windowsVersions:Map<String, WindowsVersion> = [
			"Windows 11" => Windows_11,
			"Windows 10" => Windows_10,
			"Windows 8.1" => Windows_8_1,
			"Windows 8" => Windows_8,
			"Windows 7" => Windows_7,
		];

		final platformLabel = System.platformLabel;
		final words = platformLabel.split(" ");
		final windowsIndex = words.indexOf("Windows");
		var result = "";

		if (windowsIndex != -1 && windowsIndex < words.length - 1)
			result = words[windowsIndex] + " " + words[windowsIndex + 1];

		if (windowsVersions.exists(result))
			return windowsVersions.get(result);

		return Unknown;
		#else
		return Unknown;
		#end
	}


	/**
	 * Reset the Windows functions to their default values.
	 */
	public static function resetWindowsFuncs():Void {
		#if HX_WINDOWS
		hideTaskbar(false);
		hideDesktopIcons(false);
		moveDesktopWindowsInXY(0, 0);
		setTaskBarAlpha(1);
		setDesktopWindowsAlpha(1);

		if (changedWallpaper) {
			setOldWindowsWallpaper();
			changedWallpaper = false;
		}
		#end
	}

	//////////////////////////////////////

	private static function unpackColor(color:Null<Int>):{r:Int, g:Int, b:Int} {
		if (color == null)
			return {
				r: 0,
				g: 0,
				b: 0
			};

		return {
			r: color & 0xFF,
			g: (color >> 8) & 0xFF,
			b: (color >> 16) & 0xFF
		};
	}

	/**
	 * Creates a hidden folder at the given absolute path.
	 * If the folder already exists, it will just be marked as hidden.
	 * @param path The absolute path to the folder.
	 */
	private static function createHiddenFolder(path:String):Void {
		#if HX_WINDOWS
		try {
			if (!FileSystem.exists(path))
				FileSystem.createDirectory(path);

			WindowsCPP.setHiddenFolder(path);
		} catch (e) {}
		#end
	}
}