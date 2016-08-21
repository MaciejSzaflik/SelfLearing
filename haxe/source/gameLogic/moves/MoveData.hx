package gameLogic.moves;
import game.Creature;

/**
 * ...
 * @author 
 */
class MoveData
{
	public var type:MoveType;
	public var tileId:Int;
	public var attacked:Creature;
	
	public function new(type:MoveType,tileId:Int) 
	{
		this.type = type;
		this.tileId = tileId;
	}
	
	static public function createAttackMove(type:MoveType,tileId:Int,creature:Creature):MoveData
	{
		var move = new MoveData(type, tileId);
		move.attacked = creature;
		return move;
	}
	
	public function getId():String
	{
		return Std.string(tileId);
	}
}