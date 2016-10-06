package gameLogic.ai;
import gameLogic.ai.ArtificialInteligence;

/**
 * ...
 * @author 
 */
class MinMax extends ArtificialInteligence
{
	private var evaluationMethod:EvaluationMethod;
	private var maxDepth;
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