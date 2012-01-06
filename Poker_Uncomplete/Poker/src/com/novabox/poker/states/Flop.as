package com.novabox.poker.states 
{
	import com.novabox.poker.PokerTable;
	/**
	 * ...
	 * @author Ophir
	 */
	public class Flop extends PokerTableState
	{
		public static var ID:String = "Flop";
		
		public function Flop(_pokerTable:PokerTable) 
		{
			super(_pokerTable, ID);
		}
		
		override public function Enter() : void
		{
			GetTable().CommitPlayerBets();
			GetTable().SetCurrentPlayerAsDealer();
			
			GetTable().TracePots();

			GetTable().DealBoardCard();
			GetTable().DealBoardCard();
			GetTable().DealBoardCard();

			GetTable().PerfomPlayersAction("ProcessFlopStart", GetTable());
		}
		
		override public function Exit() : void
		{
			GetTable().ResetPlayerActions();	
			GetTable().UpdateCurrentPlayer();			
		}
		
	}

}