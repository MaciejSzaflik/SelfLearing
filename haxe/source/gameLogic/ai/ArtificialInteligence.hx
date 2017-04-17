package gameLogic.ai;
import gameLogic.ai.tree.TreeVertex;
import gameLogic.moves.MoveData;
import gameLogic.moves.MoveType;

/**
 * ...
 * @author 
 */
class ArtificialInteligence
{

	public function new() 
	{
		
	}
	
	public function generateMove():MoveData
	{
		return new MoveData(null,MoveType.Pass, -1);
	}
	
	public function generateMoveFuture():Array<MoveData> 
	{
		return null;
	}
	
}