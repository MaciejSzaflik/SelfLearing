package source;
import data.SpriteDefinition;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import game.Creature;
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