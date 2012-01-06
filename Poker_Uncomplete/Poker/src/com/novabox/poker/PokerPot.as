package com.novabox.poker 
{
	/**
	 * ...
	 * @author Ophir
	 */
	public class PokerPot
	{
		protected var value:Number;
		protected var registeredPlayers:Array;
		protected var pokerTable:PokerTable;
		
		protected var indivisibleChips:Number = 0;
		
		public function PokerPot(_pokerTable:PokerTable) 
		{
			pokerTable = _pokerTable;
			
			value = 0;
			indivisibleChips = 0;
			
			Reset();
		}
		
		public function RegisterPlayer(_player:PokerPlayer) : void
		{
			var playerIndex:int = pokerTable.GetPlayerIndex(_player);
			if (playerIndex != -1)
			{
				if (registeredPlayers.indexOf(playerIndex) == -1)
				{
					registeredPlayers.push(playerIndex);
				}
			}
		}
		
		public function Reset() : void
		{
			registeredPlayers = new Array();
			value = indivisibleChips;
		}
		
		public function Add(_value:Number) : void
		{
			value += _value;
		}
		
		public function GetValue() : Number
		{
			return value;
		}
		
		public function Share(_ranking:Array) : void
		{
			var minRanking:int = int.MAX_VALUE;
			
			for (var i:int = 0; i < registeredPlayers.length; i++)
			{
				var playerIndex:int = registeredPlayers[i];
				if (_ranking[playerIndex] < minRanking)
				{
					minRanking = _ranking[playerIndex];
				}
			}

			
			var winnersCount:int = 0;
			for (i = 0; i < registeredPlayers.length; i++)
			{
				playerIndex = registeredPlayers[i];
				if (_ranking[playerIndex] == minRanking)
				{
					winnersCount++;
				}
			}
			
			indivisibleChips = value % winnersCount;
			if (isNaN(indivisibleChips))
			{
				indivisibleChips = 0;
			}
			
			var sharedValue:Number = (value - indivisibleChips) / winnersCount;
			
			
			for ( i = 0; i < registeredPlayers.length; i++)
			{
				playerIndex = registeredPlayers[i];
				if (_ranking[playerIndex] == minRanking)
				{
					var winner:PokerPlayer = pokerTable.GetPlayer(playerIndex);
					winner.AddToStack(sharedValue);
					pokerTable.PerfomPlayersAction("ProcessPlayerWon", winner);
					winner.TraceAction("wins " + sharedValue);
					winner.SetWon(true);
				}
			}
			
		}
	}

}