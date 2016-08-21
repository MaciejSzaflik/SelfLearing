package gameLogic.moves;

/**
 * ...
 * @author 
 */
class Move
{
	public var type:MoveType;
	public var tileId:Int;
	public function new(type:MoveType,tileId:Int) 
	{
		this.type = type;
		this.tileId = tileId;
	}
	
	public function getId():String
	{
		return Std.string(tileId);
	}
}