package com.novabox.poker.states 
{
	import com.novabox.poker.PokerTable;
	/**
	 * ...
	 * @author Ophir
	 */
	public class End extends PokerTableState
	{
		public static var ID:String = "Game End";
		
		public function End(_pokerTable:PokerTable) 
		{
			super(_pokerTable, ID);
		}
		
		override public function Enter() : void
		{
			trace("Game Finished");
		}
		
	}

}