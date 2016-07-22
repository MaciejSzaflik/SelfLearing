package hex;

import flash.display3D.IndexBuffer3D;
import flixel.math.FlxPoint;

class RectangleHexMap extends HexMap
{
	private var width:Int;
	private var height:Int;
	
	
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
		var hexIndex = 0;
		while(i<width)
		{
			var j = 0;
			while(j<height)
			{
				var hex = new Hex(getHexCenterByAxialCor(HexCoordinates.fromOddR(j, i)), new HexCoordinates(i, j));
				hexes.set(hexIndex,hex);

				precalculatedPoints.add(HexUtilites.getHexPoints(
						hex.center,
						hexSize,
						topping));	
				
				if(j < height - 1)
					graphConnections.addConnection(hexIndex, hexIndex + 1);
					
				if(i < width - 1)
					graphConnections.addConnection(hexIndex, hexIndex + height);
					
				if(i < width - 1 && j <height -1 && j%2 == 1)
					graphConnections.addConnection(hexIndex, hexIndex + height + 1);
					
				if(i > 0 && j <height -1 && j%2 == 0)
					graphConnections.addConnection(hexIndex, hexIndex - height + 1);
					
				if(i < width - 1 && j > 0)
					graphConnections.addConnection(hexIndex, hexIndex -1);
					
				j++;
				hexIndex++;
			}
			i++;
		}
	}
	
}