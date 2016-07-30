package gameLogic;
import game.Creature;

/**
 * ...
 * @author ...
 */
class Player
{
	public var id(default, null):Int;
	public var creatures:List<Creature>;
	public function new(id:Int,creatures:List<Creature>) 
	{
		this.id = id;
		this.creatures = creatures;
	}
	
}