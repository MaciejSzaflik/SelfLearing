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
		while(i<width)
		{
			var j = 0;
			while(j<height)
			{
				hexes.add(new Hex(
					getHexCenterByAxialCor(HexCoordinates.fromOddR(j,i)),
					new HexCoordinates(i,j)
				));

				precalculatedPoints.add(HexUtilites.getHexPoints(
						hexes.last().center,
						hexSize,
						topping));	
				j++;
			}
			i++;
		}
	}
	
}