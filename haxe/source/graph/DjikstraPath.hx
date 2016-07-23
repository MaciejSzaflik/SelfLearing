package graph;
import haxe.ds.ListSort;

/**
 * ...
 * @author ...
 */
class DjikstraPath implements Pathfinder
{
	private var graphObject:Graph;
	
	public function new(graph:Graph) 
	{
		this.graphObject = graph;
	}
	
	/* INTERFACE graph.Pathfinder */
	
	public function findPath(start:Int, end:Int):Array<Int> 
	{
		var verticies = graphObject.getVertices();
		var distance = new Map<Int,Int>();
		var predecessors = new Map<Int,Int>();
		var Q = new Array<Int>();
		for (vertex in verticies)
		{
			Q.push(vertex.index);
			distance.set(vertex.index, Vertex.MAX);
			predecessors.set(vertex.index, -1);
		}
		
		distance.set(start, 0);
		
		while(Q.length != 0)
		{
			Q.sort(function(x:Int, y:Int):Int {return distance.get(x) - distance.get(y); });
			var u = Q[0];
			if (u == end)
				return backtrackOfPredecessors(predecessors, end, start);
				
			Q.remove(u);
			for (neighbor in graphObject.getConnected(u))
			{
				var alt = distance.get(u) + graphObject.getDistance(u, neighbor);
				if (alt < distance.get(neighbor))
				{
					distance.set(neighbor, alt);
					predecessors.set(neighbor, u);
				}
			}
			
		}
		return null;
	}
	
	private function backtrackOfPredecessors(predecessors:Map<Int,Int>, start:Int, end:Int):Array<Int>
	{
		var path = new Array<Int>();
		path.push(start);
		var current = start;
		while (current != end || current == null)
		{
			if (predecessors.exists(current))
			{
				current = predecessors.get(current);
				path.push(current);
			}
			else
				current = null;
		}	
		path.reverse();
		return path;
	}
	
}