package hex;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import graph.BreadthFirstSearch;
import graph.DjikstraPath;
import graph.Graph;
import graph.Pathfinder;
import graph.Vertex;
import hex.Hex;
import libnoise.generator.Perlin;
import libnoise.QualityMode;
import source.BoardMap;
import utilites.MathUtil;
using flixel.util.FlxSpriteUtil;

class HexMap extends BoardMap
{
	public var precalculatedPoints:List<Array<FlxPoint>>;
	private var hexes:Map<Int,Hex>;
	private var graphConnections:Graph;
	private var topping:HexTopping;
	private var mapCenter:FlxPoint;
	private var bfs:BreadthFirstSearch;
	private var pathfinder:Pathfinder;
	private var backgroundSprite:FlxSprite;
		
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
	
	public function reInitFinders()
	{
		bfs = new BreadthFirstSearch(graphConnections);
		pathfinder = new DjikstraPath(graphConnections);
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
		var q =  ((position.x*Math.sqrt(3))/3 - position.y/3)/hexSize*2;
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
	
	public function getArrayOfPoints(graph:Graph):List<FlxPoint>
	{
		var edges = graph.getListOfEdges();
		var listOfPoints = new List<FlxPoint>();
		for (edge in edges)
		{
			if (hexes.exists(edge.left) && hexes.exists(edge.right))
			{
				listOfPoints.add(hexes.get(edge.left).center);
				listOfPoints.add(hexes.get(edge.right).center);
			}
			
		}
		return listOfPoints;
	}
	
	public function getPathTiles(start:Int, ends:Array<Int>):Array<Int>
	{
		return pathfinder.findPathMultipleEnds(start, ends);
	}
	
	public function getPathCenters(start:Int, end:Int):List<FlxPoint>
	{
		var centers = new List<FlxPoint>();
		if (hexes.exists(start) && hexes.exists(end))
		{
			var listOfVertices = pathfinder.findPath(start, end);
			if (listOfVertices == null )
				return null;
			for (vert in listOfVertices)
				centers.add(hexes.get(vert).center);
		}
		return centers;
	}
	
	public function getNeighborsArray(index,ignorePassable : Bool = false):Array<Int>
	{
		var toReturn = new Array<Int>();
		for (value in graphConnections.getConnected(index))
		{
			if(graphConnections.isThisVerPassable(value) || ignorePassable)
				toReturn.push(value);
		}
		return toReturn;
	}
	
	public function getNeighbors(index,ignorePassable : Bool = false):Map<Int,Int>
	{
		var toReturn = new Map<Int, Int>();
		for (value in graphConnections.getConnected(index))
		{
			if(graphConnections.isThisVerPassable(value) || ignorePassable)
				toReturn.set(value, value);
		}
		return toReturn;
	}
	
	public function findRangeNoObstacles(center:Int, N : Int):Map<Int,Int>
	{
		
		var results = new Map<Int,Int>();
		if (!hexes.exists(center))
			return results;
		
		var coor = hexes.get(center).getCoor();
				
		for (dx in -N...N+1)
		{
			for (dy in MathUtil.max(-N,-dx-N)...MathUtil.min(N,-dx+N)+1)
			{
				var key = coor.addAxial(dx, -dx - dy).toKey();
				if(hexes.exists(key))
					results[key] = key;
			}
		}
		return results;
	}
	
	public function getRange(index:Int,rangeSize:Int,checkPassble:Bool):Map<Int,Int>
	{
		if (hexes.exists(index))
		{
			if (rangeSize == 1)
				return getNeighbors(index,!checkPassble);
			else
				return bfs.findRange(new Vertex(index), rangeSize, checkPassble);
		}
		else
			return new Map<Int,Int>();
	}
	
	public function getManhatanDistance(start:Int,end:Int):Float
	{
		return HexCoordinates.getManhatanDistance(getHexByIndex(start).getCoor(), getHexByIndex(end).getCoor());
	}
	
	public function DestroyBackground()
	{
		if (backgroundSprite != null)
			backgroundSprite.destroy();
	}
	
	public function createBackground()
	{
		backgroundSprite = new FlxSprite(0, 0);
		var sprite = new FlxSprite(0, 0);
		backgroundSprite.makeGraphic(FlxG.width, FlxG.height, 0x00000000);
		
		for (hex in hexes)
		{	
			var value = graphConnections.GetNumberOfConnections(hex.getIndex());
			if (value > 0)
			{
				sprite.loadGraphic("assets/images/hex_dirt_" + value +".png", false, 51, 51);
			}
			else
			{
				value = graphConnections.subGraph.GetNumberOfConnections(hex.getIndex());
				sprite.loadGraphic("assets/images/hex_water_"+ value +".png", false, 51, 51);
			}

			sprite.setPosition(hex.center.x - 51 / 2, hex.center.y - 51 / 2);
			sprite.scale.set((hexSize-1) / 51.0, (hexSize-1) / 51.0);
			var x = Std.int(sprite.getPosition().x);
			var y = Std.int(sprite.getPosition().y);
			backgroundSprite.stamp(sprite, x, y);
		}
		sprite.destroy();
		MainState.getInstance().add(backgroundSprite);
	}
	
	public function findMaxXHex()
	{
		var maximum = -10000;
		var maxIndex = 0;
		for (key in hexes.keys())
		{
			var hex = hexes.get(key);
			if (hex.getSumOfCoordinates() > maximum && this.graphConnections.isThisVerPassable(hex.getIndex()))
			{
				maximum = hex.getSumOfCoordinates();
				maxIndex = key;
			}
		}
		return hexes.get(maxIndex);
	}
	public function findMinXHex():Hex
	{
		var minimum = 10000;
		var minIndex = 0;
		for (key in hexes.keys())
		{
			var hex = hexes.get(key);
			if (hex.getSumOfCoordinates() < minimum && this.graphConnections.isThisVerPassable(hex.getIndex()))
			{
				minimum = hex.getSumOfCoordinates();
				minIndex = key;
			}
		}
		return hexes.get(minIndex);
	}
}