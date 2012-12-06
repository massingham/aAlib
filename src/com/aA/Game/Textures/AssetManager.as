package com.aA.Game.Textures 
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class AssetManager 
	{
		public static var _instance:AssetManager;
		private var library:Dictionary;
		private var loader:Loader;
		
		public function AssetManager() 
		{
			library = new Dictionary();
		}
		
		public static function getInstance():AssetManager {
			if (_instance == null) {
				_instance = new AssetManager();
			}
			return _instance;
		}
		
		public function getItem(name:String):MovieClip {
			var returnObject:Object = getDefinitionByName(name);
			var returnMovieClip:MovieClip = new returnObject() as MovieClip;
			
			return returnMovieClip;
		}		
	}

}