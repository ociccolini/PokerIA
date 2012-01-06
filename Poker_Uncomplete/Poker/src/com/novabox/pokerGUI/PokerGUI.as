package com.novabox.pokerGUI 
{
	import com.novabox.playingCards.PlayingCard;
	import com.novabox.poker.PokerPlayer;
	import com.novabox.poker.PokerPot;
	import com.novabox.poker.PokerTable;
	import com.novabox.poker.states.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Ophir
	 */
	public class PokerGUI extends Sprite
	{
		public static const TABLE_RADIUS:Number = 280;
		public static const TABLE_CENTER:Point = new Point(512, 384);
		
		protected var pokerTable:PokerTable;
		
		protected var playerBoxes:Array;
		protected var playerBets:Array;

		protected var boardSprite:Sprite;
		protected var pot:TextField;
		
		protected var pauseButton:TextField;
		
		public function PokerGUI() 
		{
		}
		
		public function Initialize(_pokerTable:PokerTable) : void
		{
			pokerTable = _pokerTable;
			playerBoxes = new Array();
			
			boardSprite = new Sprite();
			pot = new TextField();
			
			InitPauseButton();
			
			InitPlayerSprites();
			InitBoardAndPot();	
		}
		
		protected function InitPauseButton() : void
		{
			pauseButton = new TextField();
			pauseButton.autoSize = TextFieldAutoSize.CENTER;
			pauseButton.background = true;
			pauseButton.backgroundColor = 0XFF0000;
			pauseButton.text = "Pause";
			pauseButton.selectable = false;
			pauseButton.addEventListener(MouseEvent.CLICK, OnPauseClick);
			
			addChild(pauseButton);
			pauseButton.x = 970;
			pauseButton.y = 10;
		}
	
		protected function OnPauseClick(_e:Event) : void
		{
			Main.paused = !Main.paused;
			if (Main.paused)
			{
				pauseButton.backgroundColor = 0X00FF00;
				pauseButton.text = "Play";				
			}
			else
			{
				pauseButton.backgroundColor = 0XFF0000;
				pauseButton.text = "Pause";
			}
		}
		
		public function Update() : void
		{
			UpdatePlayers();
			switch(pokerTable.GetCurrentStateId())
			{
				case Preflop.ID:
				ShowPlayersCards();
				ShowBoardCards();
				break;
				
				case Flop.ID:
				case Turn.ID:
				case River.ID:
				ShowBoardCards();
				break;
				
				case SharePot.ID:
				case Bet.ID:
				break;
				
				break;
			}
			
		}
		
		public function InitPlayerSprites() : void
		{
			playerBets = new Array();
			
			var angle:Number = -Math.PI / PokerTable.PLAYERS_COUNT * 2 ;
			for (var i:int = 0; i < PokerTable.PLAYERS_COUNT; i++)
			{
				var player:PokerPlayer =  pokerTable.GetPlayer(i);
				
				var target:Point = new Point();
				
				target.x = TABLE_RADIUS   * 1.4 * Math.sin(angle * i);
				target.y = TABLE_RADIUS * Math.cos(angle * i);
				
					
				var playerBox:PlayerBox = new PokerPlayerGUI(player);

				
				var spritePosition:Point = target.add(TABLE_CENTER);

				playerBox.x = spritePosition.x
				playerBox.y =spritePosition.y
				
				playerBox.x -= playerBox.width / 2;
				playerBox.y -= playerBox.height / 2;

	
				//Name
				playerBox.playerName.text = player.GetName();
				
				//Bet
				var playerBet:TextField = new TextField();
				playerBets[i] = playerBet;
				
				playerBet.autoSize = TextFieldAutoSize.LEFT;
				
				var betPosition:Point = new Point(	TABLE_CENTER.x + target.x * 0.6,
													TABLE_CENTER.y + target.y * 0.6);
				
				playerBet.x = betPosition.x;
				playerBet.y =  betPosition.y;
				addChild(playerBet);
					
				playerBoxes[i] = playerBox;
				
				addChild(playerBox);
			}
		}
		
		public function ShowPlayersCards() : void
		{
			
			for (var i:int = 0; i < PokerTable.PLAYERS_COUNT; i++)
			{
				var playerBox:PokerPlayerGUI = playerBoxes[i];
							
				var player:PokerPlayer = pokerTable.GetPlayer(i);
			
				var card1:PlayingCard = player.GetCard(0);
				var card2:PlayingCard = player.GetCard(1);
				
				playerBox.ClearCards();
				playerBox.SetCards(card1, card2);
			}
		}
		
		public function InitBoardAndPot() : void
		{
			addChild(boardSprite);
			boardSprite.x = TABLE_CENTER.x - (PlayingCard.CARD_WIDTH * 5 / 2);
			boardSprite.y = TABLE_CENTER.y - (PlayingCard.CARD_HEIGHT / 2);
			
			addChild(pot);
			pot.autoSize = TextFieldAutoSize.LEFT;
			pot.x = TABLE_CENTER.x - pot.textWidth / 2;
			pot.y = TABLE_CENTER.y + PlayingCard.CARD_HEIGHT/2 + pot.textHeight;
		}
		
		public function ShowBoardCards() : void
		{
			while (boardSprite.numChildren > 0)
			{
				boardSprite.removeChildAt(0);
			}
			
			var boardCards:Array = pokerTable.GetBoard();
			
			for (var i:int = 0; i < boardCards.length; i++)
			{
				var boardCard:PlayingCard = boardCards[i];
				
				boardSprite.addChild(boardCard);
				boardCard.x = PlayingCard.CARD_WIDTH * i;
				boardCard.y = 0;
			}
		}
		
		public function UpdatePlayers() : void
		{
			for (var i:int = 0; i < PokerTable.PLAYERS_COUNT; i++)
			{
				
				var player:PokerPlayer = pokerTable.GetPlayer(i);

				if (player.GetName() == "human")
				{
					trace("human");
				}
				var playerBox:PokerPlayerGUI = playerBoxes[i];
				
				playerBox.Update();
				
				playerBox.SetHighlighted(pokerTable.GetCurrentPlayer() == player);
				playerBox.SetDealer(pokerTable.GetDealer() == player);
				playerBox.SetHasFold(pokerTable.HasFolded(player));
				playerBox.SetHasLost(player.HasLost());
				playerBox.SetHasWon(player.HasWon());
				
				var playerBet:TextField = playerBets[i];
				playerBet.text = "";
				if (player.GetBetValue() > 0)
				{
					playerBet.text = player.GetBetValue().toString();
				}
				/*if (pokerTable.HasFolded(player))
				{
					playerBet.text = "Fold";
				}*/
								
			}
			
			pot.text = "";
			
			var potString:String = "";
			
			for each(var pokerPot:PokerPot in pokerTable.GetPots())
			{
				if (pokerPot.GetValue() > 0)
				{
					if (potString != "")
					{
						potString += "- ";
					}
					
					potString = pokerPot.GetValue().toString();
				}
			}
			pot.text = potString;
			pot.x = TABLE_CENTER.x - pot.textWidth / 2;
		}
	}

}