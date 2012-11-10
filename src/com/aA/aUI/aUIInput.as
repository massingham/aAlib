package com.aA.aUI 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUIInput extends Sprite
	{
		private var _label:String;
		private var _width:int;
		
		private var labelTF:TextField;
		private var inputTF:TextField;
		
		public function aUIInput(label:String, w:int) 		
		{
			_label = label;
			_width = w;
		}
		
	}

}