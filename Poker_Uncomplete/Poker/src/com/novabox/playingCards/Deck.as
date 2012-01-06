package com.novabox.playingCards 
{
	/**
	 * ...
	 * @author Ophir
	 */
	public class Deck
	{
		protected static const SHUFFLE_ITERATION_COUNT : int = 100;
		public static const CARDS_COUNT : int = Suit.COUNT * Height.COUNT;
		
		protected var cards:Array;
		
		public function Deck() 
		{
			cards = new Array();
			Initialize();
		}
		
		public function Initialize() : void
		{
			cards = new Array();
			for (var suit:int = 0; suit < Suit.COUNT; suit++)
			{
				for (var height:int = 0; height < Height.COUNT; height++)
				{
					var card:PlayingCard = new PlayingCard(suit, height);
					cards.push(card);
				}
			}
		}
		
		public function GetCard(_index:int) : PlayingCard
		{
			return cards[_index];
		}
		
		public function Shuffle() : void
		{
			for (var i:int = 0; i < SHUFFLE_ITERATION_COUNT; i++)
			{
				var cardIndex1:int = cards.length * Math.random();
				var cardIndex2:int = cards.length * Math.random();
				
				var tempCard:PlayingCard	= GetCard(cardIndex1);
				cards[cardIndex1]			= GetCard(cardIndex2);
				cards[cardIndex2]			= tempCard;
			}
		}
		
		public function GetTopCard() : PlayingCard
		{
			return cards.shift();
		}
		
		public function GetCardFromValue(_suit:int, _height:int) : PlayingCard
		{
			for (var i:int = 0; i < cards.length; i++)
			{
				var card:PlayingCard = cards[i];
				if ((card.GetSuit() == _suit) && (card.GetHeight() == _height))
				{
					return card;
				}
			}
			return null;
		}
		
		public function RemoveCard(_card:PlayingCard) : void
		{
			var newCards:Array = new Array();
			for (var i:int = 0; i < cards.length; i++)
			{
				if (cards[i] != _card)
				{
					newCards.push(cards[i]);
				}
			}
			cards = newCards;
		}
		
		public function GetLength() : int
		{
			return cards.length;
		}
	}

}