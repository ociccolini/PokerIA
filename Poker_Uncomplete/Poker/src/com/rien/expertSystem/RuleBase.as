package com.rien.expertSystem 
{
	public class RuleBase
	{
		private var rules:Array;
		
		public function RuleBase() 
		{
			rules = new Array();
			
			// ******************************************* BASE DE REGLES *****************************************
			
			
			// ****************** PREFLOP ****************
			
			AddRule(new Rule (FactBase.EVENT_COUCHER, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_JAMAIS))); // ajout si besoin de relancer ou suivre
			AddRule(new Rule (FactBase.EVENT_CHECK, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_JAMAIS))); // ajout si besoin de relancer ou suivre
			
			// Trouver fait differenciant le suivre du relancer (aggressivité, random ?, ...)
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_MILIEU)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_FIN)));
			AddRule(new Rule (FactBase.EVENT_CHECK, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_MILIEU)));
			AddRule(new Rule (FactBase.EVENT_RELANCER, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_FIN)));
			
			// Trouver fait differenciant le suivre du relancer (aggressivité, random ?, ...)
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_FIN, FactBase.PAROLE_FIN)));
			AddRule(new Rule (FactBase.EVENT_RELANCER, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_FIN, FactBase.PAROLE_FIN)));
			
			AddRule(new Rule (FactBase.EVENT_RELANCER, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_TOUT_TEMPS)));
			
			// ****************** FLOP ****************
			
			// Check / Fold
			AddRule(new Rule (FactBase.EVENT_COUCHER, 	new Array(FactBase.EVENT_FLOP, FactBase.JOUER_FIN, FactBase.PAROLE_FIN)));
			
			// Check / Call
			// Call / Raise
			// All in
			AddRule(new Rule (FactBase.EVENT_COUCHER, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_BASSE)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_HAUTE)));
			AddRule(new Rule (FactBase.EVENT_RELANCER, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_HAUTE)));
			
			
			// ****************** Turn ****************
			
			
			
			// ****************** River ****************
			
			
			
			
			
			
			// ******************************************* FIN BASE DE REGLES *****************************************
		}
		
		public function AddRule(_rule:Rule) : void
		{
			rules.push(_rule);
		}
		
		public function GetRules() : Array
		{
			return rules;
		}
		
	}

}