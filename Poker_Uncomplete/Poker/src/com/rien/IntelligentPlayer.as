package com.rien 
{
	import com.novabox.playingCards.PlayingCard;
	import com.novabox.poker.PokerPlayer;
	import com.novabox.poker.PokerTable;
	import com.novabox.poker.PokerTools;
	import com.novabox.poker.PokerAction;
	import flash.media.Video;
	import flash.net.FileReferenceList;
	import com.rien.expertSystem.*;
	import com.novabox.playingCards.*;
	
	public class IntelligentPlayer extends PokerPlayer
	{
		private var expertSystem : ExpertSystem;
		
		public static const PLAYER_START:int	= 1;
		public static const PLAYER_MIDDLE:int	= 2;
		public static const PLAYER_END:int		= 3;
		
		private var playerPosition:int;
		
		private static const 	ToujoursJouer:int 			= 3;
		private static const 	JouerMilieuOuFinParole:int 	= 2;
		private static const 	JouerSeulementFinParole:int = 1;
		private static const 	NeJamaisJouer:int 			= 0;
		
		private var tableauProbabiliteCartesDepareillesPreflop:Array =  [
																			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																			[0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1],
																			[0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1],
																			[0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1],
																			[0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 3],
																			[0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 3],
																			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3],
																			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3]
																		];

		private var tableauProbabiliteCartesMemesCouleursPreflop:Array =  [
																		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
																		[0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
																		[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1],
																		[0, 0, 0, 2, 1, 1, 0, 0, 0, 0, 0, 1, 1],
																		[0, 0, 0, 0, 2, 1, 1, 1, 0, 0, 0, 1, 2],
																		[0, 0, 0, 0, 0, 3, 1, 1, 1, 1, 0, 1, 2],
																		[0, 0, 0, 0, 0, 0, 3, 2, 2, 2, 2, 1, 2],
																		[0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 2, 2, 2],
																		[0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3],
																		[0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3],
																		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3],
																		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3],
																		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3]
																	];
																
		
		public function IntelligentPlayer(_name:String, _stackValue:Number) 
		{
			super(_name, _stackValue);
			
			expertSystem = new ExpertSystem();
		}
		
		public override function Play(_pokerTable:PokerTable) : Boolean
		{
			/*if (CanCheck(_pokerTable))
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
			}*/
			
			trace("-> " + CalculProbabilite());
			//perception();
			//analyse();
			
			return (lastAction != PokerAction.NONE);
		}
		
		public function perception() : void {
			
		}
		
		public function analyse() : void {

			expertSystem.InferForward();
			var inferedFacts:Array = expertSystem.GetInferedFacts();
			trace("Infered Facts:");
			for each(var inferedFact:Fact in inferedFacts)
			{
				trace(inferedFact.GetLabel());
			}

			expertSystem.ResetFacts();
			expertSystem.InferBackward();
			var factsToAsk:Array = expertSystem.GetFactsToAsk();
			trace("Facts to ask :");
			for each(var factToAsk:Fact in factsToAsk)
			{
				trace(factToAsk.GetLabel());
			}
		}
		
		public function action() : void {
			
		}
		
		
		
		public override function ProcessHandStart(_pokerTable:PokerTable) : void
		{
			
		}
		
		public override function ProcessBetRoundStart(_pokerTable:PokerTable) : void
		{
			
		}
		
		public override function ProcessPreflopStart(_pokerTable:PokerTable) : void
		{
			expertSystem.SetFactValue(FactBase.EVENT_PREFLOP, true);
			CalculPlayerPosition (_pokerTable);
			trace ("position = " + playerPosition);
		}
		
		public override function ProcessFlopStart(_pokerTable:PokerTable) : void
		{
			expertSystem.SetFactValue(FactBase.EVENT_FLOP, true);
			SetFaitPositionMain (_pokerTable);
		}

		public override function ProcessTurnStart(_pokerTable:PokerTable) : void
		{
			expertSystem.SetFactValue(FactBase.EVENT_TURN, true);
		}

		public override function ProcessRiverStart(_pokerTable:PokerTable) : void
		{
			expertSystem.SetFactValue(FactBase.EVENT_RIVER, true);
			SetFaitPositionMain (_pokerTable);
		}

		public override function ProcessHandEnd(_pokerTable:PokerTable) : void
		{

		}
		
		public override function ProcessPlayerAction(_player:PokerPlayer) : void
		{
			// ici on peut analyser le jeu du joueur passé en parametre
		}
		
		public override function ProcessPlayerShowdown(_player:PokerPlayer) : void
		{

		}
		
		public override function ProcessPlayerWon(_player:PokerPlayer) : void
		{
			
		}
		
		private function AvoirUnePaire(premiereCarte:PlayingCard, deuxiemeCarte:PlayingCard):Boolean 
		{
			return premiereCarte.GetHeight() == deuxiemeCarte.GetHeight();
		}
		
		private function CartesDeMemeCouleur(premiereCarte:PlayingCard, deuxiemeCarte:PlayingCard):Boolean 
		{
			return premiereCarte.GetSuit() == deuxiemeCarte.GetSuit();
		}
		
		private function GetMax(premiereCarte:PlayingCard, deuxiemeCarte:PlayingCard):int 
		{
			return (premiereCarte.GetHeight() > deuxiemeCarte.GetHeight())?premiereCarte.GetHeight():deuxiemeCarte.GetHeight();
		}
		
		private function GetMin(premiereCarte:PlayingCard, deuxiemeCarte:PlayingCard):int 
		{
			return (premiereCarte.GetHeight() > deuxiemeCarte.GetHeight())?deuxiemeCarte.GetHeight():premiereCarte.GetHeight();
		}
		
		// METHODES AJOUTEES
		
		private function SetFaitPositionMain (_pokerTable:PokerTable) : void
		{
			var valeursPossibles:int 		= RenvoieListeValeursMainsPossibles().length();
			var positionMain:int 			= RetournePositionMain (_pokerTable);
			var pourcentage:Number			= (positionMain * 100) / valeursPossibles;
			if (pourcentage < 25)
			{
				expertSystem.SetFactValue(FactBase.PARTIE_TRES_BASSE, true);
			}
			else if (pourcentage < 50)
			{
				expertSystem.SetFactValue(FactBase.PARTIE_BASSE, true);
			}
			else if (pourcentage < 75)
			{
				expertSystem.SetFactValue(FactBase.PARTIE_HAUTE, true);
			}
			else
			{
				expertSystem.SetFactValue(FactBase.PARTIE_TRES_HAUTE, true);
			}
			
			
		}
		
		// Methode permettant de situer notre main par rapport a l'ensemble des mains possibles, calculé avec les cartes visibles.
		private function RetournePositionMain (_pokerTable:PokerTable) : int
		{
			var tabCartesMain:Array		= new Array();
			var tabValeurRetour:Array;
			var valeurMain:int			= 0;
			var position:int 			= 0;
			
			// Recupere la valeur de notre main
			tabCartesMain 				= _pokerTable.GetBoard();
			tabCartesMain.push(hand[0]);
			tabCartesMain.push(hand[1]);
			valeurMain					= PokerTools.GetCardSetValue(tabCartesMain)
			
			// Recupere l'ensemble des autres mains possibles, en fonction des cartes inconnues
			tabValeurRetour 			= RenvoieListeValeursMainsPossibles();
			
			// Compare la position de notre main par rapport à toutes celles possibles et renvoie notre position
			for each(var valeurCarte:int in tabValeurRetour)
			{
				if (valeurCarte < valeurMain)
				{
					position++;
				}
			}
			return position;
		}
		
		private function RenvoieListeValeursMainsPossibles() : Array 
		{
			var tabValeurRetour:Array 	= new Array();
			var tabCartesBoard:Array 	= new Array();
			
			for (var couleur = 0; couleur < Suit.COUNT; couleur++)
			{
				for (var valeurCarte = 0; valeurCarte < Height.COUNT; valeurCarte++)
				{
					for (var couleurBis = 0; couleurBis < Suit.COUNT; couleurBis++)
					{
						for (var valeurCarteBis = 0; valeurCarteBis < Height.COUNT; valeurCarteBis++)
						{
							// Permet de ne pas avoir 2 fois les memes combinaisons (As coeur et 2 pique, puis 2 pique et As coeur)
							if (couleurBis <= couleur && valeurCarteBis < valeurCarte)
							{
								tabCartesBoard = _pokerTable.GetBoard();
								// Ne traite pas les cartes présentes dans la main ni celles du flop / river / turn
								if (!EstExclue(couleur, valeurCarte, tabCartesDeck) && !EstExclue(couleurBis, valeurCarteBis, tabCartesDeck))
								{
									tabCartesBoard.push(new PlayingCard (couleur, valeurCarte));
									tabCartesBoard.push(new PlayingCard (couleurBis, valeurCarteBis));
									tabValeurRetour.push(PokerTools.GetCardSetValue(tabCartesBoard));
								}
							}
						}
					}
				}
			}
			return tabValeurRetour;
		}
		
		private function EstExclue(couleur:int, valeurCarte:int, tabCartesBoard:Array) : Boolean
		{
			var bool:Boolean = false;
			// Compare aux cartes du flop / river / turn
			for each (var carte:PlayingCard in tabCartesBoard)
			{
				if (carte.GetSuit() == couleur && carte.GetHeight() == valeurCarte)
				{
					bool = true;
				}
			}
			// Compare aux cartes de la main
			if (	(hand[0].GetSuit() == couleur && hand[0].GetHeight() == valeurCarte)
				|| 	(hand[1].GetSuit() == couleur && hand[1].GetHeight() == valeurCarte))
			{
				bool = true;
			}
			
			return bool;
		}
		
		public function CalculProbabilite() : int
		{
			var premiereCarte:PlayingCard = hand[0];
			var deuxiemeCarte:PlayingCard = hand[1];
			var probabilite:int;
			
			if ( AvoirUnePaire(premiereCarte, deuxiemeCarte) || CartesDeMemeCouleur(premiereCarte, deuxiemeCarte) )
			{
				probabilite = tableauProbabiliteCartesMemesCouleursPreflop[GetMin(premiereCarte, deuxiemeCarte)][GetMax(premiereCarte, deuxiemeCarte)];
			}
			else 
			{
				probabilite = tableauProbabiliteCartesDepareillesPreflop[GetMin(premiereCarte, deuxiemeCarte)][GetMax(premiereCarte, deuxiemeCarte) - 1];
				trace("ligne:" + GetMin(premiereCarte, deuxiemeCarte));
				trace("colonne:" + (GetMax(premiereCarte, deuxiemeCarte)-1));
			}
			
			return probabilite;
		}
		
		private function GetIntuition () : String
		{
			var random:int = (Math.random() * 4) + 1;
			trace ("valeur intuition = " + random);
			switch (random)
			{
				case 1 :
					return "Intuition tres faible";
					break;
				case 2 :
					return "Intuition faible";
					break;
				case 3 :
					return "Intuition forte";
					break;
				default : 
					return "Intuition tres forte"
					break;
			}
		}
		
		private function CalculPlayerPosition (_pokerTable:PokerTable) : void {
			var lastPlayerToTalkIndex:int 	= (_pokerTable.GetPlayerIndex(_pokerTable.GetDealer()) + 2) % _pokerTable.PLAYERS_COUNT;
			var firstPlayerToTalkIndex:int 	= _pokerTable.GetPlayerIndex(_pokerTable.GetDealer());
			
			if (_pokerTable.GetPlayerIndex(this) == lastPlayerToTalkIndex) {
				playerPosition = PLAYER_END;
			}
			else if (_pokerTable.GetPlayerIndex(this) == lastPlayerToTalkIndex) 
				playerPosition = PLAYER_START;
			else
				playerPosition = PLAYER_MIDDLE;
		}
	}
}