package source;
import flixel.math.FlxPoint;

class HexMap extends BoardMap
{
	public var precalculatedPoints : List<Array<FlxPoint>>;
	private var hexes : List<Hex>;
	
	private var radius : Int;
	private var topping : HexTopping;
	private var hexSize : Float;
	private var mapCenter : FlxPoint;
	
	public function new(mapCenter : FlxPoint, hexSize : Float, radius : Int) 
	{
		this.radius = radius;
		this.hexSize = hexSize;
		this.mapCenter = mapCenter;
		this.topping = HexTopping.Pointy;
		CalculatePointToppedPoints();
		super();
	}
	
	private function CalculatePointToppedPoints() : Void
	{
		precalculatedPoints = new List<Array<FlxPoint>>();
		hexes = new List<Hex>();
		var i = -radius;
		while(i<=radius)
		{
			trace(i);
			var j = -radius;
			while(j<=radius)
			{
				trace(j);
				if(i+j > radius || i+j < -radius)
				{
					trace("no");
				}
				else
				{
					hexes.add(new Hex(
						getHexCenterByAxialCor(new Coordinates(i,j)),
						new Coordinates(i,j)
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
		trace("end");
	}
	
	public function positionToHex(rawPosition:FlxPoint):Coordinates
	{
		var position = new FlxPoint(rawPosition.x - mapCenter.x, -(rawPosition.y - mapCenter.y));
		var q =  (position.x*Math.sqrt(3)/3 - position.y/3)/hexSize*2;
		var r =  (position.y * (2/3))/hexSize*2;
		return cubeRand(q,-q-r,r);	
	}
	
	public function cubeRand(hx:Float, hy:Float, hz:Float):Coordinates
	{
		var rx = Math.round(hx);
		var ry = Math.round(hy);
		var rz = Math.round(hz);
		
		var x_diff = Math.abs(rx - hx);
		var y_diff = Math.abs(ry - hy);
		var z_diff = Math.abs(rz - hz);
		
		if (x_diff > y_diff && x_diff > z_diff)
			rx = -ry - rz;
		else if (y_diff > z_diff)
			ry = -rx - rz;
		else
			rz = -rx - ry;
			
		return Coordinates.fromCube(rx, rz);
	}
	
	public function hexToPosition(coor:Coordinates):FlxPoint
	{
		var x = hexSize * 2 * Math.sqrt(3) * (coor.q + coor.r / 2);
		var y = hexSize * 3 * coor.r;
		return new FlxPoint(x,y);
	}
	
	public function getHexCenterByAxialCor(coor:Coordinates):FlxPoint
	{
		return new FlxPoint(mapCenter.x + coor.q*hexSize + coor.r*hexSize*0.5,mapCenter.y - coor.r*hexSize*0.75);
	}
	
}