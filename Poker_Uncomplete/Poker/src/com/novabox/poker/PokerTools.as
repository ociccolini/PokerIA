package com.novabox.poker 
{
	import com.novabox.playingCards.Height;
	import com.novabox.playingCards.PlayingCard;
	import com.novabox.poker.evaluator.HandEvaluator;
	/**
	 * ...
	 * @author Ophir
	 */
	public class PokerTools
	{
		protected static var evaluator:HandEvaluator = new HandEvaluator();
		
		public static function GetCardSetValue(_cardSet:Array) : int
		{
			
			
			var intArray:Array = new Array();
			for (var i:int = 0; i < _cardSet.length; i++)
			{
				intArray[i] = evaluator.GetCardInt(_cardSet[i]);
			}
			
			var result:int = 0;
			
			if ( intArray.length == 5)
			{
				result = evaluator.eval_5hand(intArray);
			}
			else if (intArray.length == 7)
			{
				result = evaluator.eval_7cards(intArray); 
			}
			else
			{
				trace("nb cartes : " + intArray.length);
				trace("Warning : invalid cardset size");
				result = evaluator.eval_7cards(intArray);	
			}
			
			return result;
		}
	
		public static function GetHandValue(_score:int) : int
		{
			return evaluator.hand_rank(_score);
		}
		
		protected static function GetCard(_cardSet:Array, _index:int) : PlayingCard
		{
			return	(_cardSet[_index] as PlayingCard);	
		}
		
	}

}