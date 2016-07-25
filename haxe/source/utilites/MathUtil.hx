package utilites;
import flixel.math.FlxPoint;

/**
 * ...
 * @author ...
 */
class MathUtil
{

	static public function lerp(a:Float,b:Float,t:Float):Float
	{
		return a + t * (b - a);
	}
	
	static public function lerpPoints(a:FlxPoint,b:FlxPoint,t:Float):FlxPoint
	{
		return new FlxPoint(lerp(a.x, b.x, t), lerp(a.y, b.y, t));
	}
	
	public function new() 
	{
		
	}
	
}