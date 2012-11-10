package com.aA.aUI 
{
	import com.aA.Text.Text;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class aUISimpleButton extends Sprite
	{		
		private var _width:int;
		private var _height:int;
		private var _labelText:String;
		private var _fontSize:int;
		
		private var bgSprite:Sprite;
		private var label:TextField;
		
		public function aUISimpleButton(w:int, h:int, labelText:String, fontSize:int = 10) 
		{
			_width = w;
			_height = h;
			_labelText = labelText;
			_fontSize = fontSize;
			
			this.name = labelText;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			bgSprite = new Sprite();
			addChild(bgSprite);
			
			bgSprite.graphics.beginFill(0x7F7F7F);
			bgSprite.graphics.drawRect(0, 0, _width, _height);
			bgSprite.graphics.endFill();
			
			label = Text.getTextField(_labelText, _fontSize, 0x383838);
			addChild(label);
			label.mouseEnabled = false;
			
			label.x = _width / 2 - label.width / 2;
			label.y = _height / 2 - label.height / 2;
			
			bgSprite.buttonMode = true;
		}
		
		public function set enabled(value:Boolean):void {
			if(value) {
				this.alpha = 1;
				this.mouseEnabled = true;
				this.mouseChildren = true;
			} else {
				this.alpha = 0.5;
				this.mouseEnabled = false;
				this.mouseChildren = false;
			}
		}
		
	}

}