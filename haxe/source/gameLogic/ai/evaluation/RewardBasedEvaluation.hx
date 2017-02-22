package gameLogic.ai.evaluation;
import data.CreatureDefinition;
import game.Creature;
import gameLogic.actions.ActionFactory;
import gameLogic.moves.ListOfMoves;
import hex.HexCoordinates;

/**
 * ...
 * @author ...
 */
class RewardBasedEvaluation implements EvaluationMethod
{
	public static inline var ALIVE_REWARD = 100.0;
	public static inline var ENEMY_HEALTH_REWARD = 200.0;
	public static inline var ATTACK_POSSIBILTY_REWARD = 10.0;
	public static inline var SELF_HEALTH_REWARD = 100.0;
	public static inline var ENEMY_COUNT_REWARD = -50.0;
	public static inline var ATTACK_ME_RISK_REWARD = -10.0;
	
	public static inline var DISTANCE_TO_ENEMY_REWARD_MELEE = 1;
	public static inline var DISTANCE_TO_ENEMY_REWARD_RANGER = 1;
	
	public static inline var NEIGHBOURS_REWARD_MELEE = 10;
	public static inline var NEIGHBOURS_REWARD_RANGER = -10;
	
	
	public function new()
	{
		
	}
	
	var currentCreature: Creature;
	public function evaluateMoves(listOfMoves:ListOfMoves):EvaluationResult
	{
		var result = new EvaluationResult(listOfMoves);
		this.currentCreature = GameContext.instance.currentCreature;
		var listOfMoves = GameContext.instance.generateListOfMovesForCreature(currentCreature);
		
		var valueMax = -10000000.0;
		var indexMin = -1;
		var index = 0;
		
		var totalEnemyHealth = calculateEnemyHealth(GameContext.instance.getEnemies(currentCreature.getTileId()));
		var creaureHealth = currentCreature.totalHealth;
		
		for (move in listOfMoves.moves)
		{
			var action = ActionFactory.actionFromMoveData(move, null);
			action.performAction();
			var enemies = GameContext.instance.getEnemies(currentCreature.getTileId());
			var moveValue = 0.0;
			moveValue+= aliveCheck();
			moveValue+= totalEnemyHealthCalc(totalEnemyHealth, enemies);
			moveValue+= enemyCount(enemies);
			moveValue+= enemiesInAttackRange(enemies);
			moveValue+= enemiesThatCanAttackMe(enemies);
			moveValue+= enemyNeighbours();
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
		var proc = calculateEnemyHealth(enemies) / totalEnemyPast;
		return (proc < 1) ? ENEMY_HEALTH_REWARD * proc : -ENEMY_HEALTH_REWARD * proc;
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