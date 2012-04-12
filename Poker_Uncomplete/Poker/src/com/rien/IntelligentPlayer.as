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
			
			//perception();
			analyse();
			
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
			DefinirActionJoueurPreflop();
			CalculPlayerPosition (_pokerTable);
			
			trace ("position = " + playerPosition + " - probabilité preflop = " + CalculProbabilitePreflop());
		}
		
		public override function ProcessFlopStart(_pokerTable:PokerTable) : void
		{
			expertSystem.SetFactValue(FactBase.EVENT_FLOP, true);
		}

		public override function ProcessTurnStart(_pokerTable:PokerTable) : void
		{
			expertSystem.SetFactValue(FactBase.EVENT_TURN, true);
		}

		public override function ProcessRiverStart(_pokerTable:PokerTable) : void
		{
			expertSystem.SetFactValue(FactBase.EVENT_RIVER, true);
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
		
		
		// Methode permettant de situer notre main par rapport a l'ensemble des mains possibles, calculé avec les cartes visibles.
		// Voir avec DECK qui contient toutes les cartes qui ne sont pas encore sorties (paquet de cartes);
		private function RetournePositionMain (_pokerTable:PokerTable) : int
		{
			var tabCartesConnues:Array 	= new Array();
			tabCartesConnues 			= _pokerTable.GetBoard();
			var tabValeurRetour:Array 	= new Array();
			var tabCartesDeck:Array 	= new Array();	
			
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
								tabCartesDeck = _pokerTable.GetDeck();
								// Ne traite pas les cartes présentes dans la main ni celles du flop / river / turn
								if (!EstExclue(couleur, valeurCarte, tabCartesDeck) && !EstExclue(couleurBis, valeurCarteBis, tabCartesDeck))
								{
									tabCartesDeck.push(new PlayingCard (couleur, valeurCarte));
									tabCartesDeck.push(new PlayingCard (couleurBis, valeurCarteBis));
									tabValeurRetour.push(PokerTools.GetCardSetValue(tabCartesDeck));
								}
							}
						}
					}
				}
			}
			
			
			
			if (expertSystem.GetFactBase().GetFactValue(FactBase.EVENT_RIVER))
			{
				
			}
		}
		
		private function EstExclue(couleur:int, valeurCarte:int, tabCartesDeck:Array) : Boolean
		{
			var bool:Boolean = false;
			// Compare aux cartes du flop / river / turn
			for each (var carte:PlayingCard in tabCartesDeck)
			{
				if (carte.GetSuit() == couleur && carte.GetHeight() == valeurCarte)
				{
					bool = true;
				}
			}
			// Compare aux cartes de la main
			for (var numCarte = 0; numCarte < 2; numCarte++)
			{
				if (GetCard(numCarte).GetSuit() == couleur && GetCard(numCarte).GetHeight() == valeurCarte)
				{
					bool = true;
				}
			}
			return bool;
		}
		
		public function CalculProbabilitePreflop() : int
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
		
		private function DefinirActionJoueurPreflop():void 
		{
			switch(CalculProbabilitePreflop())
			{
				case 0 :	expertSystem.SetFactValue(FactBase.JOUER_JAMAIS, true);
							break;
				case 1 :	expertSystem.SetFactValue(FactBase.JOUER_FIN, true);
							break;
				case 2 :	expertSystem.SetFactValue(FactBase.JOUER_MILIEU_OU_FIN, true);
							break;
				case 3 :	expertSystem.SetFactValue(FactBase.JOUER_TOUT_TEMPS, true);
							break;
			}
		}
	}
}