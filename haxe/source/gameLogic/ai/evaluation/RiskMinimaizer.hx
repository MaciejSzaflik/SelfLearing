package gameLogic.ai.evaluation;
import animation.MoveBetweenPoints;
import gameLogic.actions.ActionFactory;
import gameLogic.moves.ListOfMoves;
import gameLogic.ai.evaluation.EvaluationResult;
import utilites.IntPair;
import utilites.MathUtil;

/**
 * ...
 * @author
 */
class RiskMinimaizer implements EvaluationMethod
{

	public function new()
	{

	}

	public function evaluateMoves(listOfMoves:ListOfMoves):EvaluationResult
	{
		var riskByDistance = new RiskByDistance();
		var result = new EvaluationResult(listOfMoves);
		var listOfMoves = GameContext.instance.generateListOfMovesForCreature(GameContext.instance.currentCreature);
		
		var valueMin = 10000000.0;
		var indexMin = -1;
		var index = 0;
		
		for (move in listOfMoves.moves)
		{
			var action = ActionFactory.actionFromMoveData(move, null);
			action.performAction();

			var riskValues = riskByDistance.evaluateBoard(
				GameContext.instance.map,
				GameContext.instance.currentCreature,
				GameContext.instance.getEnemies(GameContext.instance.currentPlayerIndex));
			if(riskValues.sum < valueMin)
			{
				valueMin = riskValues.sum;
				indexMin = index;
			}
			index++;
			GameContext.instance.undoNextAction();
		}
		result.tryToSetBestIndex(indexMin);
		return result;

	}

}