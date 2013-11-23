package net.pirsquare.m
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.Capabilities;

	/**
	 * Contains mobile handy stuff here
	 * @author katopz
	 */
	public class MobileUtil
	{
		/**
		 * Will wake up when app running and can sleep if soft exist
		 *
		 * Apple iOS will need below code for audio
		 *
		 * <iPhone>
		 *  <InfoAdditions>
		 * <![CDATA[
		 *    <key>UIBackgroundModes</key>
		 *    <array>
		 *     <string>audio</string>
		 *     </array>
		 *   ]]>
		 *  </InfoAdditions>
		 * </iPhone>
		 *
		 * Android will need
		 *
		 * <uses-permission android:name="android.permission.DISABLE_KEYGUARD"/>
		 * <uses-permission android:name="android.permission.WAKE_LOCK"/>
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/desktop/SystemIdleMode.html
		 *
		 * @param stage
		 */
		public static function alwaysWakeUp(stage:Stage):void
		{
			// ignore desktop
			if (isAIRDesktop)
				return;

			stage.addEventListener(Event.DEACTIVATE, function onLeave(event:Event):void
			{
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
			});

			stage.addEventListener(Event.ACTIVATE, function onComeBack(event:Event):void
			{
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			});
		}

		/**
		 * Check whether user is on desktop ot not
		 * @return true if on desktop
		 *
		 */
		private static function get isAIRDesktop():Boolean
		{
			const os:String = Capabilities.os.split(" ")[0];
			return (Capabilities.playerType == "Desktop") && ((os == "Windows") || (os == "Mac"));
		}
	}
}
