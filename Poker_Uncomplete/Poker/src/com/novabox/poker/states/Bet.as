package com.novabox.poker.states 
{
	import com.novabox.poker.PokerTable;
	/**
	 * ...
	 * @author Ophir
	 */
	public class Bet extends PokerTableState
	{
		public static var ID:String = "Bet";
		
		public function Bet(_pokerTable:PokerTable) 
		{
			super(_pokerTable, ID);
		}
		
		override public function Enter() : void
		{
			if (!GetTable().ShouldPlay(GetTable().GetCurrentPlayer()))
			{
				GetTable().UpdateCurrentPlayer();
			}
			GetTable().PerfomPlayersAction("ProcessBetRoundStart", GetTable());
		}
		
		override public function Update() : void
		{
			if (GetTable().GetCurrentPlayer().HasPlayed())
			{
				GetTable().PerfomPlayersAction("ProcessPlayerAction", GetTable().GetCurrentPlayer());
				//trace("Has played : " + GetTable().GetCurrentPlayer().GetName());
				GetTable().GetCurrentPlayer().SetPlayed(false);
				GetTable().UpdateCurrentPlayer();
			}
			else
			{
				//trace("Playing : " + GetTable().GetCurrentPlayer().GetName());
				var played:Boolean = GetTable().GetCurrentPlayer().Play(GetTable());
				GetTable().GetCurrentPlayer().SetPlayed(played);
				if (GetTable().GetCurrentPlayer().HasFold())
				{
					GetTable().RegisterFoldedPlayer(GetTable().GetCurrentPlayer());
				}
			}
		}
		
		override public function Exit() : void
		{
		
		}
	}

}