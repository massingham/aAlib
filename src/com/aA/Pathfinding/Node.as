package com.aA.Pathfinding 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class Node 
	{
		public var pos:Point;
		public var index:int;
		
		public function Node(idx:int, p:Point) 
		{
			this.pos = p;
			this.index = idx;
		}
		
	}

}