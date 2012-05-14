package com.rien.expertSystem 
{
	public class FactBase
	{
		
		private var facts:Array;
		
		private var factValues:Array;
		
		
		// ******************************************* BASE DE FAITS *****************************************
		
		// Evenement de la manche
		public static const EVENT_PREFLOP:Fact 		= new Fact ("Preflop");
		public static const EVENT_FLOP:Fact 		= new Fact ("Flop");
		public static const EVENT_TURN:Fact 		= new Fact ("Turn");
		public static const EVENT_RIVER:Fact 		= new Fact ("River");
		
		// Stack du joueur
		public static const STACK_MEILLEUR:Fact 	= new Fact ("Stack Meilleur");
		public static const STACK_MOYEN:Fact 		= new Fact ("Stack Moyen");
		public static const STACK_PLUS_BAS:Fact 	= new Fact ("Stack Plus Bas");
		
		// Nombre de joueurs actifs sur la manche
		public static const JOUEURS_DEUX:Fact 		= new Fact ("Deux joueurs");
		public static const JOUEURS_TROIS:Fact 		= new Fact ("Trois joueurs");
		public static const JOUEURS_QUATRE:Fact 	= new Fact ("Quatre joueurs");
		public static const JOUEURS_CINQETPLUS:Fact = new Fact ("Cinque joueurs et plus");
		
		// Valeurs calculées pour le preflop
		public static const JOUER_TOUT_TEMPS:Fact 	= new Fact ("Jouer toute position");
		public static const JOUER_MILIEU_OU_FIN:Fact= new Fact ("Jouer milieu ou fin parole");
		public static const JOUER_FIN:Fact 			= new Fact ("Jouer fin de parole seulement");
		public static const JOUER_JAMAIS:Fact 		= new Fact ("Ne pas jouer");
		
		// Position du joueur
		public static const PAROLE_DEBUT:Fact 		= new Fact ("Debut de parole");
		public static const PAROLE_MILIEU:Fact 		= new Fact ("Milieu de parole");
		public static const PAROLE_FIN:Fact 		= new Fact ("Fin de parole");
		
		// Action du joueur
		public static const EVENT_CHECK_FOLD:Fact 	= new Fact ("Check/Fold");
		public static const EVENT_SUIVRE:Fact 		= new Fact ("Suivre");
		public static const EVENT_RELANCER:Fact 	= new Fact ("Relancer");
		
		//Valeur maximum de la main
		public static const HAND_HAUTE_MAIN:Fact 	= new Fact ("Haute carte");
		public static const HAND_PAIRE:Fact 		= new Fact ("Paire");
		public static const HAND_DOUBLE_PAIRE:Fact 	= new Fact ("Double paire");
		public static const HAND_BRELAN:Fact 		= new Fact ("Brelan");
		public static const HAND_SUITE:Fact 		= new Fact ("Suite");
		public static const HAND_COULEUR:Fact 		= new Fact ("Couleur");
		public static const HAND_FULL:Fact 			= new Fact ("Full");
		public static const HAND_CARRE:Fact 		= new Fact ("Carre");
		public static const HAND_QUINTE_FLUSH:Fact 	= new Fact ("Quinte flush");
		
		// Esperance mathematique 
		public static const ESPERANCE_POSITIVE:Fact 	= new Fact ("Esperance Positive");
		public static const ESPERANCE_NEGATIVE:Fact 	= new Fact ("Esperance Negative");
		
		// Position de la main vis a vis des possibilités générales
		public static const PARTIE_TRES_HAUTE:Fact 		= new Fact ("Partie Très Haute");
		public static const PARTIE_HAUTE:Fact 			= new Fact ("Partie Haute");
		public static const PARTIE_BASSE:Fact 			= new Fact ("Partie Basse");
		public static const PARTIE_TRES_BASSE:Fact 		= new Fact ("Partie Très Basse");
		
		// Probabilite d'obtenir une main superieure
		public static const MAIN_SUP_TRES_HAUTE:Fact	= new Fact ("Obtenir main sup Très Haute");
		public static const MAIN_SUP_HAUTE:Fact 		= new Fact ("Obtenir main sup Haute");
		public static const MAIN_SUP_BASSE:Fact 		= new Fact ("Obtenir main sup Basse");
		public static const MAIN_SUP_TRES_BASSE:Fact 	= new Fact ("Obtenir main sup Très Basse");
		
		// Intuition du joueur, determiné par un random
		public static const INTUITION_TRES_FORTE:Fact 	= new Fact ("Intuition tres forte");
		public static const INTUITION_FORTE:Fact 		= new Fact ("Intuition forte");
		public static const INTUITION_FAIBLE:Fact 		= new Fact ("Intuition faible");
		public static const INTUITION_TRES_FAIBLE:Fact 	= new Fact ("Intuition tres faible");
		
		// Hauteur de la mise par rapport à la big blind
		public static const MISE_GROSSE_RELANCE:Fact 	= new Fact ("Grosse relance");
		public static const MISE_DOUBLE_BIGBLIND:Fact 		= new Fact ("Mise > 2 x big blind");
		public static const MISE_EGALE_BIGBLIND:Fact 		= new Fact ("Mise = big blind");
		
		
		// ******************************************* FIN BASE DE FAITS *****************************************
		
		public function FactBase() 
		{
			facts 		= new Array();
			factValues 	= new Array();
			
			// ******************************************* DEBUT BASE DE FAITS *****************************************
			// Evenement de la manche
			AddFact (EVENT_PREFLOP);
			AddFact (EVENT_FLOP);
			AddFact (EVENT_RIVER);
			AddFact (EVENT_TURN);
			
			// Stack du joueur
			AddFact (STACK_MEILLEUR);
			AddFact (STACK_MOYEN);
			AddFact (STACK_PLUS_BAS);
			
			// Nombre de joueurs actifs sur la manche
			AddFact (JOUEURS_DEUX);
			AddFact (JOUEURS_TROIS);
			AddFact (JOUEURS_QUATRE);
			
			// Valeurs calculées pour le preflop
			AddFact (JOUER_TOUT_TEMPS);
			AddFact (JOUER_MILIEU_OU_FIN);
			AddFact (JOUER_FIN);
			AddFact (JOUER_JAMAIS);
			
			// Position du joueur
			AddFact (PAROLE_DEBUT);
			AddFact (PAROLE_MILIEU);
			AddFact (PAROLE_FIN);
			
			// Action du joueur
			AddFact (EVENT_CHECK_FOLD);
			AddFact (EVENT_SUIVRE);
			AddFact (EVENT_RELANCER);
			
			//Valeur maximum de la main
			AddFact (HAND_HAUTE_MAIN);
			AddFact (HAND_PAIRE);
			AddFact (HAND_DOUBLE_PAIRE);
			AddFact (HAND_BRELAN);
			AddFact (HAND_SUITE);
			AddFact (HAND_COULEUR);
			AddFact (HAND_FULL);
			AddFact (HAND_CARRE);
			AddFact (HAND_QUINTE_FLUSH);
			
			// Position de la main vis a vis des possibilités générales
			AddFact (PARTIE_TRES_HAUTE);
			AddFact (PARTIE_HAUTE);
			AddFact (PARTIE_BASSE);
			AddFact (PARTIE_TRES_BASSE);
			
			
			// Intuition du joueur, determiné par un random
			AddFact (INTUITION_TRES_FORTE);
			AddFact (INTUITION_FORTE);
			AddFact (INTUITION_FAIBLE);
			AddFact (INTUITION_TRES_FAIBLE);
			// ******************************************* FIN BASE DE FAITS *****************************************
			
			ResetFacts();
		}
		
		public function AddFact(_fact:Fact) : void
		{
			facts.push(_fact);
			SetFactValue(_fact, false);
		}
		
		public function HasFact(_fact:Fact) : Boolean
		{
			for (var i:int = 0; i < facts.length; i++)
			{
				if (facts[i] == _fact)
				{
					return true;
				}
			}
			return false;
		}
				
		public function SetFactValue(_fact:Fact, _value:Boolean) : void
		{
			if (HasFact(_fact))
			{
				factValues[_fact.GetLabel()] = _value;
			}
		}
		
		public function GetFactValue(_fact:Fact) : Boolean
		{
			if (HasFact(_fact))
			{
				return factValues[_fact.GetLabel()];
			}
			return false;
		}
		
		public function ResetFacts() : void
		{
			for (var i:int = 0; i < facts.length; i++)
			{
				var fact:Fact = (facts[i] as Fact);
				SetFactValue(fact, false);
			}
		}
		
	}

}