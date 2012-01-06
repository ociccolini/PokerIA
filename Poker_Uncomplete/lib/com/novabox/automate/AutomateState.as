package com.novabox.automate 
{
	/**
	 * @author Ophir / Nova-box
	 * @version 1.0
	 */
	public class AutomateState
	{
		protected var automate:Automate;
		protected var transitions:Array;
		
		protected var id:String;
		
		public function AutomateState(_automate:Automate, _id:String)
		{
			automate = _automate;
			id = _id;
			
			transitions = new Array();
		}
		
		public function GetId() : String
		{
			return id;
		}

		public function Enter() : void
		{
			
		}
		
		public function Exit() : void
		{
			
		}
		
		public function Update() : void
		{
			
		}
		
		public function AddTransition(_transition:AutomateTransition) : void
		{
			transitions.push(_transition);
		}
		
		public function GetNextState() : AutomateState
		{
			for each(var transition:AutomateTransition in transitions)
			{
				if (transition.IsValid())
				{
					return transition.GetTargetState();
				}
			}
			return null;
		}
		
		
	}

}