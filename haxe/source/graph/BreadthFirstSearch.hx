package graph;

/**
 * ...
 * @author ...
 */
class BreadthFirstSearch
{
	private var graphObject:Graph;
	
	public function new(graph:Graph) 
	{
		this.graphObject = graph;
	}
	
	public function findRange(root:Vertex, rangeSize:Int, checkPassable:Bool):Map<Int,Int>
	{
		var range = new Map<Int,Int>();
		var nodes = this.graphObject.getVertices();
		var queue = new List<Vertex>();
		
		root.distance = 0;
		queue.add(root);
		while (!queue.isEmpty())
		{
			var current = queue.pop();
			
			for (nodeIndex in graphObject.getConnected(current.index))
			{
				if (!checkPassable || graphObject.isThisVerPassable(nodeIndex))
				{
					var node = nodes.get(nodeIndex);
					if (node.distance == Vertex.MAX)
					{
						node.distance = current.distance + 1;
						node.parent = current;
						if (node.distance <= rangeSize)
						{
							queue.add(node);
							range.set(node.index,node.index);
						}
					}
				}
			}
		}
		return range;
	}
	
}