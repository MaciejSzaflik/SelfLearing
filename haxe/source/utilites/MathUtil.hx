package utilites;
import flixel.math.FlxPoint;
import haxe.Constraints.FlatEnum;

/**
 * ...
 * @author ...
 */
class MathUtil
{

	static inline public function lerp(a:Float,b:Float,t:Float):Float
	{
		return a + t * (b - a);
	}
	
	static inline public function lerpPoints(a:FlxPoint,b:FlxPoint,t:Float):FlxPoint
	{
		return new FlxPoint(lerp(a.x, b.x, t), lerp(a.y, b.y, t));
	}
	
	static inline public function clamp01(value:Float):Float
	{
		return clamp(value, 0, 1);
	}
	
	static inline public function clamp(value:Float, min:Float, max:Float) :Float
	{
		return Math.max(Math.min(value, max), min);
	}
	
	static inline public function max(a:Int, b:Int)
	{
		return a > b ? a : b;
	}
	
	static inline public function min(a:Int, b:Int)
	{
		return a > b ? b : a;
	}
	
	public function new() 
	{
		
	}
	
}