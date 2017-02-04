package source;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.FlxSort;
import game.Creature;
import hex.HexMap;
import hex.HexTopping;
import hex.HexUtilites;
using flixel.util.FlxSpriteUtil;

class Drawer
{
	private var layersBackground : FlxTypedGroup<FlxSprite>;
	private var creatureGroup : FlxTypedGroup<FlxSprite>;
	private var labelsGroup : FlxTypedGroup<FlxSprite>;
	private var labelTextGroup : FlxTypedGroup<FlxText>;
	
	public function new(numberOfLayers:Int,stateToAdd:FlxState) 
	{
		this.layersBackground = new FlxTypedGroup<FlxSprite>();
		this.creatureGroup = new FlxTypedGroup<FlxSprite>();
		this.labelsGroup = new FlxTypedGroup<FlxSprite>();
		this.labelTextGroup = new FlxTypedGroup<FlxText>();
		
		for (i in 0...numberOfLayers)
			createNewLayer();
			
		stateToAdd.add(layersBackground);
		stateToAdd.add(creatureGroup);
		stateToAdd.add(labelsGroup);
		stateToAdd.add(labelTextGroup);
		
	}
	
	public function currentLayersInGroup()
	{
		for (layer in layersBackground)
		{
			trace(layer);
		}
	}
	
	public function AddToCreatureGroup(creature:Creature)
	{
		creatureGroup.add(creature.sprite);
		labelsGroup.add(creature.label.background);
		labelTextGroup.add(creature.label.text);
		
		
		creatureGroup.sort(FlxSort.byY,FlxSort.DESCENDING);
	}
	
	private function createNewLayer():FlxSprite
	{
		return SpriteFactory.instance.createNewLayer(this.layersBackground);
	}
	
	public function drawListOfLines(listOfLines:List<FlxPoint>, lineColor:FlxColor, layer:Int):Void
	{
		while (!listOfLines.isEmpty())
		{
			drawLine(listOfLines.pop(), listOfLines.pop(), lineColor, layer);
		}
	}
	
	public function drawLine(begin:FlxPoint, end:FlxPoint, lineColor:FlxColor, layer:Int):Void
	{
		var lineStyle = { color: lineColor, thickness: 1.0 };
		this.layersBackground.members[layer].drawLine(begin.x, begin.y, end.x, end.y,lineStyle);
	}
	
	public function drawCircle(center:FlxPoint, radius:Float, fillColor:FlxColor, layer:Int) : Void
	{
		var lineStyle = { color: fillColor, thickness: 1.0 };
		this.layersBackground.members[layer].drawCircle(center.x,center.y,radius,lineStyle);
	}
	
	public function drawHex(center:FlxPoint, radius:Float, hexTopping:HexTopping, fillColor:FlxColor, layer:Int) : Void
	{
		this.layersBackground.members[layer].drawPolygon(HexUtilites.getHexPoints(center, radius, hexTopping),fillColor);
	}
	public function clear(layer:Int)
	{
		this.layersBackground.members[layer].fill(FlxColor.TRANSPARENT);
	}
	
	public function drawHexMap(map:HexMap,lineColor : FlxColor,fillcolor : FlxColor,layer:Int) : Void
	{
		var lineStyle = { color: lineColor, thickness: 1.0 };
		for (array in map.precalculatedPoints)
		{
			this.layersBackground.members[layer].drawPolygon(array,fillcolor,lineStyle);
		}
	}
	
}