package com.aA.Mobile 
{
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class SharedDataManager 
	{
		private static var _instance:SharedDataManager;
		
		public static const DATA:String = "data";
		public static const SYSTEM:String = "system";
		
		public function SharedDataManager() 
		{
		}
		
		public static function getInstance():SharedDataManager {
			if (_instance == null) {
				_instance = new SharedDataManager();
			}
			
			return _instance;
		}
		
		public function save(type:String, property:String, data:*):void {
			var sharedObject:SharedObject = SharedObject.getLocal(type);
			
			sharedObject.setProperty(property, data);
			sharedObject.flush();
		}
		
		public function load(type:String, property:String):*{
			var sharedObject:SharedObject = SharedObject.getLocal(type);
			
			return sharedObject.data[property];
		}
		
		public function clear(type:String, property:String):void {
			var sharedObject:SharedObject = SharedObject.getLocal(type);
			if (property == "") {
				sharedObject.clear();
			} else {
				sharedObject.setProperty(property, null);
			}
			sharedObject.flush();
		}
		
	}

}