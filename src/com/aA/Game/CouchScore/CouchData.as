package com.aA.Game.CouchScore 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class CouchData 
	{
		public var id:String;
		public var rev:String;	// Required for saving
		
		public var data:Object;
		
		public function CouchData() 
		{
			
		}
		
		public function addObject(o:Object):void {
			this.data = o;
		}
		
		public function setDataFromString(value:String):void {
			var jsonobj:Object = JSON.parse(value);
			setDataFromObject(jsonobj);
		}
		
		public function setDataFromObject(value:Object):void {
			this.id = value.id;
			this.rev = value.value._rev;
			
			data = value.value;
		}
		
		public function getUpdateString():String {
			data._rev = this.rev;
			
			return JSON.stringify(data);
		}
		
		public function save():void {
			
		}
		
		public function onUpdate(event:Event):void {
			var result:Object = JSON.parse(URLLoader(event.currentTarget).data);
			trace("successfully updated");
			this.rev = result._rev;
		}
		
	}

}