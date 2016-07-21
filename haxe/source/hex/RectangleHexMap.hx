package hex;

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
				j++;
				hexIndex++;
			}
			i++;
		}
	}
	
}