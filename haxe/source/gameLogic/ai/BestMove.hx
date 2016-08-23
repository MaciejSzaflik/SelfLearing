package gameLogic.ai;
import gameLogic.ai.evaluation.EvaluationMethod;
import gameLogic.moves.MoveData;

/**
 * ...
 * @author 
 */
class BestMove extends ArtificialInteligence
{
	private var evaluationMethod:EvaluationMethod;
	public function new(evaluationMethod:EvaluationMethod) 
	{
		this.evaluationMethod = evaluationMethod;
		super();
	}
	
	override public function generateMove():MoveData 
	{
		var listOfMoves = GameContext.instance.generateMovesForCurrentCreature();
		return evaluationMethod.evaluateMoves(listOfMoves).getBestMove();
	}
	
}