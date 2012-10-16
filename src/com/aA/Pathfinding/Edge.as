package com.aA.Pathfinding 
{
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class Edge 
	{
		public var from:int;
		public var to:int;
		public var cost:Number;
		
		public function Edge(n_from:int, n_to:int, n_cost:Number) 
		{
			this.from = n_from;
			this.to = n_to;
			this.cost = n_cost;
		}
	}

}