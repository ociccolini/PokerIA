package com.rien 
{
	import com.novabox.poker.PokerPlayer;
	import com.novabox.poker.PokerTable;
	import com.novabox.poker.PokerAction;
	import flash.media.Video;
	
	
	public class IntelligentPlayer extends PokerPlayer
	{
		private static const 	ToujoursJouer:int = 3;
		private static const 	JouerMilieuOuFinParole:int = 2;
		private static const 	JouerSeulementFinParole:int = 1;
		private static const 	NeJamaisJouer:int = 0;
		
		private var tableauProbabiliteCartesDepareillesPreflop:Array =  [
																		[3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																		[3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																		[3, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																		[3, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0],
																		[1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0],
																		[1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0],
																		[1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
																		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]		
																		];

		private var tableauProbabiliteCartesMemesCouleursPreflop:Array =  	[
																				[3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																				[3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																				[3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																				[3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																				[3, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0],
																				[2, 2, 2, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0],
																				[2, 1, 2, 2, 2, 2, 3, 0, 0, 0, 0, 0, 0],
																				[2, 1, 0, 1, 1, 1, 1, 3, 0, 0, 0, 0, 0],
																				[2, 1, 0, 0, 0, 1, 1, 1, 2, 0, 0, 0, 0],
																				[1, 1, 0, 0, 0, 0, 0, 1, 1, 2, 0, 0, 0],
																				[1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
																				[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
																				[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
																			];
																
		public function IntelligentPlayer(_name:String, _stackValue:Number) 
		{
			super(_name, _stackValue);
		}
		
		public function CalculProbabilite() : int
		{
			var tableauProbabiliteCartesDepareilles:Array =  [[3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																[3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																[3, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																[3, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0],
																[1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0],
																[1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0],
																[1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
																[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
																[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]		
																];
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
			return (lastAction != PokerAction.NONE);
		}
		
		public function perception() : void {
			// Remplir base de fait
		}
		
		public function analyse() : void {
			// Inférer
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
			// ici on pourra analyser le jeux du joueur passé en parametre
		}
		
		public override function ProcessPlayerShowdown(_player:PokerPlayer) : void
		{

		}
		
		public override function ProcessPlayerWon(_player:PokerPlayer) : void
		{
			
		}
	}
}