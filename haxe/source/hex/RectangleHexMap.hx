package hex;

import flash.display3D.IndexBuffer3D;
import flixel.FlxG;
import flixel.math.FlxPoint;
import graph.BreadthFirstSearch;
import graph.Graph;
import libnoise.generator.Perlin;
import utilites.IntPair;
import libnoise.QualityMode;
import source.BoardMap;
import utilites.UtilUtil;


class RectangleHexMap extends HexMap
{	
	var waterLevel:Float;
	public function new(mapCenter:FlxPoint, hexSize:Float,width:Int,height:Int,waterLevel:Float) 
	{
		super(mapCenter, hexSize);
		this.width = width;
		this.height = height; 
		this.waterLevel = waterLevel;
	}
	
	override public function InitPoints() 
	{
		graphConnections = new Graph();
		resetLists();
		CalculatePoints();
	}
	
	private function CalculatePoints():Void
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
				if (noiseValue > this.waterLevel)
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