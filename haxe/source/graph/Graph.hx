package graph;
import utilites.MathUtil;

/**
 * ...
 * @author ...
 */
class Graph
{
	public var adjacencyList:Map<Int,Map<Int,Bool>>;
	public var subGraph:Graph;
	public var impassableVertices:Map<Int,Bool>;
	private var edges:List<Edge>;
	public var removedVertices:Map<Int,Map<Int,Bool>>;
	private var vertices: Map<Int,Vertex>;
	
	public function new() 
	{
		this.adjacencyList = new Map<Int,Map<Int,Bool>>();
		this.removedVertices = new Map<Int,Map<Int,Bool>>();
		this.impassableVertices = new Map<Int,Bool>();
	}
	
	public function addConnection(first:Int, second:Int)
	{	
		addSingleConnection(first, second);
		addSingleConnection(second, first);
		
		this.vertices = null;
	}
	
	public function GetNumberOfConnections(index:Int):Int
	{
	   var ret = 0; 
	   if (!adjacencyList.exists(index))
			return ret;
		
	   for (_ in adjacencyList.get(index).keys()) ret++; 
	   return ret; 
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
	
	public function createSubgrafFromVertices<T>(vertices:Map<Int,T>,removeFromMain:Bool)
	{
		if (subGraph == null)
			subGraph = new Graph();
		
		for (vert in vertices.keys())
		{
			subGraph.adjacencyList.set(vert, new Map<Int,Bool>());
			for (neigh in adjacencyList.get(vert).keys())
			{
				if (vertices.exists(neigh))
				{
					subGraph.addConnection(vert, neigh);
				}
			}	
		}
		if (removeFromMain)
		{
			for (vert in vertices.keys())
			{
				removeVertex(vert);
			}
		}
		this.vertices = null;
	}
	
	public function removeVertex(toRemove:Int)
	{
		removedVertices.set(toRemove, adjacencyList.get(toRemove));
		adjacencyList.remove(toRemove);
		
		for (pair in adjacencyList)
			pair.remove(toRemove);
		
		this.vertices = null;
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
	
	public function setImpassable(vertex:Int)
	{
		impassableVertices.set(vertex, true);
	}
	public function setPassable(vertex:Int)
	{
		impassableVertices.remove(vertex);
	}
	
	public function isThisVerPassable(vertex:Int):Bool
	{
		return !impassableVertices.exists(vertex) && adjacencyList.exists(vertex);
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
		var vert = new Map<Int,Vertex>();
		for (key in adjacencyList.keys()) 
		{
			vert.set(key, new Vertex(key));
		}
		return vert;
	}
}