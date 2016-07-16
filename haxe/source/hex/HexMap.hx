package hex;
import flixel.math.FlxPoint;
import hex.Hex;
import source.BoardMap;

class HexMap extends BoardMap
{
	public var precalculatedPoints:List<Array<FlxPoint>>;
	private var hexes:List<Hex>;
	
	private var topping:HexTopping;
	private var mapCenter:FlxPoint;
	
	public var hexSize(get, set):Float;
	private var _hexSize:Float;
	function get_hexSize():Float {
		return _hexSize;
	}

	function set_hexSize(value:Float) {
		return _hexSize = value;
	}
	
	private var boardsType:BoardShape;
	
	public function new(mapCenter:FlxPoint, hexSize:Float) 
	{
		this.hexSize = hexSize;
		this.mapCenter = mapCenter;
		this.topping = HexTopping.Pointy;
		super();
	}
	public function InitPoints()
	{
		resetLists();
	}
	
	private function resetLists():Void
	{
		this.precalculatedPoints = new List<Array<FlxPoint>>();
		this.hexes = new List<Hex>();
	}
	
	public function positionToHex(rawPosition:FlxPoint):HexCoordinates
	{
		var position = new FlxPoint(rawPosition.x - mapCenter.x, -(rawPosition.y - mapCenter.y));
		var q =  (position.x*Math.sqrt(3)/3 - position.y/3)/hexSize*2;
		var r =  (position.y * (2/3))/hexSize*2;
		return HexUtilites.cubeRand(q,-q-r,r);	
	}
	
	public function hexToPosition(coor:HexCoordinates):FlxPoint
	{
		var x = hexSize * 2 * Math.sqrt(3) * (coor.q + coor.r / 2);
		var y = hexSize * 3 * coor.r;
		return new FlxPoint(x,y);
	}
	
	public function getHexCenterByAxialCor(coor:HexCoordinates):FlxPoint
	{
		return new FlxPoint(mapCenter.x + coor.q*hexSize + coor.r*hexSize*0.5,mapCenter.y - coor.r*hexSize*0.75);
	}
	
}