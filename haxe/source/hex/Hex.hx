package hex;

import flixel.math.FlxPoint;

class Hex
{
	public var center:FlxPoint;
	private var coor:HexCoordinates;
	private var index:Int;
	
	public function new(center:FlxPoint, coor:HexCoordinates) 
	{
		this.center = center;
		this.coor = coor;
	}
	
	public function getIndex():Int
	{
		return coor.toKey();
	}
	
	public function toString():String
	{
		return coor.toString();
	}
	
}