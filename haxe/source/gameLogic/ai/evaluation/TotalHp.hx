package gameLogic.ai.evaluation;
import game.Creature;
import gameLogic.moves.ListOfMoves;
import gameLogic.ai.evaluation.EvaluationResult;

/**
 * ...
 * @author 
 */
class TotalHp implements EvaluationMethod
{

	public function new() 
	{
		
	}
	
	/* INTERFACE gameLogic.ai.evaluation.EvaluationMethod */
	
	public function evaluateMoves(listOfMoves:ListOfMoves):EvaluationResult 
	{
		return null;
	}
	
	public function calculateTotalHp(playerId:Int):Int
	{
		var totalHp = 0;
		for (creature in GameContext.instance.mapOfPlayers.get(playerId).creatures)
		{
				if (creature != null)
					totalHp += creature.totalHealth;
		}
		return totalHp;
	}
}