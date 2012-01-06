package com.novabox.poker.states 
{
	import com.novabox.poker.PokerTable;
	/**
	 * ...
	 * @author Ophir
	 */
	public class River extends PokerTableState
	{
		public static const ID:String = "River";
		
		public function River(_pokerTable:PokerTable) 
		{
			super(_pokerTable, ID);
		}
		
		override public function Enter() : void
		{
			GetTable().CommitPlayerBets();
			GetTable().SetCurrentPlayerAsDealer();
			
			GetTable().TracePots();

			GetTable().DealBoardCard();
			GetTable().PerfomPlayersAction("ProcessRiverStart", GetTable());
}

		override public function Exit() : void
		{
			GetTable().ResetPlayerActions();	
			GetTable().UpdateCurrentPlayer();			
		}
	}

}