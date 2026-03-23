package winapi.gdi;

@:cppFileCode('
#if defined(HX_WINDOWS)
#include <Windows.h>
#include <windowsx.h>
#include <cstdio>
#include <iostream>
#include <tchar.h>
#include <dwmapi.h>
#include <winuser.h>
#include <winternl.h>
#include <Shlobj.h>
#include <commctrl.h>
#include <string>

#include <locale>
#include <codecvt>

#include <math.h>
#include <cmath>

#define UNICODE

#pragma comment(lib, "Dwmapi")
#pragma comment(lib, "ntdll.lib")
#pragma comment(lib, "User32.lib")
#pragma comment(lib, "Shell32.lib")
#pragma comment(lib, "gdi32.lib")

/////////////////////////////////////////////////////////////////////////////

static float elapsedTime = 0;

int payloadDrawErrors() {
	int ix = GetSystemMetrics(SM_CXICON) / 2;
	int iy = GetSystemMetrics(SM_CYICON) / 2;
	
	HWND hwnd = GetDesktopWindow();
	HDC hdc = GetWindowDC(hwnd);

	POINT cursor;
	GetCursorPos(&cursor);

	DrawIcon(hdc, cursor.x - ix, cursor.y - iy, LoadIcon(NULL, IDI_ERROR));

	if (rand() % (int)(10/(elapsedTime/500.0+1)+1) == 0) {
		DrawIcon(hdc, rand()%GetSystemMetrics(SM_CXSCREEN), rand()%GetSystemMetrics(SM_CYSCREEN), LoadIcon(NULL, IDI_WARNING));
	}
	
	ReleaseDC(hwnd, hdc);

	out: return 2;
}

int payloadBlink() {
	HWND hwnd = GetDesktopWindow();
	HDC hdc = GetWindowDC(hwnd);
	RECT rekt;
	GetWindowRect(hwnd, &rekt);
	BitBlt(hdc, 0, 0, rekt.right - rekt.left, rekt.bottom - rekt.top, hdc, 0, 0, NOTSRCCOPY);
	ReleaseDC(hwnd, hdc);

	out: return 100;
}

int payloadGlitchs() {
	HWND hwnd = GetDesktopWindow();
	HDC hdc = GetWindowDC(hwnd);
	RECT rekt;
	GetWindowRect(hwnd, &rekt);

	int x1 = rand() % (rekt.right - 100);
	int y1 = rand() % (rekt.bottom - 100);
	int x2 = rand() % (rekt.right - 100);
	int y2 = rand() % (rekt.bottom - 100);
	int width = rand() % 600;
	int height = rand() % 600;

	BitBlt(hdc, x1, y1, width, height, hdc, x2, y2, SRCCOPY);
	ReleaseDC(hwnd, hdc);

	out: return 200.0 / (elapsedTime / 5.0 + 1) + 3;
}

int payloadTunnel() {
	HWND hwnd = GetDesktopWindow();
	HDC hdc = GetWindowDC(hwnd);
	RECT rekt;
	GetWindowRect(hwnd, &rekt);
	StretchBlt(hdc, 50, 50, rekt.right - 100, rekt.bottom - 100, hdc, 0, 0, rekt.right, rekt.bottom, SRCCOPY);
	ReleaseDC(hwnd, hdc);

	out: return 200.0 / (elapsedTime / 5.0 + 1) + 4;
}

int payloadScreenShake() {
	HDC hdc = GetDC(0);
	int x = SM_CXSCREEN;
	int y = SM_CYSCREEN;
	int w = GetSystemMetrics(0);
	int h = GetSystemMetrics(1);
	BitBlt(hdc, rand() % 2, rand() % 2, w, h, hdc, rand() % 2, rand() % 2, SRCCOPY);
	Sleep(10);
	ReleaseDC(0, hdc);
    return 0;
}

/////////////////////////////////////////////////////////////////////////////

BOOL CALLBACK EnumChildProc(HWND hwnd, LPARAM lParam) {

    LPWSTR newText = (LPWSTR)lParam;

    SendMessageTimeoutW(hwnd, WM_SETTEXT, NULL, (LPARAM)newText, SMTO_ABORTIFHUNG, 0, NULL);

    return TRUE;
}
#endif
')
/*
 * This is the main class of the Windows GDI effects in this library, it has the C++ code of the effects, 
 * and there are functions to prepare, start and remove an added effect
 * (some of the GDI effect code is taken from the MENZ malware source code)
 * 
 * Author: Slushi
 */
class WindowsGDI
{
	#if HX_WINDOWS
	@:functionCode('
        elapsedTime = elapsed;
    ')
	public static function setElapsedTime(elapsed:Float)
	{
	}

	@:functionCode('
        payloadDrawErrors();
    ')
	public static function _drawIcons()
	{
	}

	@:functionCode('
        payloadBlink();
    ')
	public static function _screenBlink()
	{
	}

	@:functionCode('
        payloadGlitchs();
    ')
	public static function _screenGlitches()
	{
	}

	@:functionCode('
        payloadTunnel();
    ')
	public static function _screenTunnel()
	{
	}

	@:functionCode('
        payloadScreenShake();
    ')
	public static function _screenShake()
	{
	}

	@:functionCode('
        std::string s = text;
        std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
        std::wstring wide = converter.from_bytes(s);

        LPCWSTR result = wide.c_str();

        EnumChildWindows(GetDesktopWindow(), EnumChildProc, (LPARAM)result);
    ')
	public static function _setCustomTitleTextToWindows(text:String = "...")
	{
	}
	#end

	/////////////////////////////////////////////////////////////////////////////

	/**
	 * Prepares a GDI effect to be used later
	 * @param effect The name of the effect to prepare
	 * @param wait The wait time between each effect update (in milliseconds)
	 */
	public static function prepareGDIEffect(effect:String, wait:Null<Float> = 0):Void
	{
		#if HX_WINDOWS
		if (wait == null || wait < 0) wait = 0;

		var effectClass = Type.resolveClass('winapi.gdi.WinEffect_' + effect);
		if (effectClass == null)
		{
			effectClass = Type.resolveClass('winapi.gdi.' + effect);
		}

		if (effectClass != null)
		{
			final initEffect = Type.createInstance(effectClass, []);
			WindowsGDIThread.gdiEffects.set(effect, new WindowsGDIEffectData(initEffect, wait, false));
			#if WINDOWS_API_LOGS
			trace('created [${effect}] GDI effect from class [WinEffect_${effect}]');
			#end
		}
		else
		{
			#if WINDOWS_API_LOGS
			trace('[WinEffect_${effect}] not found!');
			#end
		}
		#end
	}

	/**
	 * Sets the wait time between each effect update
	 * @param effect The name of the effect to set the wait time
	 * @param wait The wait time between each effect update (in milliseconds)
	 */
	public static function setGDIEffectWaitTime(effect:String, wait:Null<Float>):Void
	{
		#if HX_WINDOWS
		if (wait == null || wait < 0) wait = 0;
		final gdi = WindowsGDIThread.gdiEffects.get(effect);
		if (gdi != null)
		{
			gdi.wait = wait;
		}
		else
		{
			#if WINDOWS_API_LOGS
			trace('[WinEffect_${effect}] not found!');
			#end
		}
		#end
	}

	/**
	 * Removes a GDI effect
	 * @param effect The name of the effect to remove
	 */
	public static function removeGDIEffect(effect:String):Void
	{
		#if HX_WINDOWS
		var gdi = WindowsGDIThread.gdiEffects.get(effect);
		if (gdi != null)
		{
			WindowsGDIThread.gdiEffects.remove(effect);
		}
		else
		{
			#if WINDOWS_API_LOGS
			trace('[WinEffect_${effect}] not found!');
			#end
		}
		#end
	}

	/**
	 * Enables or disables a GDI effect
	 * @param effect The name of the effect to enable or disable
	 * @param enabled Whether to enable or disable the effect
	 */
	public static function enableGDIEffect(effect:String, enabled:Null<Bool> = true):Void
	{
		#if HX_WINDOWS
		final gdi = WindowsGDIThread.gdiEffects.get(effect);
		if (gdi != null)
		{
			gdi.enabled = enabled ?? true;
		}
		else
		{
			#if WINDOWS_API_LOGS
			trace('[WinEffect_${effect}] not found!');
			#end
		}
		#end
	}
}


class WindowsGDIEffect
{
	public function update()
	{
	}
}

#if HX_WINDOWS
class WinEffect_DrawIcons extends WindowsGDIEffect
{
	override public function update()
	{
		WindowsGDI._drawIcons();
	}
}

class WinEffect_ScreenBlink extends WindowsGDIEffect
{
	override public function update()
	{
		WindowsGDI._screenBlink();
	}
}

class WinEffect_ScreenGlitches extends WindowsGDIEffect
{
	override public function update()
	{
		WindowsGDI._screenGlitches();
	}
}

class WinEffect_ScreenShake extends WindowsGDIEffect
{
	override public function update()
	{
		WindowsGDI._screenShake();
	}
}

class WinEffect_ScreenTunnel extends WindowsGDIEffect
{
	override public function update()
	{
		WindowsGDI._screenTunnel();
	}
}

class WinEffect_SetTitleTextToWindows extends WindowsGDIEffect
{
	public var text:String = "";

	override public function update()
	{
		WindowsGDI._setCustomTitleTextToWindows(text);
	}
}
#end