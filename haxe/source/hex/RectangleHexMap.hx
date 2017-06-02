package hex;

import flash.display.InteractiveObject;
import flash.display3D.IndexBuffer3D;
import flixel.FlxG;
import flixel.math.FlxPoint;
import graph.BreadthFirstSearch;
import graph.Graph;
import libnoise.generator.Perlin;
import thx.Set;
import utilites.IntPair;
import libnoise.QualityMode;
import source.BoardMap;
import utilites.UtilUtil;


class RectangleHexMap extends HexMap
{		
	var waterLevel:Float;
	var type : TestMapType;
	public function new(mapCenter:FlxPoint, hexSize:Float,width:Int,height:Int,waterLevel:Float,type : TestMapType) 
	{
		super(mapCenter, hexSize);
		this.width = width;
		this.height = height; 
		this.waterLevel = waterLevel;
		this.type = type;
	}
	
	override public function InitPoints() 
	{
		graphConnections = new Graph();
		resetLists();
		//CalculatePoints();
		
		
		switch(type)
		{
			case TestMapType.Small:
				TestSmallestMap();
			case TestMapType.Medium:
				TestMediumMap();
			case TestMapType.Large:
				TestLargeMap();
			case TestMapType.None:
				CalculatePoints();
		}
		
	}
	
	private function TestSmallestMap()
	{
		var smallSet = Set.createInt([4,11]);
		this.width = 4;
		this.height = 3; 
		this.waterLevel = 1;
		CalculatePoints(smallSet);
	}
	
	private function TestMediumMap()
	{
		var smallSet = Set.createInt([20, 19, 26, 25,
		15, 16, 22, 21,
		12512506,9 ,47 ,38]);
		this.width = 9;
		this.height = 6; 
		this.waterLevel = 1;
		CalculatePoints(smallSet);
	}
	
	private function TestLargeMap()
	{
		var smallSet = Set.createInt([33, 41, 50, 42, 51,
		47, 57, 46,27,71,12527521,12532528,
		12,18,84,33]);
		this.width = 12;
		this.height = 9; 
		this.waterLevel = 1;
		CalculatePoints(smallSet);
	}
	
	private function CalculatePoints(restrictedPoints : Set<Int> = null):Void
	{
		var frequency = 0.01;
		var lacunarity = 1.0;
		var persistence = 0.1;
		var octaves = 2;
		var seed = Random.int(100,20000);
		var quality = LOW;
		var testName = "perlin";
		var module = new Perlin(frequency, lacunarity, persistence, octaves, seed, quality);
		
		var i = 0;
		var temporaryHexmap = new Map<Int,Hex>();
		var toRemove = new Map<Int,Bool>();
		while(i<width)
		{
			var j = 0;
			while(j<height)
			{
				var hexCoordinates = HexCoordinates.fromOddR(j, i);
				var hexIndex = hexCoordinates.toKey();
				
				var hex = new Hex(getHexCenterByAxialCor(hexCoordinates), hexCoordinates);
				temporaryHexmap.set(hexIndex, hex);
				
				var possibleEdges = new Array<IntPair>();
						
				if (j < height - 1)
					possibleEdges.push(new IntPair(1, 0));
				if (i < width - 1)
					possibleEdges.push(new IntPair(0, 1));
				if (i < width - 1 && j < height -1 && j % 2 == 1)
					possibleEdges.push(new IntPair(1, 1));
				if (i > 0 && j < height -1 && j % 2 == 0)
					possibleEdges.push(new IntPair(1, -1));
				
				for(iter in 0 ... possibleEdges.length)
					addEdge(hexIndex, j, i, possibleEdges[iter]);
				j++;
				
				var noiseValue = getGreyValue(module.getValue(hex.center.x,hex.center.y, 0))/255;
				if (noiseValue > this.waterLevel  || (restrictedPoints!=null && restrictedPoints.exists(hexIndex)))
				{
					toRemove.set(hexIndex,true);
				}
				
			}
			i++;
		}

		graphConnections.createSubgrafFromVertices(toRemove, true);
		
		removeIslands();
		for (vertex in graphConnections.adjacencyList.keys())
			AddCenterOfHex(vertex, temporaryHexmap.get(vertex));
		for (vertex in graphConnections.removedVertices.keys())	
			AddCenterOfHex(vertex, temporaryHexmap.get(vertex));
	}
	
	private function AddCenterOfHex(vertex: Int, hex: Hex)
	{
		hexes.set(vertex, hex);
		precalculatedPoints.add(HexUtilites.getHexPoints(hex.center,hexSize,topping));
	}
	
	private function getGreyValue(val : Float) {
		var val = Std.int(128 * (val + 1));
		return val > 255 ? 255 : val < 0 ? 0 : val;
	}
	
	private function addEdge(hexIndex : Int,j : Int, i : Int, offset : IntPair)
	{
		var hexCoordinates = HexCoordinates.fromOddR(j+offset.left, i+offset.right);
		graphConnections.addConnection(hexIndex, hexCoordinates.toKey());
	}
	
	private function removeIslands()
	{
		var searchBFS = new BreadthFirstSearch(graphConnections);
		var islands = new Array<Map<Int,Int>>();
		var max = -1;
		var maxIndex = -1;
		var index = 0;
		for (vertex in graphConnections.adjacencyList.keys())
		{
			var inAny = false;
			for (map in islands)
			{
				if (map.exists(vertex))
				{
					inAny = true;
					break;
				}
			}
			if (!inAny)
			{
				islands.push(searchBFS.findRange(graphConnections.getVertices().get(vertex), 999, false));
				
				islands[index].set(vertex, vertex);
				var count = UtilUtil.CountMap(islands[index]);
				
				if (count > max)
				{
					max = count;
					maxIndex = index;
				}
				index++;
			}
		}
		index = 0;
		for (island in islands)
		{
			if (index != maxIndex)
			{
				graphConnections.createSubgrafFromVertices(island, true);
			}
			index++;
		}
	}
	
}