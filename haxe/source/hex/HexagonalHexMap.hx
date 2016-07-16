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
					hexes.add(new Hex(
						getHexCenterByAxialCor(new HexCoordinates(i,j)),
						new HexCoordinates(i,j)
					));

					precalculatedPoints.add(HexUtilites.getHexPoints(
							hexes.last().center,
							hexSize,
							topping));	
				}
				j++;
			}
			i++;
		}
	}
}