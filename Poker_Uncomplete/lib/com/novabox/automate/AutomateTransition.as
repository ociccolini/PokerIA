package com.novabox.automate 
{
	/**
	 * @author Ophir / Nova-box
	 * @version 1.0
	 */
	public class AutomateTransition	
	{
		protected var targetState:AutomateState;
		protected var callBacks:Array;
		
		public function AutomateTransition(_targetState:AutomateState, ... _callBacks) 
		{
			targetState = _targetState;
			callBacks = _callBacks;
			
		}
		
		public function IsValid() : Boolean
		{
			for each(var callBack:Function in callBacks)
			{
				if (!callBack())
				{
					return false;
				}
			}
			return true;
		}
		
		public function GetTargetState() : AutomateState
		{
			return targetState;
		}
	}

}