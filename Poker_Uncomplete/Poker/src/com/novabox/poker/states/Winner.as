package com.novabox.poker.states 
{
	import com.novabox.playingCards.PlayingCard;
	import com.novabox.poker.PokerPlayer;
	import com.novabox.poker.PokerTable;
	import com.novabox.poker.PokerTools;
	/**
	 * ...
	 * @author Ophir
	 */
	public class Winner extends PokerTableState
	{
		public static const ID:String = "Processing winner";
		
		public function Winner(_pokerTable:PokerTable) 
		{
			super(_pokerTable, ID);
		}
		
		override public function Enter() : void
		{
			var ranking:Array = GetRanking();
			
			GetTable().SetRanking(ranking);
		}

		
		
		protected function GetRanking() : Array
		{
			var playerScores:Array = new Array();
			
			for (var i:int = 0; i < PokerTable.PLAYERS_COUNT; i++)
			{
				var player:PokerPlayer = GetTable().GetPlayer(i);
				
				playerScores[i] = 0;
				
				if (!player.HasLost() && !GetTable().HasFolded(player))
				{
					var cardSet:Array = new Array();
					
					AddCard(cardSet, player.GetCard(0));
					AddCard(cardSet, player.GetCard(1));
					AddCard(cardSet, GetTable().GetBoard()[0]);
					AddCard(cardSet, GetTable().GetBoard()[1]);
					AddCard(cardSet, GetTable().GetBoard()[2]);
					AddCard(cardSet, GetTable().GetBoard()[3]);
					AddCard(cardSet, GetTable().GetBoard()[4]);
					
					var playerScore:int = PokerTools.GetCardSetValue(cardSet);
					
					playerScores[i] = playerScore * 100 + i;			
					
					trace(i + ":" + playerScores[i]);
				}
			}			
			
			playerScores.sort(Array.NUMERIC);
			
			var ranking:Array = new Array();
			
			var currentRanking:int = 0;
			
			for (i = 0; i < playerScores.length; i++)
			{
				if (playerScores[i] > 0)
				{
					var mask:int = playerScores[i] / 100;
					var playerIndex:int = playerScores[i] - mask * 100;
					
					ranking[playerIndex] = currentRanking;
					
					if (i <  playerScores.length - 1)
					{
						var currentScore:int = playerScores[i] / 100;
						var nextScore:int = playerScores[i + 1] / 100;
						
						if (currentScore != nextScore)
						{
							currentRanking++;
						}
						else
						{
							trace("ex aequo");							
						}
					}
				}
			}
						
			return ranking;
		}
		
		protected function AddCard(_cardSet:Array, _card:PlayingCard) : void
		{
			if (_card != null)
			{
				_cardSet.push(_card);
			}
		}
		
	}

}