package gameLogic.ai.evaluation;
import data.CreatureDefinition;
import game.Creature;
import gameLogic.actions.ActionFactory;
import gameLogic.ai.evaluation.EvaluationResult;
import gameLogic.moves.ListOfMoves;
import gameLogic.moves.MoveData;
import gameLogic.moves.MoveType;
import hex.HexCoordinates;

/**
 * ...
 * @author ...
 */
class RewardBasedEvaluation extends EnemySelectEvaluation
{
	public static inline var ALIVE_REWARD = 30.0;
	public static inline var ENEMY_HEALTH_REWARD = 20.0;
	public static inline var ATTACK_POSSIBILTY_REWARD = 10.0;
	public static inline var SELF_HEALTH_REWARD = 10.0;
	public static inline var ENEMY_COUNT_REWARD = -150.0;
	public static inline var ATTACK_ME_RISK_REWARD = -2.0;
	public static inline var MELLE_ATTACK_REWARD = 100;
	public static inline var RANGER_ATTACK_REWARD = 300;
	
	public static inline var DISTANCE_TO_ENEMY_REWARD_MELEE = 1;
	public static inline var DISTANCE_TO_ENEMY_REWARD_RANGER = 1;
	
	public static inline var NEIGHBOURS_REWARD_MELEE = 40;
	public static inline var NEIGHBOURS_REWARD_RANGER = -40;
	
	override public function evaluateMoves(listOfMoves:ListOfMoves):EvaluationResult 
	{
		var result = new EvaluationResult(listOfMoves);
		this.currentCreature = GameContext.instance.currentCreature;
		
		var valueMax = -10000000.0;
		var indexMin = -1;
		var index = 0;
		
		var totalEnemyHealth = calculateEnemyHealth(GameContext.instance.getEnemies(currentCreature.getTileId()));
		var creaureHealth = currentCreature.totalHealth;
		var pathToScore = tryToFindAPath(enemyQueue.enemies);
		
		for (move in listOfMoves.moves)
		{
			var moveValue = 0.0;
			if (move.type == MoveType.Move)
				moveValue += scoreMove(pathToScore,move);
			
			var action = ActionFactory.actionFromMoveData(move, null);
			action.performAction();
			var enemies = GameContext.instance.getEnemies(currentCreature.getTileId());
			moveValue+= aliveCheck();
			moveValue+= totalEnemyHealthCalc(totalEnemyHealth, enemies);
			moveValue+= enemyCount(enemies);
			moveValue+= enemiesInAttackRange(enemies);
			moveValue+= enemiesThatCanAttackMe(enemies);
			moveValue+= enemyNeighbours();
			moveValue+= byMoveType(move);
			
			result.evaluationResults.set(index, Std.int(moveValue));
			if (moveValue > valueMax)
			{
				indexMin = index;
				valueMax = moveValue;
			}
			
			GameContext.instance.undoNextAction();
			index++;
		}
		result.tryToSetBestIndex(indexMin);
		return result;

	}
	
	private function byMoveType(moveData:MoveData) : Float
	{
		if (moveData.type == MoveType.Attack)
		{
			if (moveData.affected.isRanger)
				return RANGER_ATTACK_REWARD;
			else
				return MELLE_ATTACK_REWARD;
		}
		return 0;
	}
	
	private function calculateEnemyHealth(enemies: Array<Creature>)
	{
		var totalHealth = 0.0;
		for (enemy in enemies)
		{
			totalHealth += enemy.totalHealth;
		}
		return totalHealth;
	}
	
	private function aliveCheck() : Float
	{
		if(currentCreature != null && currentCreature.totalHealth > 0)
			return ALIVE_REWARD;
		else
			return -ALIVE_REWARD;
	}
	
	private function totalEnemyHealthCalc(totalEnemyPast:Float,enemies: Array<Creature>) : Float
	{
		var proc =  (totalEnemyPast - calculateEnemyHealth(enemies))/totalEnemyPast;
		return ENEMY_HEALTH_REWARD * proc;
	}
	
	private function enemyCount(enemies: Array<Creature>) : Float
	{
		return enemies.length*ENEMY_COUNT_REWARD;
	}
	
	private function enemiesInAttackRange(enemies: Array<Creature>) : Float
	{
		var range = GameContext.instance.map.findRangeNoObstacles(
			currentCreature.getTileId(),
			currentCreature.attackRange);
		
		var countOfEnemies = 0;
		
		for (enemy in enemies)
		{
			if (range.exists(enemy.getTileId()))
				countOfEnemies++;
		}
		
		return countOfEnemies*ATTACK_POSSIBILTY_REWARD;
	}
	
	private function enemiesThatCanAttackMe(enemies: Array<Creature>) : Float
	{
		var countOfEnemies = 0;
		for (enemy in enemies)
		{
			var enemyRange = enemy.attackRange;
			if (!enemy.isRanger)
			{
				enemyRange+= enemy.range;
			}
			var distance = HexCoordinates.getManhatanDistance(currentCreature.currentCordinates,enemy.currentCordinates);
			if(enemyRange >= distance)
				countOfEnemies++;
		}
		return countOfEnemies* (currentCreature.isRanger? DISTANCE_TO_ENEMY_REWARD_RANGER : DISTANCE_TO_ENEMY_REWARD_MELEE);
	}
	
	private function selfHealthy(myPastHealth:Int) : Float
	{
		var proc = currentCreature.totalHealth / myPastHealth;
		return (proc > 1) ? SELF_HEALTH_REWARD * proc : -SELF_HEALTH_REWARD * proc;
	}
	
	private function distanceToEnemy(enemies: Array<Creature>) : Float
	{
		return 0;
	}
	
	private function enemyNeighbours() : Float
	{
		return currentCreature.getEnemyNeighbours().lenght * (currentCreature.isRanger? NEIGHBOURS_REWARD_RANGER : NEIGHBOURS_REWARD_MELEE);
	}

	
}