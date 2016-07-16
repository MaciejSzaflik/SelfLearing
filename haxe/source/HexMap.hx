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
	
	public function positionToHex(rawPosition : FlxPoint) : Coordinates
	{
		var position = new FlxPoint(rawPosition.x - mapCenter.x, rawPosition.y - mapCenter.y);
		var q =  Std.int((position.x*Math.sqrt(3)/3 + position.y/3)/hexSize*2);
		var r =  Std.int(-((position.y)/hexSize*2));
		return new Coordinates(q,r);	
	}
	
	public function getHexCenterByAxialCor(coor : Coordinates) : FlxPoint
	{
		return new FlxPoint(mapCenter.x + coor.q*hexSize + coor.r*hexSize*0.5,mapCenter.y - coor.r*hexSize*0.75);
	}
	
}