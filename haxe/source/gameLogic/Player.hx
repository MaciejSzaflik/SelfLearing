package gameLogic;
import game.Creature;

/**
 * ...
 * @author ...
 */
class Player
{
	public var id(default, null):Int;
	public var creatures:Array<Creature>;
	public function new(id:Int,creatures:Array<Creature>) 
	{
		this.id = id;
		this.creatures = creatures;
	}
	
}