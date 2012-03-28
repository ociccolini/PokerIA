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
	}
}