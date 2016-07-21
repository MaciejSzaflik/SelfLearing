package graph;

/**
 * ...
 * @author ...
 */
class Graph
{
	public var adjacencyList:Map<Int,Map<Int,Bool>>;
	public function new() 
	{
		this.adjacencyList = new Map<Int,Map<Int,Bool>>();
	}
	
	public function addConnection(first:Int, second:Int)
	{	
		addSingleConnection(first, second);
		addSingleConnection(second, first);
	}
	
	private function addSingleConnection(first:Int, second:Int)
	{
		if (adjacencyList.exists(first))
		{
			adjacencyList.get(first).set(second, true);
		}
		else
			adjacencyList.set(first, [second => true]);
	}
	
	public function checkConnection(first:Int, second:Int):Bool
	{
		return checkSingleConnection(first, second);
	}
	
	private function checkSingleConnection(first:Int, second:Int):Bool
	{
		if (adjacencyList.exists(first))
		{
			if (adjacencyList.get(first).get(second))
				return true;
			else
				return false;
		}
		else
			return false;
	}
	
	
	public function getListOfEdges():List<Edge>
	{
		var toReturn = new List<Edge>();
		for (key in adjacencyList.keys()) {
			for (connected in adjacencyList.get(key).keys())
			{
				toReturn.add(new Edge(key, connected));
			}
		}
		return toReturn;
	}
}