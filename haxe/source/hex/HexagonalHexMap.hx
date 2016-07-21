package hex;

import flixel.math.FlxPoint;

class HexagonalHexMap extends HexMap
{
	private var radius:Int;
	public function new(mapCenter:FlxPoint, hexSize:Float,radius:Int) 
	{
		super(mapCenter, hexSize);
		this.radius = radius;
	}
	
	override public function InitPoints() 
	{
		resetLists();
		CalculatePoints();
	}
	
	private function CalculatePoints():Void
	{
		var hexIndex = 0;
		var i = -radius;
		while(i<=radius)
		{
			var j = -radius;
			while(j<=radius)
			{
				if(i+j > radius || i+j < -radius)
				{
				}
				else
				{
					var hex = new Hex(getHexCenterByAxialCor(new HexCoordinates(i, j)), new HexCoordinates(i, j));
					hexes.set(hexIndex,hex);

					precalculatedPoints.add(HexUtilites.getHexPoints(hex.center,hexSize,topping));	
					hexIndex++;
				}
				j++;
			}
			i++;
		}
	}
}