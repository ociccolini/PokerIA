package com.novabox.playingCards 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Ophir
	 */
	public class PlayingCard extends Sprite
	{		
		public static const CARD_WIDTH:Number = 73;
		public static const CARD_HEIGHT:Number = 98;
		
		protected var clip:PlayingCardClip;
		protected var cardSuit:int;
		public var cardHeight:int;
		
		public function PlayingCard(_suit:int = Suit.CLUBS, _height:int = Height.ACE) 
		{
			cardSuit = _suit;
			cardHeight = _height;
			clip = new PlayingCardClip();

			Layout();
			addChild(clip);
		}
		
		public function Layout() : void
		{
			var heightIndex:int = (cardHeight + 1) % Height.COUNT;
			clip.cardsMap.x = CARD_WIDTH * heightIndex * -1;
			clip.cardsMap.y = CARD_HEIGHT * cardSuit * -1;		
		}
		
		public function GetSuit() : int
		{
			return cardSuit;
		}
		
		public function GetHeight() : int
		{
			return cardHeight;
		}
		
	}

}