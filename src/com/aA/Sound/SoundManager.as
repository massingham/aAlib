package com.aA.Sound 
{
	import com.aA.Mobile.SharedDataManager;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class SoundManager 
	{
		private static var _instance:SoundManager;
		
		public static const TYPE_SFX:String = "SFX";
		public static const TYPE_MUSIC:String = "MUSIC";
		
		private var soundDictionary:Dictionary;
		private var currentSounds:Array;
		private var transforms:Dictionary;
		
		private var _muteSound:Boolean;
		private var _muteMusic:Boolean;
		
		public function SoundManager() 
		{
			soundDictionary = new Dictionary();
			currentSounds = [];
			
			transforms = new Dictionary();
			transforms[TYPE_SFX] = new SoundTransform(1);
			transforms[TYPE_MUSIC] = new SoundTransform(1);
			
			var sfxVol:Number = SharedDataManager.getInstance().load(SharedDataManager.SYSTEM, "volume_" + TYPE_SFX);
			var musicVol:Number = SharedDataManager.getInstance().load(SharedDataManager.SYSTEM, "volume_" + TYPE_MUSIC);
			
			if (!isNaN(sfxVol)) transforms[TYPE_SFX].volume = sfxVol;
			if (!isNaN(musicVol)) transforms[TYPE_MUSIC].volume = musicVol;
		}
		
		public static function getInstance():SoundManager { 
			if (_instance == null) {
				_instance = new SoundManager();
			}
			
			return _instance;
		}
		
		public function toggleMute(type:String):void {
			
		}
		
		public function setVolume(type:String, value:Number):void {
			SoundTransform(transforms[type]).volume = value;
			
			SharedDataManager.getInstance().save(SharedDataManager.SYSTEM, "volume_" + type, value);
		}
		
		public function getVolume(type:String):Number {
			return SoundTransform(transforms[type]).volume;
		}
		
		public function addSound(name:String, sound:Sound, type:String):void {
			var soundObject:Object = new Object();
			
			soundObject.name = name;
			soundObject.sound = sound;
			soundObject.type = type;
			
			soundDictionary[name] = soundObject;
		}
		
		public function pause():void {
			for (var i:int = 0; i < currentSounds.length; i++) {
				currentSounds[i].resumeposition = SoundChannel(currentSounds[i].channel).position;
				SoundChannel(currentSounds[i].channel).stop();
			}
		}
		
		public function resume():void {
			for (var i:int = currentSounds.length - 1; i >= 0; i--) {
				playSound(currentSounds[i].obj, currentSounds[i].resumeposition);
				currentSounds.splice(i, 1);
			}
		}
		
		public function playSound(name:String, position:int = 0):void {
			var snd:Object = soundDictionary[name];
			if (snd) {
				var chan:SoundChannel = snd.sound.play(position, 0,transforms[snd.type]);
				chan.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				currentSounds.push( { channel:chan, obj:name, resumeposition:0 } );
			} else {
				throw new Error("SoundManager : Sound " + name + " does not exist");
			}
		}
		
		private function onSoundComplete(event:Event):void {
			for (var i:int = currentSounds.length - 1; i >= 0; i--) {
				if (currentSounds[i].channel == event.currentTarget) {
					currentSounds.splice(i, 1);
				}
			}
		}
		
		/**public function playSound(name:String):void {
			var snd:Object = soundDictionary[name];
			if (snd) {	
				var sound:Sound = new snd.sound;
				sound.play(0, 0, transforms[snd.type]);
			} else {
				throw new Error("SoundManager : Sound " + name + " does not exist");
			}
		}**/
		
		public function stopSound(id:String, type:String, pause:Boolean = false):void {
			// ??
		}
		
		public function stopAllSounds(type:String = ""):void {
			
		}
	}

}