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
	public var deadCreatures:Array<Creature>;
	public function new(id:Int,creatures:Array<Creature>,color:FlxColor) 
	{
		this.id = id;
		this.color = color;
		this.deadCreatures = new Array<Creature>();
		this.creatures = creatures;
		for (creature in creatures)
		{
			creature.idPlayerId = id;
			creature.label.setLabelColor(color);
		}
	}
	
	public function onCreatureKilled(killed:Creature)
	{
		if (killed.idPlayerId != id)
			return;
		
		creatures.remove(killed);
		deadCreatures.push(killed);
	}
	
	public var numberOfDead(get, never):Int;
	function get_numberOfDead():Int
	{
		return deadCreatures.length;
	}
	
	
}