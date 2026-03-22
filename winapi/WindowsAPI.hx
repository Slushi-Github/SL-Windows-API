package winapi;

import sys.io.Process;

enum abstract MessageBoxIcon(Null<Int>) {
	var ERROR = 0x00000010;
	var QUESTION = 0x00000020;
	var WARNING = 0x00000030;
	var INFORMATION = 0x00000040;
}

enum abstract WindowRound(Null<Int>) {
	var DWMWCP_DEFAULT = 0;
	var DWMWCP_DONOTROUND = 1;
	var DWMWCP_ROUND = 2;
	var DWMWCP_ROUNDSMALL = 3;
}

enum abstract WindowLayeredMode(Null<Int>) {
	var DESKTOP_WINDOW = 0;
	var TASKBAR_WINDOW = 1;
}

class WindowsAPI {
	public static function obtainRAM():Int {
		#if HX_WINDOWS
		return WindowsCPP.obtainRAM();
		#else
		return 0;
		#end
	}

	public static function showMessageBox(message:String, caption:String, icon:MessageBoxIcon = WARNING):Void {
		#if HX_WINDOWS
		WindowsCPP.showMessageBox(caption, message, icon);
		#end
	}

	public static function setWindowsTransparent():Void {
		#if HX_WINDOWS
		WindowsCPP.setWindowsTransparent();
		#end
	}

	public static function disableWindowTransparent():Void {
		#if HX_WINDOWS
		WindowsCPP.disableWindowTransparent();
		#end
	}

	public static function setWindowVisible(mode:Bool):Void {
		#if HX_WINDOWS
		WindowsCPP.setWindowVisible(mode);
		#end
	}

	public static function setWindowOppacity(a:Null<Float>):Void {
		#if HX_WINDOWS
		if (a == null || a < 0 || a > 1)
			return;

		WindowsCPP.setWindowAlpha(a);
		#end
	}

	public static function getWindowOppacity():Float {
		#if HX_WINDOWS
		return WindowsCPP.getWindowAlpha();
		#else
		return 0;
		#end
	}

	public static function setWindowLayered():Void {
		#if HX_WINDOWS
		WindowsCPP._setWindowLayered();
		#end
	}

	public static function centerWindow():Void {
		#if HX_WINDOWS
		WindowsCPP.centerWindow();
		#end
	}

	public static function setWindowBorderColor(r:Null<Int>, g:Null<Int>, b:Null<Int>):Void {
		#if HX_WINDOWS
		if ((r == null || g == null || b == null) || (r < 0 || g < 0 || b < 0))
			return;

		WindowsCPP.setWindowBorderColor(r, g, b);
		#end
	}

	public static function setWindowthickness(th:Null<Int>):Void {
		#if HX_WINDOWS
		if (th == null || th < 0)
			return;

		WindowsCPP.setWindowthickness(th);
		#end
	}

	public static function setWindowTextColor(r:Null<Int>, g:Null<Int>, b:Null<Int>):Void {
		#if HX_WINDOWS
		if ((r == null || g == null || b == null) || (r < 0 || g < 0 || b < 0))
			return;
		
		WindowsCPP.setWindowTextColor(r, g, b);
		#end
	}

	public static function setWindowRound(pmode:Null<WindowRound>):Void
	{
		#if HX_WINDOWS
		if (pmode == null)
			return;

		WindowsCPP.setWindowRound(pmode);
		#end
	}

	public static function windowDarkMode(dmode:Null<Bool>):Void
	{
		#if HX_WINDOWS
		if (dmode == null)
			return;

		WindowsCPP.windowDarkMode(dmode);
		#end
	}

	public static function hideTaskbar(hide:Null<Bool>):Void {
		#if HX_WINDOWS
		if (hide == null)
			return;

		WindowsCPP.hideTaskbar(hide);
		#end
	}

	public static function setWallpaper(path:String):Void {
		#if HX_WINDOWS
		WindowsCPP.setWallpaper(path);
		#end
	}

	public static function hideDesktopIcons(hide:Null<Bool>):Void {
		WindowsCPP.hideDesktopIcons(hide);
	}

	public static function moveDesktopWindowsInX(x:Null<Int>):Void {
		#if HX_WINDOWS
		if (x == null)
			return;

		WindowsCPP.moveDesktopWindowsInX(x);
		#end
	}

	public static function moveDesktopWindowsInY(y:Null<Int>):Void {
		#if HX_WINDOWS
		if (y == null)
			return;

		WindowsCPP.moveDesktopWindowsInY(y);
		#end
	}

	public static function moveDesktopWindowsInXY(x:Null<Int>, y:Null<Int>):Void {
		#if HX_WINDOWS
		if (x == null || y == null)
			return;

		WindowsCPP.moveDesktopWindowsInXY(x, y);
		#end
	}

	public static function getDesktopWindowsXPos():Int {
		#if HX_WINDOWS
		return WindowsCPP.returnDesktopWindowsX();
		#else
		return 0;
		#end
	}

	public static function getDesktopWindowsYPos():Int {
		#if HX_WINDOWS
		return WindowsCPP.returnDesktopWindowsY();
		#else
		return 0;
		#end
	}

	public static function setDesktopWindowsAlpha(alpha:Null<Float>):Void {
		#if HX_WINDOWS
		if (alpha == null || alpha < 0 || alpha > 1)
			return;

		WindowsCPP._setDesktopWindowsAlpha(alpha);
		#end
	}

