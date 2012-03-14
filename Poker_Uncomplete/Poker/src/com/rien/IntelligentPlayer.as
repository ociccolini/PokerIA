package com.rien 
{
	import com.novabox.poker.PokerPlayer;
	import com.novabox.poker.PokerTable;
	import com.novabox.poker.PokerAction;
	import flash.media.Video;
	import flash.net.FileReferenceList;
	import com.rien.expertSystem.*;
	
	
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
		
		public function IntelligentPlayer(_name:String, _stackValue:Number) 
		{
			super(_name, _stackValue);
			
			expertSystem.AddRule(new Rule(FactC, new Array(FactA, FactB)));
			expertSystem.AddRule(new Rule(FactF, new Array(FactD, FactE)));
			expertSystem.AddRule(new Rule(FactE, new Array(FactG)));
		}
		
		public override function Play(_pokerTable:PokerTable) : Boolean
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
			
			perception();
			analyse();
			
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
	}
}