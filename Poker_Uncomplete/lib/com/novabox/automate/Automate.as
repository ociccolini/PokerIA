package com.novabox.automate 
{
	/**
	 * @author Ophir / Nova-box
	 * @version 1.0
	 */
	public class Automate
	{	
		protected var currentState:AutomateState;
		protected var previousState:AutomateState;
		
		public function Automate() 
		{
			previousState = null;
			currentState = null;
		}
				
		public function SetCurrentState(_state:AutomateState) : void
		{
			if (currentState != null)
			{
				previousState = currentState;
				currentState.Exit();			
			}
			
			currentState = _state;
			trace("---------" + currentState.GetId());

			currentState.Enter();
			
		}
		
		public function GetCurrentStateId() : String		
		{
			if (currentState != null)
			{
				return currentState.GetId();
			}
			return null;
		}
		
		public function GetPreviousStateId() : String		
		{
			if (previousState != null)
			{
				return previousState.GetId();
			}
			return null;
		}

		public function Update() : void
		{
			if (currentState != null)
			{
				currentState.Update();
				var nextState:AutomateState = currentState.GetNextState();
				if (nextState != null)
				{
					SetCurrentState(nextState);
				}
			}
		}
	}

}