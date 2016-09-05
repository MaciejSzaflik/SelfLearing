package source;
import data.SpriteDefinition;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import game.Creature;
import game.CreatureLabel;
import game.CreatureSprite;

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
	
	public function createNewPortrait(creatureName:String):FlxSprite
	{
		var sprite = new FlxSprite(100,100);
		sprite.loadGraphic("assets/images/"+creatureName+"_portrait.png", false, 64, 64, false);
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
	
	public function createNewLayer(stateToAdd:FlxState, groupToAdd:FlxTypedGroup<FlxSprite>):FlxSprite
	{
		var canvas = new FlxSprite();
		canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		addToStateAndGroup(canvas, stateToAdd, groupToAdd);
		return canvas;
	}
	
	public function createNewCreature(spriteDef:SpriteDefinition):CreatureSprite
	{
		var creature = new CreatureSprite(spriteDef);
		creature.InitGraphic();
		return creature;
	}
	private function addToStateAndGroup(sprite:FlxSprite,stateToAdd:FlxState, groupToAdd:FlxTypedGroup<FlxSprite>)
	{
		groupToAdd.add(sprite);
		stateToAdd.add(sprite);
	}
	
	
}