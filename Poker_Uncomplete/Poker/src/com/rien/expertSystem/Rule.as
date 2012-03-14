package com.rien.expertSystem 
{
	import adobe.utils.ProductManager;
	import flash.display.GradientType;
	
	public class Rule
	{
		
		private var premises:Array;
		private var goal:Fact;
		
		public function Rule(_goal:Fact, _premises:Array) 
		{
			goal = _goal;
			premises = _premises;
		}
		
		public function GetPremises() : Array
		{
			return premises;
		}
		
		public function GetGoal() : Fact
		{
			return goal;
		}
		
	}

}