package com.rien 
{
	import com.novabox.poker.*;
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
																			[0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1],
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
			
			Perception(_pokerTable);
			Analyse();
			Action(_pokerTable);
			return (lastAction != PokerAction.NONE);
		}
		
		public function Perception(_pokerTable:PokerTable) : void {
			// Calcul du stack
			/*var joueursRestant:int = PokerTable.PLAYERS_COUNT - _pokerTable.GetLostPlayersCount();
			for (var i:int = 0; i < joueursRestant; i++)
			{
				trace("-> "+i+") "+_pokerTable.GetPlayer(i).GetStackValue());
			}
			*/
			// nombre de joueurs actifs dans la manche
			SetJoueursRestant(_pokerTable);
			
			// Position du joueur
			
			if (!expertSystem.GetFactBase().GetFactValue(FactBase.EVENT_PREFLOP)) {
				SetFaitValeurMain (_pokerTable);
			}
			
			expertSystem.SetFactValue(GetIntuition(), false); // rajout du booleen true par défaut
		}
		
		public function Analyse() : void {

			expertSystem.InferForward();
			var inferedFacts:Array = expertSystem.GetInferedFacts();
			//trace("Infered Facts:");
			for each(var inferedFact:Fact in inferedFacts)
			{
				//trace(inferedFact.GetLabel());
			}

			expertSystem.ResetFacts();
			expertSystem.InferBackward();
			var factsToAsk:Array = expertSystem.GetFactsToAsk();
			//trace("Facts to ask :");
			for each(var factToAsk:Fact in factsToAsk)
			{
				//trace(factToAsk.GetLabel());
			}
		}
		
		public function Action(_pokerTable:PokerTable) : void {
			// Recupere le ou les faits finaux (normalement un seul)
			var tabFaitsFinaux:Array = expertSystem.GetInferedFacts();
			var indice:int;
			
			if (tabFaitsFinaux.length == 1)
				indice = 0;
			else
				indice = Math.floor(Math.random() * tabFaitsFinaux.length);

			if (tabFaitsFinaux [indice] == FactBase.EVENT_CHECK_FOLD && this.CanCheck(_pokerTable)) 	
				Check ();
			else if (tabFaitsFinaux [indice] == FactBase.EVENT_SUIVRE) 	
				Call (_pokerTable.GetValueToCall());
			else if (tabFaitsFinaux [indice] == FactBase.EVENT_RELANCER) 	
				Raise(Math.floor(stackValue * Math.random() / 2), _pokerTable.GetValueToCall());
			else
				Fold ();
				
			
			// Voir comment trouver le pot
			//if (tabFaitsFinaux [0] == FactBase.EVENT_RELANCER) 	Raise(1000000000000, _pokerTable.GetValueToCall());
			
			// Effectue l'action en conséquence
			// Pour la relance, définir une regle pour savoir de combien on relance
		}
		
		
		public override function ProcessHandStart(_pokerTable:PokerTable) : void
		{
			
		}
		
		public override function ProcessBetRoundStart(_pokerTable:PokerTable) : void
		{
			if (!_pokerTable.HasFolded(this))
				SetPositionPlayer(_pokerTable);
		}
		
		public override function ProcessPreflopStart(_pokerTable:PokerTable) : void
		{
			if (!_pokerTable.HasFolded(this))
			{
				expertSystem.SetFactValue(FactBase.EVENT_PREFLOP, true);
				SetActionJoueurPreflop();
			
			trace (" -> probabilite preflop = " + CalculProbabilitePreflop());
			}
		}
		
		public override function ProcessFlopStart(_pokerTable:PokerTable) : void
		{
			expertSystem.SetFactValue(FactBase.EVENT_FLOP, true);
			if(!_pokerTable.HasFolded(this))
			{
				SetFaitPositionMain (_pokerTable);
				// Vérifier si il y a des cartes assorties (2 ou 3 de même couleur)
				// Vérifier si les cartes se suivent
				// Vérifier si la hauteur des cartes
				// Vérifier si il y a une paire
			}
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
		
		// Calcul mathematique de probas permettant de savoir s'il est interessant de continuer ou non
		private function SetEsperance (_pokerTable:PokerTable) : void
		{
			var tabAmeliorationPossible:Array 	= new Array ();
			tabAmeliorationPossible 			= RenvoieListeAmeliorationPossible(_pokerTable);
			var valeurMain:int 					= PokerTools.GetHandValue(RetourneValeurIntMain(_pokerTable)); 
			var nbAmelioration:int 				= 0;
			for each (var valeurAmelioration:int in tabAmeliorationPossible)
			{
				if (valeurAmelioration > valeurMain)
				{
					nbAmelioration++;
				}
			}
			var probaGain:Number = nbAmelioration / tabAmeliorationPossible.length();
			// Esperance : Proba de gagner * Pot - Proba perdre * Call
			if (((probaGain * _pokerTable.GetCurrentPot().GetValue()) - ((1 - probaGain) * _pokerTable.GetValueToCall())) > 0)
				expertSystem.SetFactValue(FactBase.ESPERANCE_POSITIVE, true);
			else
				expertSystem.SetFactValue(FactBase.ESPERANCE_NEGATIVE, true);
		}
		
		private function SetFaitPositionMain (_pokerTable:PokerTable) : void
		{
			var tabListeValeursPositionMain:Array = new Array();
			tabListeValeursPositionMain				= RenvoieListeValeursMainsPossibles(_pokerTable);
			var valeursPossibles:int				= tabListeValeursPositionMain.length;
			trace("valeur possible : " + valeursPossibles);
			var positionMain:int 			= RetournePositionMain (_pokerTable, tabListeValeursPositionMain);
			var pourcentage:Number			= (positionMain * 100) / valeursPossibles;
			trace("---------> pourcentage : " + pourcentage);
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
		
		// Recupere la valeur de notre main
		private function SetFaitValeurMain (_pokerTable:PokerTable) : void
		{
			var valeurMain:int = PokerTools.GetHandValue (RetourneValeurIntMain (_pokerTable));
			
			if (valeurMain == HandValue.HIGH_CARD) 			expertSystem.SetFactValue(FactBase.HAND_HAUTE_MAIN, 	true);
			if (valeurMain == HandValue.PAIR) 				expertSystem.SetFactValue(FactBase.HAND_PAIRE, 			true);
			if (valeurMain == HandValue.TWO_PAIRS) 			expertSystem.SetFactValue(FactBase.HAND_DOUBLE_PAIRE, 	true);
			if (valeurMain == HandValue.THREE_OF_A_KIND) 	expertSystem.SetFactValue(FactBase.HAND_BRELAN, 		true);
			if (valeurMain == HandValue.STRAIGHT) 			expertSystem.SetFactValue(FactBase.HAND_SUITE, 			true);
			if (valeurMain == HandValue.FLUSH)	 			expertSystem.SetFactValue(FactBase.HAND_COULEUR, 		true);
			if (valeurMain == HandValue.FULL_HOUSE) 		expertSystem.SetFactValue(FactBase.HAND_FULL, 			true);
			if (valeurMain == HandValue.FOUR_OF_A_KIND) 	expertSystem.SetFactValue(FactBase.HAND_CARRE, 			true);
			if (valeurMain == HandValue.STRAIGHT_FLUSH) 	expertSystem.SetFactValue(FactBase.HAND_QUINTE_FLUSH, 	true);
			//return null;
		}
		
		private function RetourneValeurIntMain (_pokerTable:PokerTable) : int
		{
			var tabCartesMain:Array		= new Array();
			var tabCartesMainBis:Array	= new Array();
			tabCartesMain 				= _pokerTable.GetBoard().slice();
			tabCartesMain.push(hand[0]);
			tabCartesMain.push(hand[1]);
			//trace("RetourneValeurIntMain : " + PokerTools.GetCardSetValue(tabCartesMain));
			return PokerTools.GetCardSetValue(tabCartesMain);
		}
		
		// Methode permettant de situer notre main par rapport a l'ensemble des mains possibles, calculé avec les cartes visibles.
		private function RetournePositionMain (_pokerTable:PokerTable, tabListeValeursPositionMain:Array) : int
		{
			var valeurMain:int			= RetourneValeurIntMain (_pokerTable);
			var position:int 			= 0;
			
			// Recupere l'ensemble des autres mains possibles, en fonction des cartes inconnues
			tabListeValeursPositionMain = RenvoieListeValeursMainsPossibles(_pokerTable);
			
			// Compare la position de notre main par rapport à toutes celles possibles et renvoie notre position
			for each(var valeurCarte:int in tabListeValeursPositionMain)
			{
				if (valeurCarte < valeurMain)
				{
					position++;
				}
			}
			return position;
		}
		
		private function RenvoieListeValeursMainsPossibles(_pokerTable:PokerTable) : Array 
		{
			var tabValeurRetour:Array 	= new Array();
			var tabCartesBoard:Array 	= new Array();
			var tabMainPossible:Array 	= new Array();
			
			tabCartesBoard 				= _pokerTable.GetBoard().slice();
			var index:int = 0;
			for (var couleur:int = 0; couleur < Suit.COUNT; couleur++)
			{
				for (var valeurCarte:int = 0; valeurCarte < Height.COUNT; valeurCarte++)
				{
					for (var couleurBis:int = 0; couleurBis < Suit.COUNT; couleurBis++)
					{
						for (var valeurCarteBis:int = 0; valeurCarteBis < Height.COUNT; valeurCarteBis++)
						{
							// Permet de ne pas avoir 2 fois les memes combinaisons (As coeur et 2 pique, puis 2 pique et As coeur)
							if (couleurBis <= couleur && valeurCarteBis < valeurCarte)
							{
								// Ne traite pas les cartes présentes dans la main ni celles du flop / river / turn
								if (!EstExclue(couleur, valeurCarte, tabCartesBoard) && !EstExclue(couleurBis, valeurCarteBis, tabCartesBoard))
								{
									index++;
									// On reinitialise la main avec le board
									tabMainPossible = tabCartesBoard.slice();
									
									// On push les 2 cartes generees
									tabMainPossible.push(new PlayingCard (couleur, valeurCarte));
									tabMainPossible.push(new PlayingCard (couleurBis, valeurCarteBis));
									
									// On recupere sa valeur en int que l'on met dans un tableau
									//trace("index : " + index);
									//trace("RenvoieListeValeursMainsPossibles : " + PokerTools.GetCardSetValue(tabMainPossible));
									tabValeurRetour.push(PokerTools.GetCardSetValue(tabMainPossible));
								}
							}
						}
					}
				}
			}
			//trace("index : " + index);
			return tabValeurRetour;
		}
		
		private function RenvoieListeAmeliorationPossible(_pokerTable:PokerTable) : Array 
		{
			var tabValeurRetour:Array 	= new Array();
			var tabCartesBoard:Array 	= new Array();
			var tabMainPossible:Array 	= new Array();
			
			tabCartesBoard 				= _pokerTable.GetBoard().slice();
			
			for (var couleur:int = 0; couleur < Suit.COUNT; couleur++)
			{
				for (var valeurCarte:int = 0; valeurCarte < Height.COUNT; valeurCarte++)
				{
					for (var couleurBis:int = 0; couleurBis < Suit.COUNT; couleurBis++)
					{
						
						// Si on est au flop
						if (tabCartesBoard.length == 3) 
						{
							for (var valeurCarteBis:int = 0; valeurCarteBis < Height.COUNT; valeurCarteBis++)
							{
								// Permet de ne pas avoir 2 fois les memes combinaisons (As coeur et 2 pique, puis 2 pique et As coeur)
								if (couleurBis <= couleur && valeurCarteBis < valeurCarte)
								{
									// Ne traite pas les cartes présentes dans la main ni celles du flop / river / turn
									if (!EstExclue(couleur, valeurCarte, tabCartesBoard) && !EstExclue(couleurBis, valeurCarteBis, tabCartesBoard))
									{
										// On reinitialise la main avec le board
										tabMainPossible = tabCartesBoard.slice();
										
										// On push les 2 cartes generees
										tabCartesBoard.push(new PlayingCard (couleur, valeurCarte));
										tabCartesBoard.push(new PlayingCard (couleurBis, valeurCarteBis));
										
										// On recupere la hauteur de la main passée que l'on met dans un tableau
										//trace("RenvoieListeAmeliorationPossible : " + PokerTools.GetCardSetValue(tabCartesBoard));
										tabValeurRetour.push(PokerTools.GetHandValue(PokerTools.GetCardSetValue(tabCartesBoard)));
									}
								}
							}
						}
						// SI on est au turn
						else if (tabCartesBoard.length == 4)
						{
							// Ne traite pas la cartes présentes dans la main ni celles du flop / river / turn
							if (!EstExclue(couleur, valeurCarte, tabCartesBoard))
							{
								// On reinitialise la main avec le board
								tabMainPossible = tabCartesBoard.slice();
								
								// On push la carte generée
								tabCartesBoard.push(new PlayingCard (couleur, valeurCarte));
								
								// On recupere la hauteur de la main passée que l'on met dans un tableau
								//trace("RenvoieListeAmeliorationPossible (else) : " + PokerTools.GetCardSetValue(tabCartesBoard));
								tabValeurRetour.push(PokerTools.GetHandValue(PokerTools.GetCardSetValue(tabCartesBoard)));
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
			}
			
			return probabilite;
		}
		
		// Random permettant de simuler une intuition, plutot positive ou négative
		private function GetIntuition () : Fact
		{
			var random:int = (Math.random() * 4) + 1;
			trace ("valeur intuition = " + random);
			switch (random)
			{
			case 1 :
				return FactBase.INTUITION_TRES_FAIBLE;
				break;
			case 2 :
				return FactBase.INTUITION_FAIBLE;
				break;
			case 3 :
				return FactBase.INTUITION_FORTE;
				break;
			default : 
				return FactBase.INTUITION_TRES_FORTE;
				break;
			}
		}
		
		private function SetActionStackJoueur (_pokerTable:PokerTable) : void
		{
			var monStack:int 			= this.GetStackValue ();
			var meilleurStack:int 		= monStack;
			var plusBasStack:int 		= monStack;
			
			var joueurActuel:PokerPlayer;
			var myIndex:int 			= 1;
			var playerIndex:int 		= _pokerTable.GetPlayerIndex(_pokerTable.GetCurrentPlayer());
			while (myIndex <= PokerTable.PLAYERS_COUNT)
			{
				joueurActuel 			= _pokerTable.GetPlayer(playerIndex);
				if (joueurActuel != this)
				{
					if (joueurActuel.GetStackValue () > meilleurStack)
						meilleurStack 	= joueurActuel.GetStackValue ();
					if (joueurActuel.GetStackValue () < plusBasStack)
						plusBasStack 	= joueurActuel.GetStackValue ();
				}
				myIndex++;
				playerIndex 			= _pokerTable.GetNextPlayerIndex(playerIndex);
			}
			if (monStack == meilleurStack)
				expertSystem.SetFactValue(FactBase.STACK_MEILLEUR, true);
			else if (monStack == plusBasStack)
				expertSystem.SetFactValue(FactBase.STACK_PLUS_BAS, true);
			else
				expertSystem.SetFactValue(FactBase.STACK_MOYEN, true);
		}
		
		private function SetActionJoueurPreflop():void
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
		
		private function SetPositionPlayer(_pokerTable:PokerTable):void 
		{
			var myIndex:int 	= 1;
			var playerIndex:int = _pokerTable.GetPlayerIndex(_pokerTable.GetCurrentPlayer());
			while (_pokerTable.GetPlayer(playerIndex) != this && myIndex <= PokerTable.PLAYERS_COUNT)
			{
				myIndex++;
				playerIndex 	= _pokerTable.GetNextPlayerIndex(playerIndex);
			}
			_pokerTable.GetActivePlayersCount();
			
			trace("I am number : " + myIndex); 

			var firstPlayer:PokerPlayer = _pokerTable.GetCurrentPlayer();
			if (firstPlayer == this)
				expertSystem.SetFactValue(FactBase.PAROLE_DEBUT, true);
			else if (this == _pokerTable.GetDealer())
				expertSystem.SetFactValue(FactBase.PAROLE_FIN, true);
			else
				expertSystem.SetFactValue(FactBase.PAROLE_MILIEU, true);
		}
		
		private function SetJoueursRestant(_pokerTable:PokerTable):void 
		{
			var joueursRestant:int = PokerTable.PLAYERS_COUNT - _pokerTable.GetLostPlayersCount();
			
			if (joueursRestant == 2)
			{
				expertSystem.SetFactValue(FactBase.JOUEURS_DEUX, true);
			}
			else if (joueursRestant == 3)
			{
				expertSystem.SetFactValue(FactBase.JOUEURS_TROIS, true);
			}
			else if (joueursRestant == 4)
			{
				expertSystem.SetFactValue(FactBase.JOUEURS_QUATRE, true);
			}
			else {
				expertSystem.SetFactValue(FactBase.JOUEURS_CINQETPLUS, true);
			}
		}
		
	}
}