package gameLogic.moves;

/**
 * ...
 * @author 
 */
class MoveMove extends Move
{
	public var tileId:Int;
	public function new(type:MoveType,tileId:Int) 
	{
		super(type);
		this.tileId = tileId;
	}
	
}