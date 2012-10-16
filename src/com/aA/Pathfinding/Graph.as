package com.aA.Pathfinding 
{
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class Graph 
	{
		public var nextIndex:int = 0;
		public var nodes:Vector.<Node>;
		public var edges:Vector.<Array>;
		
		public function Graph() 
		{
			nodes = new Vector.<Node>();
			edges = new Vector.<Array>();
		}
		
		public function getNode(i:int):Node {
			return nodes[i];
		}
		
		/**
		 * To get an edge, we ask for the two nodes that it connects.
		 * Then we retrieve all the edges of the 'FROM' node, and search if one goes to the same node as the EDGE we are looking for.
		 * 
		 * @param	from
		 * @param	to
		 * @return
		 */
		public function getEdge(from:int, to:int):Edge {
			var fromEdges:Array = edges[from] as Array;
			for (var a:int = 0; a < fromEdges.length; a++) {
				if (fromEdges[a].to() == to) {
					return fromEdges[a];
				}
			}
			return null;
		}
		
		/**
		 * To add a node to the graph, first look if it exists.
		 * If it doesn't - add to the node vector, and add an array edges vector to store its edges.
		 * Finally, increase the index.
		*/
		public function addNode(node:Node):int {
			if (validIndex(node.index)) {
				nodes.push(node);
				edges.push(new Array());
				nextIndex++;
			}
			return 0;
		}
		
		/**
		 * To add an edge, must look if both nodes it connects to, actually exist.
		 * Then see if this edge already exists
		 * Finally, add to the array
		 * @param	edge
		 */
		public function addEdge(edge:Edge):void {
			if (validIndex(edge.to) && validIndex(edge.from)) {
				if (getEdge(edge.from, edge.to) == null) {
					(edges[edge.from] as Array).push(edge);
				}
			}
		}
		
		public function getEdges(node:int):Array {
			return edges[node];
		}
		
		public function validIndex(i:int):Boolean {
			return (i >= 0 && i <= nextIndex);
		}
		
		public function numNodes():int {
			return nodes.length;
		}
		
		public function getNextIndex():int {
			return nextIndex;
		}
	}

}