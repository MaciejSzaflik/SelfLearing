package gameLogic;
import flixel.input.FlxPointer;
import flixel.math.FlxPoint;
import hex.HexCoordinates;
import utilites.InputType;

/**
 * ...
 * @author 
 */
class Input
{
	public var coor:HexCoordinates;
	public var hexCenter:FlxPoint;
	public var rawPosition:FlxPoint;
	public var type:InputType;
	public function new(type:InputType,hexCenter:FlxPoint,rawPosition:FlxPoint,coor:HexCoordinates) 
	{
		this.type = type;
		this.rawPosition = rawPosition;
		this.coor = coor;
		this.hexCenter = hexCenter;
	}
	
	public function getKey():String
	{
		return Std.string(coor.toKey());
	}
	
}