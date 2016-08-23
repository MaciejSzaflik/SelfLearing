package hex;
import flixel.math.FlxPoint;
import graph.BreadthFirstSearch;
import graph.DjikstraPath;
import graph.Graph;
import graph.Pathfinder;
import graph.Vertex;
import hex.Hex;
import js.html.rtc.IdentityAssertion;
import source.BoardMap;

class HexMap extends BoardMap
{
	public var precalculatedPoints:List<Array<FlxPoint>>;
	private var hexes:Map<Int,Hex>;
	private var graphConnections:Graph;
	private var topping:HexTopping;
	private var mapCenter:FlxPoint;
	private var bfs:BreadthFirstSearch;
	private var pathfinder:Pathfinder;
		
	public var width(get, null):Int;
	public var height(get, null):Int;
	
	public function get_width():Int
	{
		return width;
	}
	
	public function get_height():Int
	{
		return height;
	}	
	
	public var hexSize(get, set):Float;
	private var _hexSize:Float;
	function get_hexSize():Float {
		return _hexSize;
	}

	function set_hexSize(value:Float) {
		return _hexSize = value;
	}
	
	private var boardsType:BoardShape;
	
	public function new(mapCenter:FlxPoint, hexSize:Float) 
	{
		this.hexSize = hexSize;
		this.mapCenter = mapCenter;
		this.topping = HexTopping.Pointy;
		graphConnections = new Graph();
		bfs = new BreadthFirstSearch(graphConnections);
		pathfinder = new DjikstraPath(graphConnections);
		super();
	}
	public function InitPoints()
	{
		resetLists();
	}
	
	private function resetLists():Void
	{
		this.precalculatedPoints = new List<Array<FlxPoint>>();
		this.hexes = new Map<Int,Hex>();
	}
	
	public function getRandomHex():Hex
	{
		return Random.fromIterable(hexes);
	}
	
	public function setHexImpassable(hex:hex.HexCoordinates)
	{
		getGraph().setImpassable(hex.toKey());
	}
	public function setHexPassable(hex:hex.HexCoordinates)
	{
		getGraph().setPassable(hex.toKey());
	}
	
	public function positionToHex(rawPosition:FlxPoint):HexCoordinates
	{
		var position = new FlxPoint(rawPosition.x - mapCenter.x, -(rawPosition.y - mapCenter.y));
		var q =  (position.x*Math.sqrt(3)/3 - position.y/3)/hexSize*2;
		var r =  (position.y * (2/3))/hexSize*2;
		return HexUtilites.cubeRand(q,-q-r,r);	
	}
	
	public function hexToPosition(coor:HexCoordinates):FlxPoint
	{
		var x = hexSize * 2 * Math.sqrt(3) * (coor.q + coor.r / 2);
		var y = hexSize * 3 * coor.r;
		return new FlxPoint(x,y);
	}
	
	public function getHexCenterByAxialCor(coor:HexCoordinates):FlxPoint
	{
		return new FlxPoint(mapCenter.x + coor.q*hexSize + coor.r*hexSize*0.5,mapCenter.y - coor.r*hexSize*0.75);
	}
	
	public function getGraph():Graph
	{
		return this.graphConnections;
	}
	
	public function getHexByIndex(index:Int):Hex
	{
		if (hexes.exists(index))
			return hexes.get(index);
		else
			return new Hex(new FlxPoint(0,0),new HexCoordinates(0,0));
	}
	
	public function getHexCenter(index:Int):FlxPoint
	{
		return getHexByIndex(index).center;
	}
	
	public function getArrayOfPoints():List<FlxPoint>
	{
		var edges = getGraph().getListOfEdges();
		var listOfPoints = new List<FlxPoint>();
		for (edge in edges)
		{
			if (hexes.exists(edge.left) && hexes.exists(edge.right))
			{
				listOfPoints.add(hexes.get(edge.left).center);
				listOfPoints.add(hexes.get(edge.right).center);
			}
			else
			{
				trace("Invalid edge: "+edge.toString());
			}
			
		}
		return listOfPoints;
	}
	
	public function getPathCenters(start:Int, end:Int):List<FlxPoint>
	{
		var centers = new List<FlxPoint>();
		if (hexes.exists(start) && hexes.exists(end))
		{
			var listOfVertices = pathfinder.findPath(start, end);
			for (vert in listOfVertices)
				centers.add(hexes.get(vert).center);
		}
		return centers;
	}
	
	public function getRange(index:Int,rangeSize:Int,checkPassble:Bool):Map<Int,Int>
	{
		if (hexes.exists(index))
			return bfs.findRange(new Vertex(index), rangeSize, checkPassble);
		else
			return new Map<Int,Int>();
	}
	
	public function getManhatanDistance(start:Int,end:Int):Float
	{
		return HexCoordinates.getManhatanDistance(getHexByIndex(start).getCoor(), getHexByIndex(end).getCoor());
	}
	
}