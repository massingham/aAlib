package com.aA.Game.Statistics 
{
	import flash.utils.Dictionary;
	/**
	 * Tracks statistics for a game.  Super fancy shmanchy
	 * @author Anthony Massingham
	 */
	public class StatTracker 
	{
		
		private static var _instance:StatTracker;
		
		// Data
		private var values:Dictionary;
		private var collection:Dictionary;
		private var misc:Vector.<Dictionary>;
		
		// Round Information
		private var startTime:Number;
		private var endTime:Number;
		
		public function StatTracker() 
		{
			clearAllStats();
		}
		
		public function clearAllStats():void {
			values = new Dictionary();
			collection = new Dictionary();
			
			misc = new Vector.<Dictionary>();
		}
		
		public static function getInstance():StatTracker {
			if (_instance == null) {
				_instance = new StatTracker();
			}
			return _instance;
		}
		
		/**
		 * 		Tallies. +/- 1 each time
		 **/
		
		public function add(statName:String, value:int = 1):void {
			if (values[statName] == null) {
				values[statName] = 0;
			}
			
			values[statName] += value;
		}
		
		public function subtract(statName:String, value:int = 1):void {
			if (values[statName] == null) {
				values[statName] = 0;
			}
			
			values[statName] -= value;
		}
		
		public function getValue(statName:String):int {
			if (values[statName] == null) {
				return 0;
			}
			return values[statName];
		}		
		
		public function startRound():void {
			var d:Date = new Date();
			startTime = d.time;
			endTime = 0;
		}
		
		public function endRound():void {
			var d:Date = new Date();
			endTime = d.time;
		}
		
		public function getRoundLength():Number {
			return endTime - startTime;
		}
		
		public function collect(statName:String, value:int):void {
			if (collection[statName] == null) {
				collection[statName] = new Vector.<int>();
			}
			
			collection[statName].push(value);
		}
		
		public function getCollection(statName:String):Vector.<int> {
			return collection[statName];
		}
		
		
	}

}