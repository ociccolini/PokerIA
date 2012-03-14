package com.rien.expertSystem 
{
	public class Fact
	{
		private var label:String;

		public function Fact(_label:String) 
		{
			label = _label;
		}
		
		public function GetLabel() : String
		{
			return label;
		}		
	}

}