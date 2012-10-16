package com.aA.Game.AI.FSM 
{
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class StateMachine 
	{
		private var currentState:State;
		private var previousState:State;
		private var nextState:State;
		
		public function StateMachine() 
		{
			currentState = null;
			nextState = null;
			previousState = null;
		}
		
		public function update(time:Number):void {
			if (currentState) {
				currentState.update(time);
			}
		}
		
		public function setNextState(s:State):void {
			nextState = s;
		}
		
		public function changeState(s:State):void {
			if (currentState) {
				currentState.Exit();
				previousState = currentState;
			}
			
			currentState = s;
			currentState.Enter();
		}
		
		public function goToPreviousState():void {
			changeState(previousState);
		}
		
		public function goToNextState():void {
			changeState(nextState);
		}
	}

}