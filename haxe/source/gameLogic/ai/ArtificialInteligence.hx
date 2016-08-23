package gameLogic.ai;
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
		return new MoveData(MoveType.Pass, -1);
	}
	
}