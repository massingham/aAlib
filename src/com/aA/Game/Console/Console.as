package com.aA.Game.Console
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import com.aA.Text.Text;
	
	/**
	 * Simple in-game 2D Console.
	 * Eventually might need to be extended to support stage3d?
	 * 
	 * @author Anthony Massingham
	 */
	public class Console extends Sprite
	{
		private static var _instance:Console;
		
		private var open:Boolean = false;
		
		private var consoleText:TextField;
		private var inputText:TextField;
		
		private var backgroundSprite:Sprite;
		
		private var commands:Dictionary;
		
		private static const CONSOLE_HEIGHT:int = 200;
		
		public function Console(e:SingletonEnforcer) {
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public static function getInstance():Console {
			if (_instance == null) {
				_instance = new Console(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		private function init(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			open = false;
			commands = new Dictionary();
			
			backgroundSprite = new Sprite();
			addChild(backgroundSprite);
			backgroundSprite.graphics.beginFill(0, 0.8);
			backgroundSprite.graphics.drawRect(0, 0, stage.stageWidth, CONSOLE_HEIGHT);
			backgroundSprite.graphics.endFill();
			
			// TextFields
			consoleText = Text.getTextField("Console Created\n\n", 10, 0xFFFFFF, "LEFT", "_typewriter");
			addChild(consoleText);
			consoleText.autoSize = "none";
			consoleText.width = stage.stageWidth;
			consoleText.height = CONSOLE_HEIGHT - 30;
			consoleText.selectable = true;
			consoleText.mouseEnabled = true;
			
			inputText = Text.getInput(stage.stageWidth, 20, 12, 0xFFFFFF, 0x000000, "LEFT", "_typewriter");
			addChild(inputText);
			inputText.y = CONSOLE_HEIGHT - 20;
			inputText.restrict = "a-z A-Z 0-9 _"
			
			addCommand("commands", showCommands);
			addLine("Type 'commands' to List all commands\n");
			
			inputText.addEventListener(KeyboardEvent.KEY_DOWN, checkForEnter);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			this.visible = false;
		}
		
		private function onKeyDown(event:KeyboardEvent):void {
			event.stopImmediatePropagation();
			event.preventDefault();

			switch(event.keyCode) {
				case Keyboard.BACKQUOTE:
					// ~ or `
					this.toggleConsole();
				break;
			}
		}
		
		private function checkForEnter(event:KeyboardEvent):void {
			switch(event.keyCode) {
				case Keyboard.ENTER:
					parseInput(inputText.text);
					inputText.text = "";
				break;
			}
		}
		
		private function toggleConsole():void {
			open = !open;
			if (open) {
				// open
				this.visible = true;
				this.stage.focus = inputText;
			} else {
				// close
				this.visible = false;
			}
			
			inputText.text = inputText.text.replace(/`/g, "");
		}
		
		public function addCommand(commandName:String, runFunction:Function):void {
			if (runFunction == null) {
				commands[commandName] = "dispatch";
			} else {
				commands[commandName] = runFunction;
			}
		}
		
		private function showCommands(params:Array):void {
			var print:String = "";
			
			var alphabetical:Array = new Array();
			for (var key:String in commands) {
				alphabetical.push(key);
			}
			
			alphabetical.sort();
			
			if (params != null) {
				print += "COMMANDS CONTAINING " + params[0] + ":\n";
				
				var regex:RegExp = new RegExp(params[0],"gi");
				
				for (var i:int = 0; i < alphabetical.length; i++) {
					if (alphabetical[i].search(regex) != -1) {
						
						var text:String = alphabetical[i];
						var startPos:Number = text.search(regex);
						var textSplit:String = text.substr(0, startPos) + params[0].toUpperCase() + text.substring(startPos + params[0].length);
						
						print += " - " + textSplit + "\n";
					}
				}
			} else {
				print += "ALL COMMANDS\n";
				for (i = 0; i < alphabetical.length; i++) {
					print += " - " + alphabetical[i] + "\n";
				}
			}
			
			addLine(print);
		}
		
		private function parseInput(inputText:String):void {
			var stringSplit:Array = inputText.split(" ");
			var commandName:String = stringSplit[0];
			stringSplit.splice(0, 1);
			if (stringSplit.length == 0) {
				stringSplit = null;
			}
			addLine(">\"" + commandName + "\" (" + stringSplit + ")");			
			if (commands[commandName] == null) {
				addLine("I'm sorry \"" + commandName + "\" is not a recognised command");
			} else if (commands[commandName] == "dispatch") {
				// dispatch
				dispatchEvent(new ConsoleEvent(ConsoleEvent.DISPATCH_COMMAND, stringSplit, commandName));
			} else {
				commands[commandName].apply(null, [stringSplit]);
			}
		}
		
		public function addLine(line:String):void {
			consoleText.appendText(line +"\n");
			consoleText.scrollV = consoleText.numLines;
		}
	}
	
}

// Singleton enforcer, ensures that only one console can get added
class SingletonEnforcer{	
}