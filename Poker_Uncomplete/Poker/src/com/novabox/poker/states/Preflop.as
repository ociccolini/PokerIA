package com.novabox.poker.states 
{
	import com.novabox.poker.PokerPlayer;
	import com.novabox.poker.PokerTable;
	/**
	 * ...
	 * @author Ophir
	 */
	public class Preflop extends PokerTableState
	{		
		public static const ID:String = "Preflop";
		
		public function Preflop(_pokerTable:PokerTable) 
		{
			super(_pokerTable, ID);
		}
		
		override public function Enter() : void
		{
			GetTable().GetDeck().Initialize();
			GetTable().GetDeck().Shuffle();
			
			for (var cards:int = 0; cards < PokerTable.PLAYER_HAND_CARDS_COUNT; cards++)
			{
				for (var i:int = 0; i < PokerTable.PLAYERS_COUNT; i++)
				{
					var player:PokerPlayer = GetTable().GetPlayer(i);
					
					if (!player.HasLost())
					{
						player.DealCard(GetTable().GetDeck().GetTopCard());
					}
				}
			}
			
			GetTable().PerfomPlayersAction("ProcessPreflopStart", GetTable());
		}
	}

}