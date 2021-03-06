package graph;
import haxe.ds.ListSort;
import lime.tools.helpers.ArrayHelper;

class DjikstraPath implements Pathfinder
{
	private var graphObject:Graph;
	
	public function new(graph:Graph) 
	{
		this.graphObject = graph;
	}
	
	/* INTERFACE graph.Pathfinder */
	
	public function findPathMultipleEnds(start:Int, ends:Array<Int>):Array<Int>
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
			if (ArrayHelper.containsValue(ends,u))
			{
				return backtrackOfPredecessors(predecessors, u, start);
			}
				
			Q.remove(u);
			for (neighbor in graphObject.getConnected(u))
			{
				if (graphObject.isThisVerPassable(neighbor))
				{
					var alt = distance.get(u) + graphObject.getDistance(u, neighbor);
					if (alt < distance.get(neighbor))
					{
						distance.set(neighbor, alt);
						predecessors.set(neighbor, u);
					}
				}
			}
			
		}
		return null;
	}
	
	public function findPath(start:Int, end:Int):Array<Int> 
	{
		return findPathMultipleEnds(start, [end]);
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
			
			if (current == -1)
				return null;
		}	
		path.reverse();
		return path;
	}
	
}