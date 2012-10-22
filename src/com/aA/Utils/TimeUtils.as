package com.aA.Utils 
{
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class TimeUtils 
	{
		private static var lastFrame:int = 0;
		private static var currFrame:int;
		private static var dT:Number;
		private static var fR:Number;
		
		public function TimeUtils() 
		{
			
		}
		
		public static function getDeltaTime():Number {
			currFrame = getTimer();
			dT = (currFrame - lastFrame) / 1000;
			lastFrame = currFrame;
			
			return dT;
		}
		
		public static function getFrameRate():Number {
			fR = 1 / dT;
			return fR;
		}
		
	}

}