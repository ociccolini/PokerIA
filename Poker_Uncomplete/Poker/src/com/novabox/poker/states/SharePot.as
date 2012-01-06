package com.novabox.poker.states 
{
	import com.novabox.poker.PokerPlayer;
	import com.novabox.poker.PokerTable;
	/**
	 * ...
	 * @author Ophir
	 */
	public class SharePot extends PokerTableState
	{
		public static const ID:String = "SharePot";
		
		public function SharePot(_pokerTable:PokerTable) 
		{
			super(_pokerTable, ID);
		}
		
		override public function Enter() : void
		{
			GetTable().CommitPlayerBets();
			GetTable().SetCurrentPlayerAsDealer();
			
			GetTable().TracePots();
			var ranking:Array = GetTable().GetRanking();
			
		
			GetTable().SharePots(ranking);
			
			var showdownPlayersCount:int = GetShowdownPlayersCount(ranking);
			
			if (showdownPlayersCount > 1)
			{
				for (var i:int = 0; i < PokerTable.PLAYERS_COUNT; i++)
				{
					if (ranking[i] >= 0)
					{
						var showdownPlayer:PokerPlayer = GetTable().GetPlayer(i);
						GetTable().PerfomPlayersAction("ProcessPlayerShowdown", showdownPlayer);
					}
				}
			}
			
			for (i = 0; i < PokerTable.PLAYERS_COUNT; i++)
			{
				var player:PokerPlayer = GetTable().GetPlayer(i);
				if (!player.HasLost())
				{
					if (player.GetStackValue() <= 0)
					{
						player.SetLost(true);
						player.TraceAction("has lost");
					}
				}
			}
			
			GetTable().ResetPots();
			
			GetTable().PerfomPlayersAction("ProcessHandEnd", GetTable());
		}
		
		protected function GetShowdownPlayersCount(_ranking:Array) : int
		{
			var result:int = 0;
			for (var i:int = 0; i < PokerTable.PLAYERS_COUNT; i++)
			{
				if (_ranking[i] >= 0)
				{
					result++;
				}
			}
			return result;
		}
	}

}