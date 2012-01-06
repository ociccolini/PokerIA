package com.novabox.pokerGUI 
{
	import com.novabox.playingCards.PlayingCard;
	import com.novabox.poker.PokerAction;
	import com.novabox.poker.PokerPlayer;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Ophir
	 */
	public class PokerPlayerGUI extends PlayerBox
	{
		protected const boxWidth:Number = width;
		protected const boxHeight:Number = height;
		
		protected var card1:PlayingCard;
		protected var card2:PlayingCard;
		
		protected var player:PokerPlayer;
		
		public function PokerPlayerGUI(_player:PokerPlayer) 
		{
			player = _player;
			
			card1 = null;
			card2 = null;			
		}
		
		public function SetCards(_card1:PlayingCard, _card2:PlayingCard) : void
		{
			card1 = _card1;
			card2 = _card2;
			if (card1 != null)
			{
				card1.x = boxWidth/2- PlayingCard.CARD_WIDTH;
				card1.y = boxHeight/2 - PlayingCard.CARD_HEIGHT / 2;
				addChild(card1);
			}
			
			if (card2 != null)
			{
				card2.x = boxWidth/2;
				card2.y = boxHeight/2 - PlayingCard.CARD_HEIGHT / 2;
				addChild(card2);
			}
		}
		
		public function ClearCards() : void
		{
			if (card1 != null)
			{
				removeChild(card1);
				card1 = null;
			}
			if (card2 != null)
			{
				removeChild(card2);
				card2 = null;
			}
		}
		
		public function SetAction(_action:int) : void
		{
			actionSymbol.gotoAndStop("none");
			
			switch(_action)
			{
				case PokerAction.NONE:
				actionSymbol.gotoAndStop("none");
				break;

				case PokerAction.CHECK:
				actionSymbol.gotoAndStop("check");
				break;
				
				case PokerAction.CALL:
				actionSymbol.gotoAndStop("call");
				break;
				
				case PokerAction.FOLD:
				actionSymbol.gotoAndStop("fold");
				break;

				case PokerAction.RAISE:
				actionSymbol.gotoAndStop("raise");
				break;
}
		}
		
		protected function ResetBackground() : void
		{
			background.gotoAndStop("normal");		
		}
		
		public function SetHighlighted(_value:Boolean) : void
		{
			if (_value)
			{
				background.gotoAndStop("highlight");
			}
		}

		public function SetHasFold(_value:Boolean) : void
		{
			if (_value)
			{
				background.gotoAndStop("fold");
			}
		}

		public function SetHasLost(_value:Boolean) : void
		{
			if (_value)
			{
				background.gotoAndStop("lost");
			}
		}

		public function SetHasWon(_value:Boolean) : void
		{
			if (_value)
			{
				actionSymbol.gotoAndStop("win");
			}
		}


		public function SetDealer(_value:Boolean) : void
		{
			if (_value)
			{
				dealerButton.gotoAndStop("active");
			}
			else
			{
				dealerButton.gotoAndStop("inactive");
			}
		}
	
		public function Update() : void
		{
			ResetBackground();
			if (player !=  null)
			{
				stackValue.text = "";
				if (player.GetStackValue() > 0)
				{
					stackValue.text = player.GetStackValue().toString();
				}
				
				SetAction(player.GetLastAction());			
			}
		}
	}

}