	public static function setTaskBarAlpha(alpha:Null<Float>):Void {
		#if HX_WINDOWS
		if (alpha == null || alpha < 0 || alpha > 1)
			return;

		WindowsCPP._setTaskBarAlpha(alpha);
		#end
	}

	public static function setWindowLayeredMode(window:Null<WindowLayeredMode>):Void {
		if (window == null)
			return;

		final numberMode:Int = switch (window) {
			case WindowLayeredMode.DESKTOP_WINDOW:
				0;
			case WindowLayeredMode.TASKBAR_WINDOW:
				1;
		}

		WindowsCPP._setWindowLayeredMode(numberMode);
	}

	public static function getCursorPositionX():Int {
		#if HX_WINDOWS
		return WindowsCPP.getCursorPositionX();
		#else
		return 0;
		#end
	}

	public static function getCursorPositionY():Int {
		#if HX_WINDOWS
		return WindowsCPP.getCursorPositionY();
		#else
		return 0;
		#end
	}

	public static function reDefineMainWindowTitle(windowTitle:String):Void {
		WindowsCPP.reDefineMainWindowTitle(windowTitle);
	}

	public static function windowsScreenShot(path:String):Void {
		#if HX_WINDOWS
		WindowsCPP.windowsScreenShot(path);
		#end
	}

	// Windows Terminal Functions ////////////////////

	public static function clearTerminal():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.clearTerminal();
		#end
	}

	public static function allocConsole():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.allocConsole();
		#end
	}

	public static function hideMainWindow():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.hideMainWindow();
		#end
	}

	public static function setConsoleTitle(title:String):Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.setConsoleTitle(title);
		#end
	}

	public static function setConsoleWindowIcon(path:String):Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.setConsoleWindowIcon(path);
		#end
	}

	public static function centerConsoleWindow():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.centerConsoleWindow();
		#end
	}

	public static function disableResizeConsoleWindow():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.disableResizeConsoleWindow();
		#end
	}

	public static function disableCloseConsoleWindow():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.disableCloseConsoleWindow();
		#end
	}

	public static function maximizeConsoleWindow():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.maximizeConsoleWindow();
		#end
	}

	public static function getConsoleWindowWidth():Int {
		#if HX_WINDOWS
		return WindowsTerminalCPP.returnConsoleWindowWidth();
		#else
		return 0;
		#end
	}

	public static function getConsoleWindowHeight():Int {
		#if HX_WINDOWS
		return WindowsTerminalCPP.returnConsoleWindowHeight();
		#else
		return 0;
		#end
	}

	public static function setConsoleCursorPosition(x:Null<Int>, y:Null<Int>):Void {
		#if HX_WINDOWS
		if (x == null || y == null)
			return;

		WindowsTerminalCPP.setConsoleCursorPosition(x, y);
		#end
	}

	public static function getConsoleCursorPositionInX():Int {
		#if HX_WINDOWS
		return WindowsTerminalCPP.getConsoleCursorPositionInX();
		#else
		return 0;
		#end
	}

	public static function getConsoleCursorPositionInY():Int {
		#if HX_WINDOWS
		return WindowsTerminalCPP.getConsoleCursorPositionInY();
		#else
		return 0;
		#end
	}

	public static function setConsoleWindowPositionX(posX:Null<Int>):Void {
		#if HX_WINDOWS
		if (posX == null)
			return;

		WindowsTerminalCPP.setConsoleWindowPositionX(posX);
		#end
	}

	public static function setConsoleWindowPositionY(posY:Null<Int>):Void {
		#if HX_WINDOWS
		if (posY == null)
			return;

		WindowsTerminalCPP.setConsoleWindowPositionY(posY);
		#end
	}

	public static function hideConsoleWindow():Void {
		#if HX_WINDOWS
		WindowsTerminalCPP.hideConsoleWindow();
		#end
	}

	/////////////////////////////////
	@:noPrivateAccess private static var _windowsWallpaperPath:String = null;
	@:noPrivateAccess private static var changedWallpaper:Null<Bool> = false;
	
	public static function changeWindowsWallpaper(path:String):Void {
		#if HX_WINDOWS
		var allPath:String = Sys.getCwd() + path;
		allPath = allPath.split("\\").join("/");
		setWallpaper(allPath);
		changedWallpaper = true;
		trace("Wallpaper changed to: " + allPath);
		#end
	}

	public static function screenCapture(path:String):Void {
		#if HX_WINDOWS
		var allPath:String = Sys.getCwd() + path;
		allPath = allPath.split("\\").join("/");
		windowsScreenShot(allPath);
		#end
	}

	public static function saveCurrentWindowsWallpaper():Void {
		#if HX_WINDOWS
		final path = '${Sys.getEnv("AppData")}\\Microsoft\\Windows\\Themes\\TranscodedWallpaper';

		if (path != null) {
			#if debug
			trace("Wallpaper Path: [" + path + "]. Saving the path in a private variable...");
			#end
			_windowsWallpaperPath = path;
		} else {
			trace("Error! Could not save the wallpaper path!");
		}
		#end
	}

	public static function setOldWindowsWallpaper():Void {
		#if HX_WINDOWS
		setWallpaper(_windowsWallpaperPath);
		trace("Wallpaper changed to: " + _windowsWallpaperPath);
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
}