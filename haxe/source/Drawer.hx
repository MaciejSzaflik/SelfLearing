package source;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxG;
using flixel.util.FlxSpriteUtil;

class Drawer
{
	private var canvas : FlxSprite;
	private var layers : FlxTypedGroup<FlxSprite>;
	
	public function new(numberOfLayers:Int,stateToAdd:FlxState) 
	{
		this.layers = new FlxTypedGroup<FlxSprite>();
		for (i in 0...numberOfLayers)
		{
			this.layers.add(createNewLayer(stateToAdd));
		}
	}
	private function createNewLayer(stateToAdd:FlxState):FlxSprite
	{
		var canvas = new FlxSprite();
		canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		stateToAdd.add(canvas);
		return canvas;
	}
	
	public function drawHex(center:FlxPoint, radius:Float, hexTopping:HexTopping, fillColor:FlxColor, layer:Int) : Void
	{
		this.layers.members[layer].drawPolygon(HexUtilites.getHexPoints(center, radius, hexTopping),fillColor);
	}
	public function clear(layer:Int)
	{
		this.layers.members[layer].fill(FlxColor.TRANSPARENT);
	}
	
	public function drawHexMap(map:HexMap,lineColor : FlxColor,fillcolor : FlxColor,layer:Int) : Void
	{
		var lineStyle = { color: lineColor, thickness: 1.0 };
		for (array in map.precalculatedPoints)
		{
			this.layers.members[layer].drawPolygon(array,fillcolor,lineStyle);
		}
	}
	
}