package game;
import flixel.FlxState;

/**
 * ...
 * @author ...
 */
class Creature
{
	public var sprite:CreatureSprite;
	public var x:Int;
	public var y:Int;
	
	public function new(sprite:CreatureSprite,x:Int = 0,y:Int = 0)
	{
		this.x = x;
		this.y = y;
		this.sprite = sprite;
	}
	
	public function addCreatureToState(stateToAdd:FlxState)
	{	
		stateToAdd.add(sprite);
		sprite.setPosition(x, y);
	}
	
}