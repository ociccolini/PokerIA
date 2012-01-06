package com.novabox.poker.evaluator 
{
	import com.novabox.playingCards.Height;
	import com.novabox.playingCards.PlayingCard;
	import com.novabox.playingCards.Suit;
	import com.novabox.poker.HandValue;
	/**
	 * ...
	 * @author Ophir
	 */
	public class HandEvaluator
	{
		public static const 	CLUB:int = 0x8000;
		public static const 	DIAMOND:int = 0x4000;
		public static const 	HEART:int = 0x2000;
		public static const 	SPADE:int = 0x1000;

		public static const 	Deuce:int = 0;
		public static const 	Trey:int = 1;
		public static const 	Four:int = 2;
		public static const 	Five:int = 3;
		public static const 	Six:int = 4;
		public static const 	Seven:int = 5;
		public static const 	Eight:int = 6;
		public static const 	Nine:int = 7;
		public static const 	Ten:int = 8;
		public static const 	Jack:int = 9;
		public static const 	Queen:int = 10;
		public static const 	King:int = 11;
		public static const 	Ace:int = 12;
		
		public	var subhand:Array;

		public function HandEvaluator() 
		{
			subhand = new Array();
		}
/*		public static function Test() : void
		{
		}
*/		
		public function GetCardInt(_card:PlayingCard): int
		{
			 var suit:int = 0x8000 ;
			 for (var i:int = 0; i < _card.GetSuit(); i++)
			 {
				 suit = suit >> 1;
			 }
			 
			 var prime:int =  HandEvaluatorArrays.primes[_card.GetHeight()];
			 var height:int = _card.GetHeight() << 8;
			 var heightMask : int = 1 << (16 + _card.GetSuit());
			 
			 var value:int = prime | height | suit | heightMask;
			return value;
		}
		
		public function hand_rank( val:int ) : int
		{
			if (val > 6185) return(HandValue.HIGH_CARD);
			if (val > 3325) return(HandValue.PAIR);         // 2860 one pair
			if (val > 2467) return(HandValue.TWO_PAIRS);         //  858 two pair
			if (val > 1609) return(HandValue.THREE_OF_A_KIND);  //  858 three-kind
			if (val > 1599) return(HandValue.STRAIGHT);         //   10 straights
			if (val > 322)  return(HandValue.FLUSH);            // 1277 flushes
			if (val > 166)  return(HandValue.FULL_HOUSE);       //  156 full house
			if (val > 10)   return(HandValue.FOUR_OF_A_KIND);   //  156 four-kind
			return(HandValue.STRAIGHT_FLUSH);                   //   10 straight-flushes
		}

		public function	eval_5cards( c1:int, c2:int, c3:int, c4:int, c5:int ) : int
		{
			var q:int;
			var s:int;

			q = (c1|c2|c3|c4|c5) >> 16;

			if ( c1 & c2 & c3 & c4 & c5 & 0xF000 )
			return( HandEvaluatorArrays.flushes[q] );

			s = HandEvaluatorArrays.unique5[q];
			if ( s )  return ( s );

			c1 = c1 & 0xFF;
			c2 = c2 & 0xFF;
			c3 = c3 & 0xFF;
			c4 = c4 & 0xFF;
			c5 = c5 & 0xFF;
			q = c1 * c2 * c3 * c4 * c5;
			q = findit( q );

			var result:int = HandEvaluatorArrays.values[q] ;
			
			return result;
		}

		public function eval_5hand( hand:Array) : int
		{
			return( eval_5cards(hand[0],hand[1],hand[2],hand[3],hand[4]) );
		}

		public function eval_7cards( hand:Array ) : int
		{
			var i:int;
			var j:int;
			var q:int;
			var best:int = 9999;

			for ( i = 0; i < 21; i++ )
			{
				for ( j = 0; j < 5; j++ )
				{
					subhand[j] = hand[ HandEvaluatorArrays.perm7[i][j] ];
				}
				q = eval_5hand( subhand );
				if ( q < best  && (q > 0))
				{
					best = q;
				}
			}
			return( best );
		}		

		public function findit( key:int ) : int
		{
			var low:int = 0;
			var high:int = 4887;
			var mid:int;

			while ( low <= high )
			{
				mid = (high+low) >> 1;      // divide by two
				if ( key < HandEvaluatorArrays.products[mid] )
					high = mid - 1;
				else if ( key > HandEvaluatorArrays.products[mid] )
					low = mid + 1;
				else
					return( mid );
			}
			return( -1 );
		}

		public static function	RANK(x:int):int	
		{
			return ((x >> 8) & 0xF);
		}

	}
}