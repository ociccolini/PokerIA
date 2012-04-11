package com.rien.expertSystem 
{
	public class ExpertSystem
	{
		private var factBase:FactBase;
		private var ruleBase:RuleBase;
		
		private var inferedFacts:Array;
		private var factsToAsk:Array;
		
		public function ExpertSystem() 
		{
			factBase = new FactBase();
			ruleBase = new RuleBase();	
			inferedFacts = new Array();
			
		}

		public function GetFactBase() : FactBase
		{
			return factBase;
		}
		
		public function GetRuleBase() : RuleBase
		{
			return ruleBase;
		}
	
		public function AddFact(_fact:Fact) : void
		{
			factBase.AddFact(_fact);
		}
		
		public function SetFactValue(_fact:Fact, _value:Boolean) : void
		{
			factBase.SetFactValue(_fact, _value);
		}
		
		public function ResetFacts() : void
		{
			factBase.ResetFacts();
		}
		
		public function AddRule(_rule:Rule) : void
		{
			if (!factBase.HasFact(_rule.GetGoal()))
			{
				factBase.AddFact(_rule.GetGoal());
			}
			
			var premises:Array = _rule.GetPremises();
			
			for (var i:int = 0; i < premises.length; i++)
			{
				var premise:Fact = (premises[i] as Fact);
				if (!factBase.HasFact(premise))
				{
					factBase.AddFact(premise);
				}			
			}
			
			ruleBase.AddRule(_rule);
		}
		
		public function IsRuleValid(_rule:Rule) : Boolean
		{
			
			var goal:Fact = _rule.GetGoal();
			if (factBase.GetFactValue(goal) == true)
			{
				//Already infered
				return false;
			}
			
			var premises:Array = _rule.GetPremises();
			for (var i:int = 0; i < premises.length; i++)
			{
				var premise:Fact = (premises[i] as Fact);
				if (factBase.GetFactValue(premise) == false)
				{
					//One premise is false
					return false;
				}
			}
			return true;
		}
		
		public function GetValidRule() : Rule
		{
			var rules:Array = ruleBase.GetRules();
			for (var i:int = 0; i < rules.length; i++)
			{
				var rule:Rule = (rules[i] as Rule);
				if (IsRuleValid(rule))
				{
					return rule;
				}
			}
			
			return null;
		}
		
		public function ClearInferedFacts() : void
		{
			while (inferedFacts.length > 0)
			{
				inferedFacts.pop();
			}
		}
		
		public function InferForward() : void
		{
			ClearInferedFacts();
			
			var validRule:Rule = GetValidRule();
			while (validRule != null)
			{	
				var goal:Fact = validRule.GetGoal();
				factBase.SetFactValue(goal, true);
				inferedFacts.push(goal);
				
				//TraceRule(validRule);
				
				validRule = GetValidRule();
			}
		}
		
		public function GetInferedFacts() : Array
		{
			return inferedFacts;
		}
		
		public function TraceRule(_rule:Rule) : void
		{
			var traceString:String = "";
			var premises:Array = _rule.GetPremises();
			for (var i:int = 0; i < premises.length; i++)
			{
				traceString += (premises[i] as Fact).GetLabel();
				
				if (i < (premises.length - 1))
				{
					traceString += ", ";
				}
			}
			traceString += " -> " + _rule.GetGoal().GetLabel();
			
			trace(traceString);
		}
		
		
		public function GetFactsToAsk(): Array
		{
			return factsToAsk;
		}
		
		public function InferBackward() : void
		{
			factsToAsk = new Array();
			var finalFacts:Array = GetFinalFacts();
			for each(var finalFact:Fact in finalFacts)
			{
				AddFactsToAsk(finalFact)
			}
		}
		
		public function AddFactsToAsk(_goal:Fact) : void
		{
			if (factBase.GetFactValue(_goal) == true) return;
			for each(var rule:Rule in ruleBase.GetRules())
			{
				if (rule.GetGoal() == _goal)
				{
					for each(var premise:Fact in rule.GetPremises())
					{
						if (IsInitialFact(premise))
						{
							if (factsToAsk.indexOf(premise) == -1)
							{
								factsToAsk.push(premise);
							}
						}
						else
						{
							AddFactsToAsk(premise);
						}
					}
				}
			}				
		}
		
		public function GetFinalFacts() : Array
		{
			var result:Array = new Array();
			for each(var rule:Rule in ruleBase.GetRules())
			{
				var goal:Fact = rule.GetGoal();
				if (IsFinalFact(goal))
				{
					result.push(goal);
				}
			}
			return result;
		}
		
		public function IsFinalFact(_fact:Fact) : Boolean
		{
			for each(var rule:Rule in ruleBase.GetRules())
			{
					if (rule.GetPremises().indexOf(_fact) != -1)
					{
						return false;
					}
			}
			return true;
		}
		
		public function IsInitialFact(_fact:Fact) : Boolean
		{
			for each(var rule:Rule in ruleBase.GetRules())
			{
					if (rule.GetGoal() == _fact)
					{
						return false;
					}
			}
			return true;
		}
	}

}