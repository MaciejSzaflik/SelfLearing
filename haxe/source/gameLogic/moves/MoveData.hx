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
	public var performer:Creature;
	public var affected:Creature;
	
	public function new(type:MoveType,tileId:Int) 
	{
		//this.performer = performer;
		this.type = type;
		this.tileId = tileId;
	}
	
	static public function createAttackMove(type:MoveType,tileId:Int,creature:Creature):MoveData
	{
		var move = new MoveData(type, tileId);
		move.affected = creature;
		return move;
	}
	
	public function getId():String
	{
		return Std.string(tileId);
	}
}