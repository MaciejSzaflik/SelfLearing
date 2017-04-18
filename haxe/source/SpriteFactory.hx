package source;
import data.SpriteDefinition;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import game.Creature;
import game.CreatureLabel;
import game.CreatureSprite;
import hex.HexTopping;
import hex.HexUtilites;
using flixel.util.FlxSpriteUtil;

class SpriteFactory
{
	public static var instance(get, null):SpriteFactory;
	private static function get_instance():SpriteFactory {
        if(instance == null) {
            instance = new SpriteFactory();
        }
        return instance;
    }
	private function new() 
	{
	}
	
	public function getPortraitPath(creatureName:String):String
	{
		return "assets/images/" + creatureName + "_portrait.png";
	}
	public function createNewPortrait(creatureName:String):FlxSprite
	{
		var sprite = new FlxSprite(100,100);
		sprite.loadGraphic(getPortraitPath(creatureName), false, 64, 64, false);
		return sprite;
	}
	public function createHourglass():FlxSprite
	{
		var sprite = new FlxSprite(60, 60);
		sprite.loadGraphic("assets/images/hourglass.png", false, 36, 57, true);
		return sprite;
	}
	
	
	public function createNewLabel():CreatureLabel
	{
		var sprite = new FlxSprite();
		sprite.makeGraphic(25, 13, 0xff999999);
		var text = new FlxText();
		text.size = 10;
		text.setBorderStyle(FlxTextBorderStyle.OUTLINE_FAST, 0xff000000);
		return new CreatureLabel(text,sprite);
	}
	
	public function createNewLayer(groupToAdd:FlxTypedGroup<FlxSprite>):FlxSprite
	{
		var canvas = new FlxSprite();
		canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		addToStateAndGroup(canvas, groupToAdd);
		return canvas;
	}
	
	public function createHexSprite(groupToAdd:FlxTypedGroup<FlxSprite>,size : Int, hextTopping : HexTopping,color:FlxColor):FlxSprite
	{
		var sprite = new FlxSprite();
		sprite.makeGraphic(size, size, FlxColor.TRANSPARENT, true);
		sprite.drawPolygon(HexUtilites.getHexPoints(new FlxPoint(size/2,size/2), size, hextTopping), color);	
		addToStateAndGroup(sprite, groupToAdd);
		return sprite;
	}
	
	public function createNewCreature(spriteDef:SpriteDefinition):CreatureSprite
	{
		var creature = new CreatureSprite(spriteDef);
		creature.InitGraphic();
		return creature;
	}
	private function addToStateAndGroup(sprite:FlxSprite, groupToAdd:FlxTypedGroup<FlxSprite>)
	{
		groupToAdd.add(sprite);
	}
	
	
}