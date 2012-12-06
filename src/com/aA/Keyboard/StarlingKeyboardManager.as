package com.aA.Keyboard 
{
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.KeyboardEvent;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class StarlingKeyboardManager extends EventDispatcher
	{
		
		private static var _instance:StarlingKeyboardManager;
		private var binds:Array;
		private var activeBinds:Array;
		
		public function StarlingKeyboardManager() 
		{
			binds = new Array();
			activeBinds = new Array();
		}
		
		public static function getInstance():StarlingKeyboardManager {
			if (_instance == null) {
				_instance = new StarlingKeyboardManager();
			}
			return _instance;
		}
		
		public function onKeyDown(e:KeyboardEvent):void {
			dispatchEvent(e);
			
			var command:String = binds[e.keyCode];
			if (command == null) return;
			var commandEvent:Event = new Event(command);
			activeBinds[command] = commandEvent;
		}
		
		public function onKeyUp(e:KeyboardEvent):void {
			dispatchEvent(e);
			
			var command:String = binds[e.keyCode];
			if (command == null) return;
			activeBinds[command] = null;
		}
		
		public function bindKey(keyCode:uint, command:String):void {
			binds[keyCode] = command;
		}
		
		public function unbindKey(keyCode:uint):void {
			binds[keyCode] = null;
		}
		
		public function update(e:Event):void {
			for each (var evt:Event in activeBinds) {
				if (evt != null) {
					dispatchEvent(evt);
				}
			}
		}
	}

}