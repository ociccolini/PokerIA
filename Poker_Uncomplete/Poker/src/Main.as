package
{
	import com.novabox.playingCards.Deck;
	import com.novabox.playingCards.Height;
	import com.novabox.playingCards.PlayingCard;
	import com.novabox.playingCards.Suit;
	import com.novabox.poker.evaluator.HandEvaluator;
	import com.novabox.poker.HumanPlayer;
	import com.novabox.poker.PokerPlayer;
	import com.novabox.poker.PokerTable;
	import com.novabox.poker.states.Preflop;
	import com.novabox.pokerGUI.PokerGUI;
	import com.novabox.tools.TimeManager;
	import com.rien.IntelligentPlayer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Ophir
	 */
	
	[SWF(backgroundColor = "#669933", frameRate = "60", width = "1024", height = "768")]
	public class Main extends Sprite 
	{
		public static const UPDATE_DELAY:int = 500;
		protected var updateTime:int;
		
		protected var pokerTable:PokerTable;
		public static var pokerGUI:PokerGUI = new PokerGUI();
		
		public static var paused:Boolean = false;
		
		
		public function Main():void 
		{
			updateTime = 0;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
						
			var players:Array = [	new IntelligentPlayer("IA", PokerTable.PLAYER_INIT_STACK),
									new PokerPlayer("player 6", PokerTable.PLAYER_INIT_STACK),
									new PokerPlayer("player 7", PokerTable.PLAYER_INIT_STACK),
									new PokerPlayer("player 8", PokerTable.PLAYER_INIT_STACK)
								];
									
			pokerTable = new PokerTable(players);
			pokerGUI.Initialize(pokerTable);
			
			addChild(pokerGUI);
			
			
			addEventListener(Event.ENTER_FRAME, Update);
		}
		
		protected function Update(_e:Event) : void
		{
			if (!paused)
			{
				TimeManager.timeManager.Update();
				updateTime += TimeManager.timeManager.GetFrameDeltaTime();
				if (updateTime > UPDATE_DELAY)
				{
					pokerTable.Update();
					pokerGUI.Update();
			
					updateTime = 0;
				}
			}
		}
		
		
		
	}
	
}