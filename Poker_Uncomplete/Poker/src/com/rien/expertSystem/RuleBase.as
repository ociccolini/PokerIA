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
			
			// Se couche si : 	
			//					- les cartes ne sont jamais à jouer
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_JAMAIS, FactBase.MISE_DOUBLE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_JAMAIS, FactBase.MISE_GROSSE_RELANCE)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_JAMAIS, FactBase.MISE_EGALE_BIGBLIND, FactBase.INTUITION_FORTE)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_JAMAIS, FactBase.MISE_EGALE_BIGBLIND, FactBase.INTUITION_FAIBLE)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_JAMAIS, FactBase.MISE_EGALE_BIGBLIND, FactBase.INTUITION_TRES_FAIBLE)));
			//					- les cartes sont a jouer seulement en fin de parole, et que le joueur est premier de parole
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_FIN, FactBase.PAROLE_DEBUT, FactBase.MISE_DOUBLE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_FIN, FactBase.PAROLE_DEBUT, FactBase.MISE_GROSSE_RELANCE)));
			//					- les cartes sont a jouer seulement en fin de parole, que l'on est milieu de parole, et que l'on subbit une grosse relance
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_FIN, FactBase.PAROLE_MILIEU, FactBase.MISE_GROSSE_RELANCE)));
			//					- les cartes sont a jouer en milieu ou fin de parole, et que l'on est en debut de parole, et que la mise à suivre dépasse le double de la big blind
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_DEBUT, FactBase.MISE_GROSSE_RELANCE)));
			
			// Suit si :
			//					- les cartes ne sont jamais à jouer, que la mise ne dépasse pas la big blind, et que l'intuition soit tres forte
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_JAMAIS, FactBase.MISE_EGALE_BIGBLIND, FactBase.INTUITION_TRES_FORTE)));
			//					- les cartes sont a jouer seulement en fin de parole, et que l'on est en debut de parole, et que la mise à suivre ne dépasse pas la big blind
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_FIN, FactBase.PAROLE_DEBUT, FactBase.MISE_EGALE_BIGBLIND)));
			//					- les cartes sont a jouer seulement en fin de parole, et que l'on est en milieu de parole, et que la mise à suivre ne dépasse pas le double de la big blind
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_FIN, FactBase.PAROLE_MILIEU, FactBase.MISE_EGALE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_FIN, FactBase.PAROLE_MILIEU, FactBase.MISE_DOUBLE_BIGBLIND)))
			// 					- si les cartes sont à ne jamais jouer, que la mise ne dépasse pas la big blind, et que l'intuition est tres forte
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_FIN, FactBase.PAROLE_FIN)));
			//					- les cartes sont a jouer en milieu ou fin de parole, et que l'on est en debut de parole, et que la mise à suivre ne dépasse pas le double de la big blind
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_DEBUT, FactBase.MISE_EGALE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_DEBUT, FactBase.MISE_DOUBLE_BIGBLIND)));
			//					- les cartes sont a jouer en milieu ou fin de parole, et que l'on est en milieu de parole
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_MILIEU)));
			//					- les cartes sont a jouer en milieu ou fin de parole, et que l'on est en fin de parole, et que l'on a une intuition faible ou tres faible
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_FIN, FactBase.INTUITION_FAIBLE)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_FIN, FactBase.INTUITION_TRES_FAIBLE)));
			
			// Relance si :
			// 					- les cartes sont a jouer en toute position
			AddRule(new Rule (FactBase.EVENT_RELANCER, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_TOUT_TEMPS)));
			//					- les cartes sont a jouer en milieu ou fin de parole, que l'on est en fin de parole, et que l'on a une bonne ou tres bonne intuition
			AddRule(new Rule (FactBase.EVENT_RELANCER, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_FIN, FactBase.INTUITION_FORTE)));
			AddRule(new Rule (FactBase.EVENT_RELANCER, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUER_MILIEU_OU_FIN, FactBase.PAROLE_FIN, FactBase.INTUITION_TRES_FORTE)));
			
			
			// Changement de stratégie préflop pour le duel
			//AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_PREFLOP, FactBase.JOUEURS_DEUX, FactBase.JOUER_FIN)));
			//AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_PREFLOP, FactBase.JOUEURS_DEUX, FactBase.JOUER_MILIEU_OU_FIN)));
			
			// ****************** FLOP ****************
			
			// Se couche si :
			// 					- notre main se situe dans la partie tres basse de l'ensemble des valeurs des mains possibles, que la proba de main suppérieure est tres forte ou moins
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_BASSE, FactBase.MAIN_SUP_HAUTE)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_BASSE, FactBase.MAIN_SUP_BASSE)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_BASSE, FactBase.MAIN_SUP_TRES_BASSE)));
			// 					- notre main se situe dans la partie basse de l'ensemble des valeurs des mains possibles, si la mise a suivre est égale ou supérieure à la big blind
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_BASSE, FactBase.MISE_DOUBLE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_BASSE, FactBase.MISE_GROSSE_RELANCE)));
			// 					- notre main se situe dans la partie haute de l'ensemble des valeurs des mains possibles, si la mise a suivre est supérieure à la big blind
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD,	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_HAUTE, FactBase.MISE_GROSSE_RELANCE)));
			
			// Suit si :
			// 					- notre main se situe dans la partie tres basse de l'ensemble des valeurs des mains possibles, si la mise a suivre est égale à la big blind, et si la probabilité d'avoir une main supérieure est tres forte
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_BASSE, FactBase.MAIN_SUP_TRES_HAUTE)));
			
			//					- notre main se situe dans la partie basse de l'ensemble des valeurs des mains possibles, et la mise a suivre ne dépasse pas la big blind
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_BASSE, FactBase.MISE_EGALE_BIGBLIND)));
			//					- notre main se situe dans la partie haute de l'ensemble des valeurs des mains possibles, et la mise a suivre ne dépasse pas le double de la big blind
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_HAUTE, FactBase.MISE_EGALE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_HAUTE, FactBase.MISE_DOUBLE_BIGBLIND)));
			
			// Relance si :
			//					- notre main se situe dans la partie tres haute de l'ensemble des valeurs des mains possibles
			AddRule(new Rule (FactBase.EVENT_RELANCER, 		new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_HAUTE)));
			
			
			// Jouer plus souple si moins de joueurs
			
			// Au flop et river, jouer si possibilité elevée d'avoir une main supérieure
			// A voir => jouer en fonction de la valeur supérieure pouvant etre obtenue !
			
			// A voir => continuer si probabilité X d'avoir une valeur > double pair  
			
			// Jouer plus facilement si Stack élevé, et ne pas prendre de risque si stack faible
			
			// 
			//AddRule(new Rule (FactBase., 					new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_HAUTE)));
			
			// ****************** Turn ****************
			
			// Se couche si :
			// 					- notre main se situe dans la partie tres basse de l'ensemble des valeurs des mains possibles, que la proba de main suppérieure est tres forte ou moins
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_BASSE)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_BASSE, FactBase.MAIN_SUP_BASSE)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_BASSE, FactBase.MAIN_SUP_TRES_BASSE)));
			// 					- notre main se situe dans la partie basse de l'ensemble des valeurs des mains possibles, si la mise a suivre est égale ou supérieure à la big blind
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_BASSE, FactBase.MISE_DOUBLE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_BASSE, FactBase.MISE_GROSSE_RELANCE)));
			// 					- notre main se situe dans la partie haute de l'ensemble des valeurs des mains possibles, si la mise a suivre est supérieure à la big blind
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD,	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_HAUTE, FactBase.MISE_GROSSE_RELANCE)));
			
			// Suit si :
			// 					- notre main se situe dans la partie tres basse de l'ensemble des valeurs des mains possibles, si la mise a suivre est égale à la big blind, et si la probabilité d'avoir une main supérieure est tres forte
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_BASSE, FactBase.MAIN_SUP_TRES_HAUTE)));
			
			//					- notre main se situe dans la partie basse de l'ensemble des valeurs des mains possibles, et la mise a suivre ne dépasse pas la big blind
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_BASSE, FactBase.MISE_EGALE_BIGBLIND)));
			//					- notre main se situe dans la partie haute de l'ensemble des valeurs des mains possibles, et la mise a suivre ne dépasse pas le double de la big blind
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_HAUTE, FactBase.MISE_EGALE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_HAUTE, FactBase.MISE_DOUBLE_BIGBLIND)));
			
			// Relance si :
			//					- notre main se situe dans la partie tres haute de l'ensemble des valeurs des mains possibles
			AddRule(new Rule (FactBase.EVENT_RELANCER, 		new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_HAUTE)));
			
			// ****************** River ****************
			
			// Se couche si :
			// 					- notre main se situe dans la partie tres basse de l'ensemble des valeurs des mains possibles
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_BASSE)));
			// 					- notre main se situe dans la partie basse de l'ensemble des valeurs des mains possibles
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD, 	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_BASSE)));
			// 					- notre main se situe dans la partie haute de l'ensemble des valeurs des mains possibles, si la mise a suivre est supérieure à la big blind
			AddRule(new Rule (FactBase.EVENT_CHECK_FOLD,	new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_HAUTE, FactBase.MISE_GROSSE_RELANCE)));
			
			// Suit si :
			//					- notre main se situe dans la partie haute de l'ensemble des valeurs des mains possibles, et la mise a suivre ne dépasse pas le double de la big blind
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_HAUTE, FactBase.MISE_EGALE_BIGBLIND)));
			AddRule(new Rule (FactBase.EVENT_SUIVRE, 		new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_HAUTE, FactBase.MISE_DOUBLE_BIGBLIND)));
			
			// Relance si :
			//					- notre main se situe dans la partie tres haute de l'ensemble des valeurs des mains possibles
			AddRule(new Rule (FactBase.EVENT_RELANCER, 		new Array(FactBase.EVENT_FLOP, FactBase.PARTIE_TRES_HAUTE)));

			
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