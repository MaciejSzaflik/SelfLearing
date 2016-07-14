package source;
import flixel.math.FlxPoint;

class HexUtilites
{
	static public function getHexPoints(center:FlxPoint, radius:Float, topping:HexTopping):Array<FlxPoint>
	{
		if(topping == HexTopping.Pointy)
			return getPointyToppedHexPoints(center,radius);
		else
			return getFlatToppedHexPoints(center,radius);
	}
	
	static private function getPointyToppedHexPoints(center:FlxPoint, radius:Float):Array<FlxPoint>
	{
		return [
			new FlxPoint(center.x -0.5*radius,center.y +0.25*radius),
			new FlxPoint(center.x             ,center.y +0.5*radius),
			new FlxPoint(center.x +0.5*radius,center.y +0.25*radius),
			new FlxPoint(center.x +0.5*radius,center.y -0.25*radius),
			new FlxPoint(center.x             ,center.y -0.5*radius),
			new FlxPoint(center.x -0.5 * radius, center.y -0.25 * radius),
			new FlxPoint(center.x -0.5*radius,center.y +0.25*radius)
		];
	}
	
	static private function getFlatToppedHexPoints(center:FlxPoint, radius:Float):Array<FlxPoint>
	{
		return [
			new FlxPoint(center.x -0.5*radius,center.y),
			new FlxPoint(center.x -0.25*radius,center.y +0.5*radius),
			new FlxPoint(center.x +0.25*radius,center.y +0.5*radius),
			new FlxPoint(center.x +0.5*radius,center.y),
			new FlxPoint(center.x +0.25*radius,center.y -0.5*radius),
			new FlxPoint(center.x -0.25 * radius, center.y -0.5 * radius),
			new FlxPoint(center.x -0.5*radius,center.y)
		];
	}
}