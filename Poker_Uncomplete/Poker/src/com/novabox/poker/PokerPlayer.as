package com.novabox.poker 
{
	import com.novabox.playingCards.PlayingCard;
	import flash.media.Video;
	/**
	 * ...
	 * @author Ophir
	 */
	public class PokerPlayer
	{
		protected var name:String;
		
		protected var hand:Array;
		protected var stackValue:Number;
		protected var betValue:Number;
		
		protected var lastAction:int;
		
		protected var allIn:Boolean;
		protected var hasLost:Boolean;
		protected var hasWon:Boolean;
		
		protected var played:Boolean;
		
		public function PokerPlayer(_name:String, _stackValue:Number) 
		{
			name = _name;
			stackValue = _stackValue;
			lastAction = PokerAction.NONE;
			hand = new Array();
			
			betValue = 0;
			
			allIn = false;
			hasLost = false;
			hasWon = false;
			played = false;
		}
		
		public function GetName() : String
		{
			return name;
		}
		
		public function GetLastAction() : int
		{
			return lastAction;
		}
		
		public function ResetAction() : void
		{
			lastAction = PokerAction.NONE;
			played = false;
		}
		
		public function ResetBet() : void
		{
			betValue = 0;
		}
		
		public function HasPlayedOnce() : Boolean
		{
			return (lastAction != PokerAction.NONE);
		}
		
		public function HasPlayed() : Boolean
		{
			return played;
		}
		
		public function SetPlayed(_value:Boolean) : void
		{
			played = _value;
		}
		
		public function HasFold() : Boolean
		{
			return lastAction == PokerAction.FOLD;
		}
		
		public function HasLost() : Boolean
		{
			return hasLost;
		}
		
		public function SetLost(_value:Boolean) : void
		{
			hasLost = _value;
		}
		
		public function HasWon() : Boolean
		{
			return hasWon;
		}
		
		public function SetWon(_value:Boolean) : void
		{
			hasWon = _value;
		}
	
		public function IsAllIn() : Boolean
		{
			return allIn;
		}
		
		public function ResetAllIn() : void
		{
			allIn = false;
		}
		
		public function HasBet(_callValue:Number) : Boolean
		{
			return (IsAllIn() || (betValue == _callValue));
		}
		
		protected function Bet(_value:Number) : void
		{
			if (stackValue >= _value)
			{
				betValue += _value;
				stackValue -= _value;
			}
			else
			{
				betValue += stackValue;
				stackValue = 0;
				
				allIn = true;
			}
		}

		public function Raise(_value:Number, _callValue:Number) : void
		{
			Bet(_value + (_callValue - betValue));
			lastAction = PokerAction.RAISE;
			TraceAction("Raise " + _value + "(Call value : " +_callValue + ")");
		}
		
		public function Call(_callValue:Number) : void
		{
			Bet(_callValue - betValue);
			lastAction = PokerAction.CALL;
			TraceAction("Call");
		}
		
		public function Check() : void
		{
			lastAction = PokerAction.CHECK;
			TraceAction("Check");
		}
		
		public function Fold() : void
		{
			lastAction = PokerAction.FOLD;
			TraceAction("Fold");
		}
		
		public function GetBetValue() : Number
		{
			return betValue;
		}
	
		public function SubstractBetValue(_value:Number) : void
		{
			if (betValue >= _value)
			{
				betValue -= _value;
			}
			else
			{
				betValue = 0;
			}
		}
		
		public function GetStackValue() : Number
		{
			return stackValue;
		}
		
		public function ResetCards() : void
		{
			while (hand.length > 0)
			{
				hand.pop();
			}
		}
		
		public function DealCard(_card:PlayingCard) : void
		{
			hand.push(_card);
		}

		public function GetCard(_index:int) : PlayingCard
		{
			return hand[_index];
		}
		
		public function PostSmallBlind(_poekrTable:PokerTable) :  void
		{
			Bet(_poekrTable.GetSmallBlind());
			TraceAction("Small Blind");
		}

		public function PostBigBlind(_poekrTable:PokerTable) :  void
		{
			Bet(_poekrTable.GetBigBlind());			
			TraceAction("Big Blind");
		}

		public function Play(_pokerTable:PokerTable) : Boolean
		{
			if (CanCheck(_pokerTable))
			{
				if (Math.random() < 0.5)
				{
					Check();
				}
				else
				{
					Raise(Math.floor(stackValue * Math.random() / 2), _pokerTable.GetValueToCall());					
				}
			}
			else 
			{
				if (Math.random() < 0.5)
				{
					if (Math.random() < 0.3)
					{
						Raise(Math.floor(stackValue * Math.random() / 2), _pokerTable.GetValueToCall());
					}
					else
					{
						Call(_pokerTable.GetValueToCall());
					}
				}
				else
				{
					Fold();
				}
			}
			return (lastAction != PokerAction.NONE);
		}
		
		public function CanCheck(_pokerTable:PokerTable) : Boolean
		{
			return (_pokerTable.GetValueToCall() == 0);
		}

		public function AddToStack(_value:Number) : void
		{
			stackValue += _value;
		}
		
		public function TraceAction(_action: String) : void
		{
			
			var actionString:String = name + "[" + stackValue + "]" + " : " + _action + "(" + betValue + ")";
			if (IsAllIn())
			{
				actionString += " - ALL IN";
			}
			
			trace(actionString);
		}
		
		public function ProcessHandStart(_pokerTable:PokerTable) : void
		{
			
		}
		
		public function ProcessBetRoundStart(_pokerTable:PokerTable) : void
		{
			
		}
		
		public function ProcessPreflopStart(_pokerTable:PokerTable) : void
		{
			
		}
		
		public function ProcessFlopStart(_pokerTable:PokerTable) : void
		{
			
		}

		public function ProcessTurnStart(_pokerTable:PokerTable) : void
		{
			
		}

		public function ProcessRiverStart(_pokerTable:PokerTable) : void
		{
			
		}

		public function ProcessHandEnd(_pokerTable:PokerTable) : void
		{

		}
		
		public function ProcessPlayerAction(_player:PokerPlayer) : void
		{
			
		}
		
		public function ProcessPlayerShowdown(_player:PokerPlayer) : void
		{

		}
		
		public function ProcessPlayerWon(_player:PokerPlayer) : void
		{
			
		}
		
	}

}