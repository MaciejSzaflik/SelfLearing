package hex;
import flixel.math.FlxPoint;
import hex.HexTopping;

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
	
	static public function cubeRand(hx:Float, hy:Float, hz:Float):HexCoordinates
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
			
		return HexCoordinates.fromCube(rx, rz);
	}
}