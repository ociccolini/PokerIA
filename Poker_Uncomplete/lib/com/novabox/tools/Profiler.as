package com.novabox.tools 
{
	/**
	 * ...
	 * @author Ophir
	 */
	public class Profiler
	{
		
		public static var instance:Profiler = new Profiler();
		
		private var start:Array;
		private var results:Array;
		
		public function Profiler() 
		{
			start = new Array();
			results = new Array();
		}
		
		public function StartProfiling(_label:String) : void
		{
			start[_label] = (new Date()).time;
		}
		
		public function EndProfiling(_label:String) : void
		{
			var endDate:Number = (new Date()).time;
			if (results[_label])
			{
				results[_label] += endDate- start[_label];
			}
			else
			{
				results[_label] = endDate - start[_label];
			}
		}
		
		public function TraceProfile(_label:String) : void
		{
			trace("Profiling " + _label + " : " + results[_label] + " ms");
		}
	}

}