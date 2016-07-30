package hex;

import flash.display3D.IndexBuffer3D;
import flixel.math.FlxPoint;

class RectangleHexMap extends HexMap
{
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
	
	public function new(mapCenter:FlxPoint, hexSize:Float,width:Int,height:Int) 
	{
		super(mapCenter, hexSize);
		this.width = width;
		this.height = height; 
		
	}
	
	override public function InitPoints() 
	{
		resetLists();
		CalculatePoints();
	}
	
	private function CalculatePoints():Void
	{
		var i = 0;
		while(i<width)
		{
			var j = 0;
			while(j<height)
			{
				var hexCoordinates = HexCoordinates.fromOddR(j, i);
				var hexIndex = hexCoordinates.toKey();
				
				var hex = new Hex(getHexCenterByAxialCor(hexCoordinates), hexCoordinates);
				hexes.set(hexIndex,hex);

				
				precalculatedPoints.add(HexUtilites.getHexPoints(
						hex.center,
						hexSize,
						topping));	
				
				if (j < height - 1)
				{
					hexCoordinates = HexCoordinates.fromOddR(j+1, i);
					graphConnections.addConnection(hexIndex, hexCoordinates.toKey());
				}
				if (i < width - 1)
				{
					hexCoordinates = HexCoordinates.fromOddR(j, i+1);
					graphConnections.addConnection(hexIndex, hexCoordinates.toKey());
				}
				if (i < width - 1 && j < height -1 && j % 2 == 1)
				{
					hexCoordinates = HexCoordinates.fromOddR(j+1, i+1);
					graphConnections.addConnection(hexIndex, hexCoordinates.toKey());
				}
				if (i > 0 && j < height -1 && j % 2 == 0)
				{
					hexCoordinates = HexCoordinates.fromOddR(j+1, i-1);
					graphConnections.addConnection(hexIndex, hexCoordinates.toKey());
				}					

				j++;
			}
			i++;
		}
	}
	
}