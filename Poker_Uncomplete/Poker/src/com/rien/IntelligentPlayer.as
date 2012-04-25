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
			
			perception(_pokerTable);
			analyse();
			action(_pokerTable);
			return (lastAction != PokerAction.NONE);
		}
		
		public function perception(_pokerTable:PokerTable) : void {
			// Calcul du pot
			// nombre de joueurs actifs dans la manche
			// Position du joueur
			SetFaitValeurMain (_pokerTable);
			expertSystem.SetFactValue(GetIntuition(), false); // rajout du booleen true par défautl
		}
		
		public function analyse() : void {

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
		
		public function action(_pokerTable:PokerTable) : void {
			// Recupere le ou les faits finaux (normalement un seul)
			var tabFaitsFinaux:Array = expertSystem.GetFinalFacts();
			if (tabFaitsFinaux [0] == FactBase.EVENT_COUCHER) 	Fold ();
			if (tabFaitsFinaux [0] == FactBase.EVENT_CHECK) 	Check ();
			if (tabFaitsFinaux [0] == FactBase.EVENT_SUIVRE) 	Call (_pokerTable.GetValueToCall());
			// Voir que relancer
			if (tabFaitsFinaux [0] == FactBase.EVENT_RELANCER) 	Raise(Math.floor(stackValue * Math.random() / 2), _pokerTable.GetValueToCall());
			// Voir comment trouver le pot
			if (tabFaitsFinaux [0] == FactBase.EVENT_RELANCER) 	Raise(1000000000000, _pokerTable.GetValueToCall());
			
			// Effectue l'action en conséquence
			// Pour la relance, définir une regle pour savoir de combien on relance
		}
		
		
		
		public override function ProcessHandStart(_pokerTable:PokerTable) : void
		{
			
		}
		
		public function ProcessBetRoundStart(_pokerTable:PokerTable) : void
		{
			SetPositionPlayer(_pokerTable);
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
			var valeursPossibles:int 		= RenvoieListeValeursMainsPossibles(_pokerTable).length;
			trace("valeur possible : " + valeursPossibles);
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
			var tabCartesMainBis:Array		= new Array();
			tabCartesMain 				= _pokerTable.GetBoard();
			for each(var c:PlayingCard in tabCartesMain) {
				tabCartesMainBis.push(c);
			}
			tabCartesMainBis.push(hand[0]);
			tabCartesMainBis.push(hand[1]);
			return PokerTools.GetCardSetValue(tabCartesMainBis);
		}
		
		// Methode permettant de situer notre main par rapport a l'ensemble des mains possibles, calculé avec les cartes visibles.
		private function RetournePositionMain (_pokerTable:PokerTable) : int
		{
			var tabValeurRetour:Array;
			var valeurMain:int			= RetourneValeurIntMain (_pokerTable);
			var position:int 			= 0;
			
			// Recupere l'ensemble des autres mains possibles, en fonction des cartes inconnues
			tabValeurRetour 			= RenvoieListeValeursMainsPossibles(_pokerTable);
			
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
		
		private function RenvoieListeValeursMainsPossibles(_pokerTable:PokerTable) : Array 
		{
			var tabValeurRetour:Array 	= new Array();
			var tabCartesBoard:Array 	= new Array();
			var tabCartesBoardBis:Array 	= new Array();
			
			tabCartesBoard = _pokerTable.GetBoard(); // tabCartesBoard est un pointeur vers la table ... 
			for each(var c:PlayingCard in tabCartesBoard) {
				tabCartesBoardBis.push(c);
			}
			
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
								// Ne traite pas les cartes présentes dans la main ni celles du flop / river / turn
								if (!EstExclue(couleur, valeurCarte, tabCartesBoard) && !EstExclue(couleurBis, valeurCarteBis, tabCartesBoard))
								{
									tabCartesBoardBis.push(new PlayingCard (couleur, valeurCarte));
									tabCartesBoardBis.push(new PlayingCard (couleurBis, valeurCarteBis));
									tabValeurRetour.push(PokerTools.GetCardSetValue(tabCartesBoardBis));
									
									// Pour les test, evite de perdre un temps fou à instancier 1500 cartes, 
									// Vivien il faut valider que tu veux bien autant de carte si oui dans ce cas là
									// quand tu test le resultat il ne faut passer que 5 ou 7 cartes à la methode GetCardSetValue 
									// (appelé par la méthode qui reçoit le resultat renvoyé ci-dessous).
									if (tabValeurRetour.length > 7) {
										return tabValeurRetour;
									}
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
		
		private function CalculPlayerPosition (_pokerTable:PokerTable) : void {
			//var lastPlayerToTalkIndex:int 	= (_pokerTable.GetPlayerIndex(_pokerTable.GetDealer()) + 2) % _pokerTable.PLAYERS_COUNT;
			/*var firstPlayerToTalkIndex:int 	= _pokerTable.GetPlayerIndex(_pokerTable.GetDealer());
			
			if (_pokerTable.GetPlayerIndex(this) == lastPlayerToTalkIndex) {
				playerPosition = PLAYER_END;
			}
			else if (_pokerTable.GetPlayerIndex(this) == lastPlayerToTalkIndex) 
				playerPosition = PLAYER_START;
			else
				playerPosition = PLAYER_MIDDLE;*/
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
		
		private function SetPositionPlayer(_pokerTable:PokerTable):void 
		{
			var myIndex:int 	= 1;
			var playerIndex:int = _pokerTable.GetPlayerIndex(_pokerTable.GetCurrentPlayer());
			while (_pokerTable.GetPlayer(playerIndex) != this)
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
	}
}