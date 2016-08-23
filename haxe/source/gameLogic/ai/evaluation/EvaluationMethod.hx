package gameLogic.ai.evaluation;
import gameLogic.moves.ListOfMoves;

/**
 * @author 
 */
interface EvaluationMethod 
{
	function evaluateMoves(listOfMoves:ListOfMoves):EvaluationResult;
}