package com.rien 
{
	import com.novabox.playingCards.PlayingCard;
	import com.novabox.poker.PokerPlayer;
	import com.novabox.poker.PokerTable;
	import com.novabox.poker.PokerAction;
	import flash.media.Video;
	import flash.net.FileReferenceList;
	import com.rien.expertSystem.*;
	import com.novabox.playingCards.Suit;
	
	public class IntelligentPlayer extends PokerPlayer
	{
		private var expertSystem : ExpertSystem = new ExpertSystem();
		
		public static const PLAYER_START:int	= 1;
		public static const PLAYER_MIDDLE:int	= 2;
		public static const PLAYER_END:int		= 3;
		
		private var playerPosition:int;
		
		public static const FactA:Fact = new Fact("A");
		public static const FactB:Fact = new Fact("B");
		public static const FactC:Fact = new Fact("C");
		public static const FactD:Fact = new Fact("D");
		public static const FactE:Fact = new Fact("E");
		public static const FactF:Fact = new Fact("F");
		public static const FactG:Fact = new Fact("G");
		
		
		private static const 	ToujoursJouer:int = 3;
		private static const 	JouerMilieuOuFinParole:int = 2;
		private static const 	JouerSeulementFinParole:int = 1;
		private static const 	NeJamaisJouer:int = 0;
		
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
			
			expertSystem.AddRule(new Rule(FactC, new Array(FactA, FactB)));
			expertSystem.AddRule(new Rule(FactF, new Array(FactD, FactE)));
			expertSystem.AddRule(new Rule(FactE, new Array(FactG)));
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
			// Remplir base de fait
			expertSystem.SetFactValue(FactA, true);
			expertSystem.SetFactValue(FactB, true);
			expertSystem.SetFactValue(FactD, true);
			expertSystem.SetFactValue(FactG, true);
		}
		
		public function analyse() : void {
			var listeTab : Array = new Array();
			listeTab["j1"] = new Array("int tour", "etatJeu (flop, turn, ...)", "pot", "stack", "action (suivre, relance, ...)", "joueurs actifs");
			//listeTab["j1"][2] = new Array("int tour", "etatJeu (flop, turn, ...)", "pot", "stack", "action (suivre, relance, ...)", "joueurs actifs");
			listeTab["j2"] = new Array("int tour", "etatJeu (flop, turn, ...)", "pot", "stack", "action (suivre, relance, ...)", "joueurs actifs");
			listeTab["j3"] = new Array("int tour", "etatJeu (flop, turn, ...)", "pot", "stack", "action (suivre, relance, ...)", "joueurs actifs");
			listeTab["j4"] = new Array("int tour", "etatJeu (flop, turn, ...)", "pot", "stack", "action (suivre, relance, ...)", "joueurs actifs");
			
			
			// ******************************************* BASE DE FAITS *****************************************
			
			// Evenement de la manche
			expertSystem.GetFactBase().AddFact (new Fact ("Preflop"));
			expertSystem.GetFactBase().AddFact (new Fact ("Flop"));
			expertSystem.GetFactBase().AddFact (new Fact ("Turn"));
			expertSystem.GetFactBase().AddFact (new Fact ("River"));
			
			// Pot du joueur
			expertSystem.GetFactBase().AddFact (new Fact ("Pot Haut"));
			expertSystem.GetFactBase().AddFact (new Fact ("Pot Moyen"));
			expertSystem.GetFactBase().AddFact (new Fact ("Pot Bas"));
			
			// Nombre de joueurs actifs sur la manche
			expertSystem.GetFactBase().AddFact (new Fact ("Deux joueurs"));
			expertSystem.GetFactBase().AddFact (new Fact ("Trois joueurs"));
			expertSystem.GetFactBase().AddFact (new Fact ("Quatre joueurs"));
			
			// Valeurs calculées pour le preflop
			expertSystem.GetFactBase().AddFact (new Fact ("Jouer toute position"));
			expertSystem.GetFactBase().AddFact (new Fact ("Jouer milieu ou fin parole"));
			expertSystem.GetFactBase().AddFact (new Fact ("Jouer fin de parole seulement"));
			expertSystem.GetFactBase().AddFact (new Fact ("Ne pas jouer"));
			
			// Position du joueur
			expertSystem.GetFactBase().AddFact (new Fact ("Debut de parole"));
			expertSystem.GetFactBase().AddFact (new Fact ("Milieu de parole"));
			expertSystem.GetFactBase().AddFact (new Fact ("Fin de parole"));
			
			// Action du joueur
			expertSystem.GetFactBase().AddFact (new Fact ("Se coucher"));
			expertSystem.GetFactBase().AddFact (new Fact ("Checker"));
			expertSystem.GetFactBase().AddFact (new Fact ("Suivre"));
			expertSystem.GetFactBase().AddFact (new Fact ("Relancer"));
			
			//Valeur maximum de la main
			expertSystem.GetFactBase().AddFact (new Fact ("Haute carte"));
			expertSystem.GetFactBase().AddFact (new Fact ("Paire"));
			expertSystem.GetFactBase().AddFact (new Fact ("Double paire"));
			expertSystem.GetFactBase().AddFact (new Fact ("Brelan"));
			expertSystem.GetFactBase().AddFact (new Fact ("Suite"));
			expertSystem.GetFactBase().AddFact (new Fact ("Couleur"));
			expertSystem.GetFactBase().AddFact (new Fact ("Full"));
			expertSystem.GetFactBase().AddFact (new Fact ("Carre"));
			expertSystem.GetFactBase().AddFact (new Fact ("Quinte flush"));
			
			// Position de la main vis a vis des possibilités générales
			expertSystem.GetFactBase().AddFact (new Fact ("Partie Plus Haute"));
			expertSystem.GetFactBase().AddFact (new Fact ("Partie Haute"));
			expertSystem.GetFactBase().AddFact (new Fact ("Partie Basse"));
			expertSystem.GetFactBase().AddFact (new Fact ("Partie Plus Basse"));
			
			
			// ******************************************* BASE DE REGLES *****************************************
			
			
			// ****************** PREFLOP ****************
			
			expertSystem.GetRuleBase().AddRule(new Rule ("Se coucher", 	new Array("Preflop", "Ne pas jouer"))); // ajout si besoin de relancer ou suivre
			expertSystem.GetRuleBase().AddRule(new Rule ("Checker", 	new Array("Preflop", "Ne pas jouer"))); // ajout si besoin de relancer ou suivre
			
			// Trouver fait differenciant le suivre du relancer (aggressivité, random ?, ...)
			expertSystem.GetRuleBase().AddRule(new Rule ("Suivre", 		new Array("Preflop", "Jouer milieu ou fin parole", "Milieu de parole")));
			expertSystem.GetRuleBase().AddRule(new Rule ("Suivre", 		new Array("Preflop", "Jouer milieu ou fin parole", "Fin de parole")));
			expertSystem.GetRuleBase().AddRule(new Rule ("Relancer", 	new Array("Preflop", "Jouer milieu ou fin parole", "Milieu de parole")));
			expertSystem.GetRuleBase().AddRule(new Rule ("Relancer", 	new Array("Preflop", "Jouer milieu ou fin parole", "Fin de parole")));
			
			// Trouver fait differenciant le suivre du relancer (aggressivité, random ?, ...)
			expertSystem.GetRuleBase().AddRule(new Rule ("Suivre", 		new Array("Preflop", "Jouer fin de parole seulement", "Fin de parole")));
			expertSystem.GetRuleBase().AddRule(new Rule ("Relancer", 	new Array("Preflop", "Jouer fin de parole seulement", "Fin de parole")));
			
			
			// ****************** FLOP ****************
			
			
			
			
			
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
			CalculPlayerPosition (_pokerTable);
			trace ("position = " + playerPosition);
		}
		
		public override function ProcessFlopStart(_pokerTable:PokerTable) : void
		{
			
		}

		public override function ProcessTurnStart(_pokerTable:PokerTable) : void
		{
			
		}

		public override function ProcessRiverStart(_pokerTable:PokerTable) : void
		{
			
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