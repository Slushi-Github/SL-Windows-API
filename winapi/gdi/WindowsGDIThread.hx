package winapi.gdi;

import sys.thread.Thread;

import winapi.gdi.WindowsGDI;
import winapi.gdi.WindowsGDIEffectData;

/*
 * This class starts an external thread to the main one of the program, 
 * it is used so that Windows GDI effects do not generate lag in the 
 * main thread due to the fact that they consume quite some
 * 
 * Author: Slushi
 */
class WindowsGDIThread
{
	/**
	 * The main thread that will run the Windows GDI effects
	 */
	private static var mainThread:Thread;

	/**
	 * A map containing all the registered GDI effects
	 */
	public static var gdiEffects:Map<String, WindowsGDIEffectData> = [];

	/**
	 * Whether the thread is running or not
	 */
	public static var runningThread:Bool = true;

	/**
	 * The elapsed time since the thread started
	 */
	public static var elapsedTime:Float = 0;

	/**
	 * Whether the thread is temporarily paused
	 */
	public static var temporarilyPaused:Bool = false;

	/**
	 * Starts the Windows GDI Thread if it is not already started
	 * 
	 * The thread will loop through all the registered GDI effects and update them
	 */
	public static function initWindowsGDIThread():Void
	{
		#if HX_WINDOWS
		if (mainThread != null)
			return;

		trace('Starting Windows GDI Thread...');

		mainThread = Thread.create(() ->
		{
			try {
				trace('Windows GDI Thread running...');
				while (runningThread) {
					if (temporarilyPaused) {
						return;
					}

					elapsedTime++;
					WindowsGDI.setElapsedTime(elapsedTime);

					for (gdi in gdiEffects) {
						if (gdi == null || !gdi.enabled)
							continue;

						if (gdi.wait > 0) {
							// Wait if wait time is greater than 0, slows down the effect
							Sys.sleep(gdi.wait);
						}
						
						gdi.gdiEffect.update();
					}
				}
			} catch (e:Dynamic) {
				trace('Error in Windows GDI Thread: ' + e);
				stopWindowsGDIThread();
			}
		});
		#end
	}

	/**
	 * Stops the Windows GDI Thread
	 */
	public static function stopWindowsGDIThread()
	{
		#if HX_WINDOWS
		if (mainThread != null)
		{
			trace('Stopping Windows GDI Thread...');
			runningThread = false;
			temporarilyPaused = false;
			mainThread = null;
		}
		gdiEffects.clear();
		elapsedTime = 0;
		WindowsGDI.setElapsedTime(elapsedTime);
		#end
	}
}