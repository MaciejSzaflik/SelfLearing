package gameLogic.ai.evaluation;
import game.Creature;
import gameLogic.actions.Action;
import gameLogic.actions.ActionFactory;
import gameLogic.ai.EnemyQueue;
import gameLogic.moves.ListOfMoves;
import gameLogic.moves.MoveData;
import gameLogic.moves.MoveType;
import hex.HexCoordinates;
import utilites.UtilUtil;

/**
 * ...
 * @author ...
 */
class EnemySelectEvaluation implements EvaluationMethod
{
	public static inline var rewardForEnemyPosition = 100;
	
	var enemyQueue : EnemyQueue;
	var currentCreature : Creature;
	var moveToCost : Map<MoveData,Float>;
	var selectedEnemy : Int;
	
	public function new() 
	{
	}
	
	public function SetEnemyQueue(enemyQueue : EnemyQueue) 
	{
		this.enemyQueue = enemyQueue;
	}
	
	public function evaluateMoves(listOfMoves:ListOfMoves):EvaluationResult 
	{
		var distanceToCreature;
		var result = new EvaluationResult(listOfMoves);
		this.currentCreature = GameContext.instance.currentCreature;
		var pathToScore = tryToFindAPath(enemyQueue.enemies);
		var index = 0;
		for (move in listOfMoves.moves)
		{
			var value = 0;
			if (move.type == MoveType.Move)
			{
				value = scoreMove(pathToScore,move);
			}
			else if(move.type == MoveType.Attack)
			{
				var enemyValue = enemyQueue.enemiesValues.get(move.affected.id);
				var index = enemyQueue.enemies.length - UtilUtil.getIndexOf(enemyQueue.enemies, move.affected) + 1;
				var bonus = 0;
				if (currentCreature.isRanger)
					bonus += currentCreature.getTileId() == move.tileId ? 500 : -500;
				
				value = Std.int(enemyValue * index * rewardForEnemyPosition) + bonus;
			}
			result.evaluationResults[index] = value;
			result.tryToSetBestIndex(index);
			index++;
		}
		
		return result;
		
	}
	
	public function scoreMove(pathToScore: Map<Int,Int>,move : MoveData) : Int
	{
		if (pathToScore.exists(move.tileId))
		{
			var distanceToChar =  GameContext.instance.map.getManhatanDistance(currentCreature.getTileId(), move.tileId);
			var attackRangeBonus = distanceToChar <= currentCreature.attackRange ? 2.5 : 1.0;
			if (currentCreature.isRanger && distanceToChar == 1)
				attackRangeBonus = 0.25;
			return Std.int(pathToScore.get(move.tileId) * 10 * attackRangeBonus);
		}
		else
			return 0;
	}
	
	public function tryToFindAPath(enemies : Array<Creature>) : Map<Int,Int>
	{
		var toReturn = new Map<Int,Int>();
		var index = 0;
		for (enemy in enemies)
		{
			var path = GameContext.instance.map.getPathTiles(currentCreature.getTileId(),enemy.getEmptyNeighbours());
			if (path != null)
			{
				for (value in 0...path.length)
				{
					toReturn[path[value]] = value;
				}
				selectedEnemy = index;
				return toReturn;
			}
			index++;
		}
		return toReturn;
	}
}