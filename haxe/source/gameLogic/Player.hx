package gameLogic;
import flixel.util.FlxColor;
import game.Creature;

/**
 * ...
 * @author ...
 */
class Player
{
	public var id(default, null):Int;
	public var color:FlxColor;
	public var creatures:Array<Creature>;
	public function new(id:Int,creatures:Array<Creature>,color:FlxColor) 
	{
		this.id = id;
		this.color = color;
		this.creatures = creatures;
		for (creature in creatures)
		{
			creature.idPlayerId = id;
			creature.label.setLabelColor(color);
		}
	}
	
}