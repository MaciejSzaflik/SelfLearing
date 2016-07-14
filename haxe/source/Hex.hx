package source;

import flixel.math.FlxPoint;

class Hex
{
	public var center : FlxPoint;
	private var coor : Coordinates;
	
	public function new(center:FlxPoint, coor:Coordinates) 
	{
		this.center = center;
		this.coor = coor;
	}
	
	public function toString() : String
	{
		return coor.toString();
	}
	
}