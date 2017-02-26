package gameLogic.ai.evaluation;
import game.Creature;
import gameLogic.actions.Action;
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
	
	public function new(enemyQueue : EnemyQueue) 
	{
		this.enemyQueue = enemyQueue;
	}
	
	public function evaluateMoves(listOfMoves:ListOfMoves):EvaluationResult 
	{
		var distanceToCreature;
		var result = new EvaluationResult(listOfMoves);
		this.currentCreature = GameContext.instance.currentCreature;
		
		var pathToScore = tryToFindAPath();
		
		var index = 0;
		for (move in listOfMoves.moves)
		{
			var value = 0;
			if (move.type == MoveType.Move)
			{
				if (pathToScore.exists(move.tileId))
				{
					var distanceToChar =  GameContext.instance.map.getManhatanDistance(currentCreature.getTileId(), move.tileId);
					var attackRangeBonus = distanceToChar <= currentCreature.attackRange ? 2.5 : 1.0;
					if (currentCreature.isRanger && distanceToChar == 1)
						attackRangeBonus = 0.25;
					value =  Std.int(pathToScore.get(move.tileId) * 10 * attackRangeBonus);
				}
			}
			else if(move.type == MoveType.Attack)
			{
				var enemyValue = enemyQueue.enemiesValues.get(move.affected.id);
				var index = enemyQueue.enemies.length - UtilUtil.getIndexOf(enemyQueue.enemies, move.affected) + 1;
				
				value = Std.int(enemyValue * index * rewardForEnemyPosition);
			}
			
			result.evaluationResults[index] = value;
			result.tryToSetBestIndex(index);
			index++;
		}
		
		return result;
		
	}
	
	public function tryToFindAPath() : Map<Int,Int>
	{
		var toReturn = new Map<Int,Int>();
		var index = 0;
		for (enemy in enemyQueue.enemies)
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