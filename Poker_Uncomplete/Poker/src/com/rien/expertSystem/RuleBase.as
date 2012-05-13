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
			
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD,	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_JAMAIS))); // ajout si besoin de relancer ou suivre
						
			// Trouver fait differenciant le suivre du relancer (aggressivité, random ?, ...)
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_MILIEU)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_FIN)));
			//AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_DEBUT)));
			//AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_FIN, FactBase.PAROLE_DEBUT)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_DEBUT, FactBase.MISE_EGALE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_DEBUT, FactBase.MISE_DOUBLE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_DEBUT, FactBase.MISE_GROSSE_RELANCE)));
			
			AddRule(new Rule (FactBase.EVENT_RELANCER, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_FIN)));
			
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_FIN, FactBase.PAROLE_DEBUT, FactBase.MISE_EGALE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_FIN, FactBase.PAROLE_MILIEU)));
			
			// Trouver fait differenciant le suivre du relancer (aggressivité, random ?, ...)
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_FIN, FactBase.PAROLE_FIN)));
			//AddRule(new Rule (FactBase.EVENT_RELANCER, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_FIN, FactBase.PAROLE_FIN, FactBase.INTUITION_TRES_FORTE)));
			
			AddRule(new Rule (FactBase.EVENT_RELANCER, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_TOUT_TEMPS)));
			
			// Changement de stratégie préflop pour le duel
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUEURS_DEUX, FactBase.JOUER_FIN)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUEURS_DEUX, FactBase.JOUER_MILIEU_OU_FIN)));
			
			// ****************** FLOP ****************
			
			// Check / Fold
			// Check / Call
			// Call / Raise
			// All in
			
			
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_BASSE)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_BASSE)));
			//AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_HAUTE)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_HAUTE, FactBase.MISE_EGALE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_HAUTE, FactBase.MISE_DOUBLE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD,	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_HAUTE, FactBase.MISE_GROSSE_RELANCE)));
			AddRule(new Rule (FactBase.EVENT_RELANCER, 		new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_HAUTE)));
			
			// ****************** Turn ****************
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_TURN, FactBase.PARTIE_TRES_BASSE)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_TURN, FactBase.PARTIE_BASSE)));
			//AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_TURN, FactBase.PARTIE_HAUTE)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_TURN, FactBase.PARTIE_HAUTE, FactBase.MISE_EGALE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_TURN, FactBase.PARTIE_HAUTE, FactBase.MISE_DOUBLE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD,	new Array(FactBase.EVENT_TURN, FactBase.PARTIE_HAUTE, FactBase.MISE_GROSSE_RELANCE)));
			AddRule(new Rule (FactBase.EVENT_RELANCER, 		new Array(FactBase.EVENT_TURN, FactBase.PARTIE_TRES_HAUTE)));
			
			// ****************** River ****************
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_RIVER, FactBase.PARTIE_TRES_BASSE)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_RIVER, FactBase.PARTIE_BASSE)));
			//AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_RIVER, FactBase.PARTIE_HAUTE)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_RIVER, FactBase.PARTIE_HAUTE, FactBase.MISE_EGALE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_RIVER, FactBase.PARTIE_HAUTE, FactBase.MISE_DOUBLE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD,	new Array(FactBase.EVENT_RIVER, FactBase.PARTIE_HAUTE, FactBase.MISE_GROSSE_RELANCE)));
			AddRule(new Rule (FactBase.EVENT_RELANCER, 		new Array(FactBase.EVENT_RIVER, FactBase.PARTIE_TRES_HAUTE)));

			
			
			
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