package com.novabox.poker.states 
{
	import com.novabox.automate.AutomateState;
	import com.novabox.poker.PokerTable;
	/**
	 * ...
	 * @author Ophir
	 */
	
	public class PokerTableState extends AutomateState
	{
		public function PokerTableState(_pokerTable:PokerTable, _id:String) 
		{
			super(_pokerTable, _id);
		}
		
		protected function GetTable() : PokerTable
		{
			return (automate as PokerTable);
		}
		
	}

}