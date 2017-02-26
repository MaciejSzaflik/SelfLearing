package gameLogic.ai.evaluation;
import gameLogic.ai.EnemyQueue;

/**
 * ...
 * @author ...
 */
class EnemySelectEvaluation implements EvaluationMethod
{
	public static inline var rewardForEnemyPosition = 100;
	
	var enemyQueue : EnemyQueue;
	
	public function new(enemyQueue : EnemyQueue) 
	{
		this.enemyQueue = enemyQueue;
	}
	
	public function evaluateMoves(listOfMoves:ListOfMoves):EvaluationResult 
	{
		var distanceToCreature;
		var result = new EvaluationResult(listOfMoves);
		this.currentCreature = GameContext.instance.currentCreature;
		
		
		
		
	}
	
	
	
}