package com.aA.Pathfinding.Algorithms 
{
	import aA.utils.IndexedPriorityQ;
	import com.aA.Pathfinding.Edge;
	import com.aA.Pathfinding.Graph;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class Astar 
	{
		private var graph:Graph;
		private var SPT:Vector.<Edge>;
		private var G_Cost:Vector.<Number>;
		private var F_Cost:Vector.<Number>;
		private var SF:Vector.<Edge>;
		private var source:int;
		private var target:int;
		
		public function Astar(g:Graph, src:int, tar:int) 
		{
			this.graph = g;
			source = src;
			target = tar;
			
			SPT = new Vector.<Edge>(graph.numNodes());
			G_Cost = new Vector.<Number>(graph.numNodes());
			F_Cost = new Vector.<Number>(graph.numNodes());
			SF = new Vector.<Edge>(graph.numNodes());
			
			search();
		}
		
		private function search():void {
			var pq:IndexedPriorityQ = new IndexedPriorityQ(F_Cost);
			
			pq.insert(source);
			
			while (!pq.isEmpty()) {
				var NCN:int = pq.pop();
				SPT[NCN] = SF[NCN];
				
				if (SPT[NCN]) {
					// draw edge
				}
				
				if (NCN == target) return;
				
				var edges:Array = graph.getEdges(NCN);
				for each (var edge:Edge in edges) {
					// H Cost is obtained by distance between target and arrival node of the edge being analyzed.
					var HCost:Number = Point.distance(graph.getNode(edge.to).pos, graph.getNode(target).pos);
					var GCost:Number = G_Cost[NCN] + edge.cost;
					var to:int = edge.to;
					
					if (SF[edge.to] == null) {
						F_Cost[edge.to] = GCost + HCost;
						G_Cost[edge.to] = GCost;
						pq.insert(edge.to);
						SF[edge.to] = edge;
					} else if (GCost < G_Cost[edge.to]) && (SPT[edge.to] == null){
						F_Cost[edge.to] = GCost + HCost;
						G_Cost[edge.to] = GCost;
						pq.reorderUp();
						SF[edge.to] = edge;	
					}
				}
			}
		}
		
		public function getPath():Array {
			var path:Array = new Array();
			
			if (target < 0) return path;
			
			var nd:int = target;
			path.push(nd);
			
			while ((nd != source) && (SPT[nd] != null) {
				nd = SPT[nd].from;
				path.push(nd);
			}
			
			path = path.reverse();
			return path;
		}
		
	}

}