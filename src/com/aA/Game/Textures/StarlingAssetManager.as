package com.aA.Game.Textures 
{
	import feathers.system.DeviceCapabilities;
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class StarlingAssetManager 
	{
		private static var textureAtlas:TextureAtlas;
		private static var textures:Dictionary = new Dictionary();
		
		// [Embed("imageatlas.xml", mimeType="application/octet-stream")]
		// [Embed("imagetexture.png")]
		
		private static var AtlasTexture:Class;
		private static var AtlasXML:Class;
		
		public static var scaledDPI:int;
		public static var scale:Number;
		
		public static function setTextureAndXML(texture:Class, xml:Class):void {
			AtlasTexture = texture;
			AtlasXML = xml;
		}
		
		public static function getAtlas():TextureAtlas {
			if (textureAtlas == null) {
				var texture:Texture = getTexture("AtlasTexture");
				var xml:XML = XML(new AtlasXML());
				textureAtlas = new TextureAtlas(texture, xml);
			}
			
			return textureAtlas;
		}
		
		public static function getTexture(name:String):Texture {
			if (textures[name] == undefined) {
				var bitmap:Bitmap = new StarlingAssetManager[name]();
				textures[name] = Texture.fromBitmap(bitmap);
			}
			return textures[name];
		}
		
		public static function setDPI():void {
			scaledDPI = DeviceCapabilities.dpi / Starling.contentScaleFactor;
			
			trace(DeviceCapabilities.dpi);
			trace(Starling.contentScaleFactor);
			trace(scaledDPI);
		}
	}

}