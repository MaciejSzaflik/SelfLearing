package gameLogic.ai;
import gameLogic.moves.MoveData;

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
		var listOfMoves = GameContext.instance.generateListOfMovesForCreature(GameContext.instance.currentCreature);
		return Random.fromIterable(listOfMoves.moves);
	}
	
}