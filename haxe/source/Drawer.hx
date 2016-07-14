package source;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class Drawer
{
	private var canvas : FlxSprite;
	
	public function new(canvas:FlxSprite) 
	{
		this.canvas = canvas;
	}
	
	public function drawHex(center:FlxPoint, radius:Float, hexTopping:HexTopping) : Void
	{
		canvas.drawPolygon(HexUtilites.getHexPoints(center, radius, hexTopping));
	}
	
	public function drawHexMap(map:HexMap,lineColor : FlxColor,fillcolor : FlxColor) : Void
	{
		var lineStyle = { color: lineColor, thickness: 1.0 };
		for (array in map.precalculatedPoints)
		{
			canvas.drawPolygon(array,fillcolor,lineStyle);
		}
	}
	
}