﻿package com.rien.expertSystem 
{
	public class RuleBase
	{
		private var rules:Array;
		
		public function RuleBase() 
		{
			rules = new Array();
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