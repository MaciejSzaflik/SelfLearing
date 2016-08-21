package gameLogic.ai;
import gameLogic.moves.Move;

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
	
	override public function generateMove():Move 
	{
		var listOfMoves = GameContext.instance.generateListOfMovesForCreature(GameContext.instance.currentCreature);
		return Random.fromIterable(listOfMoves.moves);
	}
	
}