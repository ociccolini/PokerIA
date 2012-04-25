package com.novabox.poker 
{
	import com.novabox.automate.Automate;
	import com.novabox.automate.AutomateTransition;
	import com.novabox.playingCards.Deck;
	import com.novabox.poker.states.Bet;
	import com.novabox.poker.states.Blinds;
	import com.novabox.poker.states.End;
	import com.novabox.poker.states.Flop;
	import com.novabox.poker.states.InitGame;
	import com.novabox.poker.states.Preflop;
	import com.novabox.poker.states.River;
	import com.novabox.poker.states.SharePot;
	import com.novabox.poker.states.Turn;
	import com.novabox.poker.states.Winner;
	import flash.ui.ContextMenuBuiltInItems;
	/**
	 * ...
	 * @author Ophir
	 */
	public class PokerTable extends Automate
	{
		public static const PLAYER_HAND_CARDS_COUNT:int	= 2;
		public static const PLAYERS_COUNT:int			= 4;
		public static const	PLAYER_INIT_STACK:Number	= 100;
		
		public static const BLIND_START_VALUE:Number	= 2;		
		public static const BLIND_STEP_HANDS_COUNT:Number	= 10;
		
		public var handsCount:int = 0;
		
		public var potTotal:Number;
		
		protected var players:Array;
		protected var deck:Deck;
		
		protected var board:Array;
		protected var pots:Array;
		
		protected var dealerIndex:int;
		protected var currentPlayerIndex:int;
		
		protected var blindValue:Number;
		
		protected var playersRanking:Array;
		
		protected var foldedPlayers:Array;
		
		public function PokerTable(_players:Array) 
		{
			potTotal = 0;
			
			dealerIndex = 0;
			
			players = _players;
			
			deck = new Deck();
			
			board = new Array();
			
			playersRanking = null;
						
			pots = new Array();
			AddPot();
			
			SetupStates();
		}
		
		protected function SetupStates() : void
		{
			var initGame:InitGame = new InitGame(this);
			var blinds:Blinds = new Blinds(this);
			
			var bet:Bet = new Bet(this);

			var preflop:Preflop = new Preflop(this);
			var flop:Flop = new Flop(this);
			var turn:Turn = new Turn(this);
			var river:River = new River(this);
		
			var winner:Winner = new Winner(this);
			var sharePot:SharePot = new SharePot(this);
			var end:End = new End(this);

			bet.AddTransition(new AutomateTransition(winner, IsOnePlayerLeft));

			initGame.AddTransition(new AutomateTransition(blinds, IsGameInitialized));
			
			blinds.AddTransition(new AutomateTransition(preflop, AreBlindsPosted));
			
			preflop.AddTransition(new AutomateTransition(bet, IsPreflopDealt, IsBetRoundNeeded));
			preflop.AddTransition(new AutomateTransition(flop, IsPreflopDealt));		
			bet.AddTransition(new AutomateTransition(flop, IsPreflopFinished));

			flop.AddTransition(new AutomateTransition(bet, IsFlopDealt, IsBetRoundNeeded));
			flop.AddTransition(new AutomateTransition(turn, IsFlopDealt));	
			bet.AddTransition(new AutomateTransition(turn, IsFlopFinished));
			
			turn.AddTransition(new AutomateTransition(bet, IsTurnDealt, IsBetRoundNeeded));
			turn.AddTransition(new AutomateTransition(river, IsTurnDealt));
			bet.AddTransition(new AutomateTransition(river, IsTurnFinished));
			
			river.AddTransition(new AutomateTransition(bet, IsRiverDealt, IsBetRoundNeeded));
			river.AddTransition(new AutomateTransition(winner, IsRiverDealt));
			bet.AddTransition(new AutomateTransition(winner, IsRiverFinished));
						
			winner.AddTransition(new AutomateTransition(sharePot, IsWinnerProcessed));
			
			sharePot.AddTransition(new AutomateTransition(end, IsGameFinished));
			sharePot.AddTransition(new AutomateTransition(blinds, IsPotShared));
			
			SetCurrentState(initGame);
		}
		
		//************************
		//Transitions
		//************************
		public function IsGameInitialized() : Boolean
		{
			return true;
		}
		
		public function AreBlindsPosted() : Boolean
		{
			return true;
		}
		
		public function IsPreflopDealt() : Boolean
		{
			return true;
		}
				
		public function IsPreflopFinished() : Boolean
		{
			return IsBetRoundFinished() && (GetPreviousStateId() == Preflop.ID);
		}
		
		public function IsFlopDealt() : Boolean
		{
			return true;
		}
		
		public function IsFlopFinished() : Boolean
		{
			return IsBetRoundFinished() && (GetPreviousStateId() == Flop.ID);
		}

		public function IsTurnDealt() : Boolean
		{
			return true;
		}
		
		public function IsTurnFinished() : Boolean
		{
			return IsBetRoundFinished() && (GetPreviousStateId() == Turn.ID);
		}
		
		public function IsRiverDealt() : Boolean
		{
			return true;
		}
		
		public function IsRiverFinished() : Boolean
		{
			return IsBetRoundFinished() && (GetPreviousStateId() == River.ID);
		}

		public function IsBetRoundFinished() : Boolean
		{
			return (GetNextPlayerIndex(currentPlayerIndex) == -1);
		}
	
		public function IsBetRoundNeeded() : Boolean
		{
			var inactivePlayersCount:int = foldedPlayers.length + GetLostPlayersCount() + GetAllInPlayersCount();
			
			if (inactivePlayersCount >= (players.length - 1))
			{
				return false;
			}
			
			return true;
		}
		
		public function IsOnePlayerLeft() : Boolean
		{
			return ((foldedPlayers.length + GetLostPlayersCount()) == (players.length - 1));
		}
		
		public function IsWinnerProcessed() : Boolean
		{
			return true;
		}
		
		public function IsGameFinished() : Boolean
		{
			var remainingPlayersCount:int = players.length - GetLostPlayersCount();
			return (remainingPlayersCount == 1);
		}
		
		public function IsPotShared() : Boolean
		{
			return true;
		}
	
		public function GetPlayer(_index:int) : PokerPlayer
		{
			return players[_index];
		}
	
		public function GetPlayerIndex(_pokerPlayer:PokerPlayer) : int
		{
			return players.indexOf(_pokerPlayer);
		}
		
		public function GetNextPlayerIndex(_currentIndex:int) : int
		{
			if (_currentIndex == -1)
			{
				return -1;
			}
			
			if ((GetLostPlayersCount() + foldedPlayers.length + GetAllInPlayersCount()) == (players.length - 1))
			{
				return -1;
			}
			
			var index:int = _currentIndex;
						
			do
			{			
				index = (index + 1) % PLAYERS_COUNT;
				var player:PokerPlayer = (players[index] as PokerPlayer);

				if(ShouldPlay(player))
				{
					return index;
				}
			} while (index != _currentIndex)

/*			trace("---------------------------");
			trace("Value to call : " + GetValueToCall());
			trace("-");			
			for each(var p:PokerPlayer in players)
			{
				if (HasFolded(p))
				{
					p.TraceAction("has fold");
				}
				else if (p.HasBet(GetValueToCall()))
				{
					p.TraceAction("has bet " + p.GetBetValue());
				}
				else
				{
					p.TraceAction("has bet " + p.GetBetValue() + "*");					
				}
			}
*/			
			
			return -1;
		}
	
		public function ShouldPlay(_player:PokerPlayer) : Boolean
		{
			if (!_player.HasLost())
			{
				if (!HasFolded(_player) && !_player.IsAllIn())
				{
					if (!_player.HasPlayedOnce() || !_player.HasBet(GetValueToCall()))
					{
						return true;
					}
				}
			}
			return false;
		}
		
		public function UpdateDealerPosition() : void
		{
			dealerIndex = GetNextPlayerIndex(dealerIndex);
		}
		
		public function GetDealer() : PokerPlayer
		{
			return players[dealerIndex];
			
		}
		
		public function SetCurrentPlayerAsDealer() : void
		{
			currentPlayerIndex = dealerIndex;
		}
		
		public function UpdateCurrentPlayer() : void
		{
			potTotal += GetCurrentPlayer().GetBetValue();
			if (GetNextPlayerIndex(currentPlayerIndex) == -1)
			{
				trace("invalid player index");
			}
			currentPlayerIndex = GetNextPlayerIndex(currentPlayerIndex);
		}
		
		public function GetCurrentPlayer() : PokerPlayer
		{
			return players[currentPlayerIndex];
		}
		
		public function GetDeck() : Deck
		{
			return deck;
		}
		
		public function ResetPots() : void
		{
			potTotal = 0;
			var chipsLeft:Number = 0;
			for each(var pot:PokerPot in pots)
			{
				pot.Reset();
				chipsLeft += pot.GetValue();
			}
			
			pots = new Array();
			AddPot();
			GetCurrentPot().Add(chipsLeft);
		}
		
		public function SetBlindValue(_value:Number) : void
		{
			blindValue = _value;
		}
		
		public function GetSmallBlind() : Number
		{
			return blindValue;
		}
		
		public function GetBigBlind() : Number
		{
			return blindValue * 2;
		}
	
		public function CommitPlayerBets() : void
		{
			/*for each(var testPlayer:PokerPlayer in players)
			{
				if (!testPlayer.HasLost() && !HasFolded(testPlayer))
				{
					if (testPlayer.GetBetValue() != GetValueToCall())
					{
						trace("side pot");
					}
				}
			}
			*/
			var minBet:Number = GetMinBet();
			
			while(minBet != Number.MAX_VALUE)
			{
				for each(var player:PokerPlayer in players)
				{
					if (player.GetBetValue() >= minBet)
					{
						
						GetCurrentPot().RegisterPlayer(player);
						GetCurrentPot().Add(minBet);
					
						player.SubstractBetValue(minBet);
						player.TraceAction("adds " + minBet + " to pot");
					}
					else if(HasFolded(player))
					{
						GetCurrentPot().Add(player.GetBetValue());
						player.ResetBet();
						player.TraceAction("adds " + minBet + " to pot - fold");
					}
				}
				
				minBet = GetMinBet();
				if (minBet != Number.MAX_VALUE)
				{
					AddPot();
				}
			}
			
			for each(player in players)
			{
				if (player.GetBetValue() > 0)
				{
					trace("error");
				}
			}
		}
		
		protected function GetMinBet() : Number
		{
			var minBet:Number = Number.MAX_VALUE;
			
			for each(var player:PokerPlayer in players)
			{
				if ((player.GetBetValue() > 0) && !HasFolded(player) && player.GetBetValue() < minBet)
				{
					minBet = player.GetBetValue();
				}
			}

			return minBet;
		}
		
		public function ResetPlayerActions() : void
		{
			for each(var player:PokerPlayer in players)
			{
				player.ResetAction();
				player.SetWon(false);
			}
			
		}
	
		public function ResetPlayerCards() : void
		{
			for each(var player:PokerPlayer in players)
			{
				player.ResetCards();
			}
		}

		public function GetValueToCall() : Number
		{
			if (GetCurrentStateId() == Blinds.ID)
			{
				return blindValue;
			}
	
			var maxBet:Number = 0;
			for each(var player:PokerPlayer in players)
			{
				if (player.GetBetValue() > maxBet)
				{
					maxBet = player.GetBetValue();
				}
			}
			
			//trace("Max bet : " + maxBet);
			
			return maxBet;
			
		}
			
		public function ResetBoard() : void
		{
			while (board.length > 0)
			{
				board.pop();
			}
		}
		
		public function DealBoardCard() : void
		{
			board.push(deck.GetTopCard());
		}

		public function GetBoard() : Array
		{
			return board;
		}
	
		public function ResetRanking() : void
		{
			playersRanking = null;
		}
		
		public function SetRanking(_playersRanking:Array) : void
		{
			playersRanking = _playersRanking;
		}
	
		public function GetRanking() : Array
		{
			return playersRanking;
		}
		
		public function SharePots(_ranking:Array) : void
		{
			for each(var pot:PokerPot in pots)
			{
				pot.Share(_ranking);
			}
		}
		
		public function ResetFoldedPlayers() : void
		{
			foldedPlayers = new Array();
		}
		
		public function ResetAllInPlayers() : void
		{
			for each(var player:PokerPlayer in players)
			{
				player.ResetAllIn();
			}
		}
		
		public function RegisterFoldedPlayer(_player:PokerPlayer) : void
		{
			if (foldedPlayers.indexOf(_player) == -1)
			{
				foldedPlayers.push(_player);
			}
		}
		
		public function HasFolded(_player:PokerPlayer) : Boolean
		{
			return (foldedPlayers.indexOf(_player) != -1)
		}
		
		public function GetLostPlayersCount() : int
		{
			var lostPlayersCount:int = 0;
			for each(var player:PokerPlayer in players)
			{
				if (player.HasLost())
				{
					lostPlayersCount++;
				}
			}			
			return lostPlayersCount;
		}
		
		public function GetAllInPlayersCount() : int
		{
			var allInPlayersCount:int = 0;
			for each(var player:PokerPlayer in players)
			{
				if (player.IsAllIn())
				{
					allInPlayersCount++;
				}
			}			
			return allInPlayersCount;
		}
		
		protected function AddPot() : void
		{
			pots.push(new PokerPot(this));
		}
		
		public function GetCurrentPot() : PokerPot
		{
			return pots[pots.length - 1];
		}
		
		public function GetPots() : Array
		{
			return pots;
		}
		
		public function TracePots() : void
		{
			for each(var pot:PokerPot in pots)
			{
				trace("Pot Value : " + pot.GetValue());
			}
			
		}
		
		public function GetActivePlayersCount() : int
		{
			return PokerTable.PLAYERS_COUNT - foldedPlayers.length - GetLostPlayersCount();
		}
		
		public function PerfomPlayersAction(_action:String, _param:Object) : void
		{
			for each(var player:PokerPlayer in players)
			{
				if (!player.HasLost())
				{
					player[_action](_param);
				}
			}
		}
	}

}