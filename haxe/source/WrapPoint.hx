package source;
import flixel.math.FlxPoint;

class WrapPoint
{
	public var x(get, set):Float;
    public var y(get, set):Float;
	
	var _x:Float;
	var _y:Float;
	function get_x():Float {
		return _x;
	}

	function set_x(value:Float) {
		return _y = value;
	}
	
	function get_y():Float {
		return _y;
	}

	function set_y(value:Float) {
		return _y= value;
	}
	
	
	public function new(x:Float, y:Float) 
	{
		this.x = x;
		this.y = y;
	}

	static public function fromPoint(point:FlxPoint):WrapPoint
	{
		return new WrapPoint(point.x, point.y);
	}
	
	static public function toArray(array:Array<WrapPoint>):Array<FlxPoint>
	{
		var toReturn = new Array<FlxPoint>();
		for (point in array)
			toReturn.push(new FlxPoint(point.x,point.y));

		return toReturn;
	}
	
	static public function castArray(array:Array<FlxPoint>):Array<WrapPoint>
	{
		var toReturn = new Array<WrapPoint>();
		for (point in array)
			toReturn.push(WrapPoint.fromPoint(point));

		return toReturn;
	}
	
}