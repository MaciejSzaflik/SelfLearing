package gameLogic.moves;
import game.Creature;

/**
 * ...
 * @author 
 */
class AttackMove extends Move
{
	public var attacked:Creature;
	public var tileId:Int;
	
	public function new(type:MoveType,creature:Creature,tileId:Int) 
	{
		super(type);
		this.attacked = creature;
		this.tileId = tileId;
	}
}