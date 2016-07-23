package graph;

/**
 * ...
 * @author ...
 */
class Graph
{
	public var adjacencyList:Map<Int,Map<Int,Bool>>;
	private var vertices:Map<Int,Vertex>;
	private var edges:List<Edge>;
	
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
	public function getDistance(begin:Int, end:Int):Int
	{
		return 1;
	}
	
	public function getConnected(vertex:Int):Iterator<Int>
	{
		if (adjacencyList.exists(vertex))
		{
			return adjacencyList.get(vertex).keys();
		}
		else 
			return null;
	}
	
	public function getListOfEdges():List<Edge>
	{
		if (edges == null)
		{		
			edges = new List<Edge>();
			for (key in adjacencyList.keys()) {
				for (connected in adjacencyList.get(key).keys())
				{
					edges.add(new Edge(key, connected));
				}
			}
		}
		return edges;
	}
	
	public function getVertices():Map<Int,Vertex>
	{
		vertices = new Map<Int,Vertex>();
		for (key in adjacencyList.keys()) 
			vertices.set(key,new Vertex(key));
		return vertices;
	}
}