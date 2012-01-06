package com.novabox.poker.states 
{
	import com.novabox.poker.PokerPot;
	import com.novabox.poker.PokerTable;
	/**
	 * ...
	 * @author Ophir
	 */
	public class Turn extends PokerTableState
	{
		public static const ID:String = "Turn";
		
		public function Turn(_pokerTable:PokerTable) 
		{
			super(_pokerTable, ID);
		}
		
		override public function Enter() : void
		{
			GetTable().CommitPlayerBets();
			GetTable().SetCurrentPlayerAsDealer();
			
			GetTable().TracePots();
			
			GetTable().DealBoardCard();
		
			GetTable().PerfomPlayersAction("ProcessTurnStart", GetTable());
		}
		
		override public function Exit() : void
		{
			GetTable().ResetPlayerActions();	
			GetTable().UpdateCurrentPlayer();			
		}
	}

}