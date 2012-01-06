package com.novabox.poker.states 
{
	import com.novabox.poker.PokerTable;
	/**
	 * ...
	 * @author Ophir
	 */
	public class InitGame extends PokerTableState
	{
		public static var ID:String = "Initializing Game";
		
		public function InitGame(_pokerTable:PokerTable) 
		{
			super(_pokerTable, ID);
		}
		
		override public function Enter() : void
		{
			GetTable().SetBlindValue(PokerTable.BLIND_START_VALUE);
		}
		
	}

}