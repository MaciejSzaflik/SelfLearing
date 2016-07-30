package game;
import flixel.FlxState;
import flixel.math.FlxPoint;

/**
 * ...
 * @author ...
 */
class Creature
{
	public var sprite:CreatureSprite;
	public var x:Int;
	public var y:Int;
	
	public var initiative = 5;
	public var range = 5;
	
	public var idPlayerId:Int;
	
	public function new(sprite:CreatureSprite,x:Int = 0,y:Int = 0)
	{
		this.x = x;
		this.y = y;
		this.sprite = sprite;
	}
	
	public function setPosition(position:FlxPoint)
	{
		sprite.setPosition(position.x - getWidth()*0.5, position.y - getHeight()*0.5);
	}
	
	public function getHeight():Float
	{
		return sprite.height;
	}
	
	public function getWidth():Float
	{
		return sprite.width;
	}
	
	public function addCreatureToState(stateToAdd:FlxState)
	{	
		stateToAdd.add(sprite);
		sprite.setPosition(x, y);
	}
	
}