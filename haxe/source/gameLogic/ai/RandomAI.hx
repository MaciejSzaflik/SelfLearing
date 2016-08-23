package gameLogic.ai;
import gameLogic.moves.MoveData;
import gameLogic.moves.MoveType;

/**
 * ...
 * @author 
 */
class RandomAI extends ArtificialInteligence
{

	public function new() 
	{
		super();
		
	}
	
	override public function generateMove():MoveData 
	{
		var listOfMoves = GameContext.instance.generateMovesForCurrentCreature();
		if(listOfMoves.moves.length > 0)
			return Random.fromIterable(listOfMoves.moves);
		else
			return new MoveData(MoveType.Pass, -1);
	}
	
}