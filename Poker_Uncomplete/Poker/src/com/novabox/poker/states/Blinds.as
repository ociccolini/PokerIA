package com.novabox.poker.states 
{
	import com.novabox.poker.PokerTable;
	/**
	 * ...
	 * @author Ophir
	 */
	public class Blinds extends PokerTableState
	{
		public static var ID:String = "Blinds";

		public function Blinds(_pokerTable:PokerTable) 
		{
			super(_pokerTable, ID);
		}
		
		override public function Enter() : void
		{
			GetTable().ResetBoard();
			GetTable().ResetFoldedPlayers();
			GetTable().ResetAllInPlayers();
			GetTable().ResetRanking();
			GetTable().ResetPlayerActions();		
			GetTable().ResetPlayerCards();
			GetTable().UpdateDealerPosition();
			GetTable().SetCurrentPlayerAsDealer();
			
			if (PokerTable.PLAYERS_COUNT > 2)
			{
				GetTable().UpdateCurrentPlayer();
			}
			
			GetTable().GetCurrentPlayer().PostSmallBlind(GetTable());
			
			GetTable().UpdateCurrentPlayer();
			GetTable().GetCurrentPlayer().PostBigBlind(GetTable());
		}
		
		override public function Exit() : void
		{
			GetTable().PerfomPlayersAction("ProcessHandStart", GetTable());

			//GetTable().CommitPlayerBets();
			GetTable().ResetPlayerActions();
			GetTable().UpdateCurrentPlayer();
		}
	}

}