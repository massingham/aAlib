package com.aA.Game.AI.FSM {
	public interface State {
		function Enter():void;				// Called on entering the state
		function Exit():void;				// Called on leaving the state
		function update(time:Number):void;	// Called every frame while in the state
	}
}