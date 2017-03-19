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
			moveValue+= enemyCount(enemies.length);
			moveValue+= enemiesInAttackRange(currentCreature,enemies);
			moveValue+= enemiesThatCanAttackMe(currentCreature,enemies);
			moveValue+= enemyNeighbours(currentCreature);
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
	
	public static function GetEvaluation(playerId: Int)
	{
		var value : Float = 0;
		var enemies = GameContext.instance.getEnemies(playerId);
		var our = GameContext.instance.getPlayerCreatures(playerId);
		value += calculateEnemyHealth(our);
		value += enemyCount(enemies.length);
		value += enemiesAtRangeTotal(our, enemies);
		value += enemyNeighboursTotal(our);
		return value;
	}
	
	public static function calculateEnemyHealth(enemies: Array<Creature>) : Float
	{
		var totalHealth = 0.0;
		for (enemy in enemies)
		{
			totalHealth += enemy.totalHealth;
		}
		return totalHealth;
	}
	
	public static function enemyCount(enemyCount : Int) : Float
	{
		return enemyCount*ENEMY_COUNT_REWARD;
	}
	
	public static function enemiesAtRangeTotal(ourCreatures : Array<Creature>, enemies: Array<Creature>) : Float
	{
		var total : Float = 0;
		for (creature in ourCreatures)
		{
			total += enemiesInAttackRange(creature, enemies);
		}
		return total;
	}
	
	
	public static function enemyNeighboursTotal(ourCreatures : Array<Creature>) : Float
	{
		var total : Float = 0;
		for (creature in ourCreatures)
		{
			total += enemyNeighbours(creature);
		}
		return total;
	}
	
	
	private static function enemyNeighbours(creature : Creature) : Float
	{
		return creature.getEnemyNeighbours().lenght * (creature.isRanger? NEIGHBOURS_REWARD_RANGER : NEIGHBOURS_REWARD_MELEE);
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
	
	
	private static function enemiesInAttackRange(current: Creature, enemies: Array<Creature>) : Float
	{
		var range = GameContext.instance.map.findRangeNoObstacles(
			current.getTileId(),
			current.attackRange);
		
		var countOfEnemies = 0;
		
		for (enemy in enemies)
		{
			if (range.exists(enemy.getTileId()))
				countOfEnemies++;
		}
		
		return countOfEnemies*ATTACK_POSSIBILTY_REWARD;
	}
	
	private static function enemiesThatCanAttackMe(current: Creature, enemies: Array<Creature>) : Float
	{
		var countOfEnemies = 0;
		for (enemy in enemies)
		{
			var enemyRange = enemy.attackRange;
			if (!enemy.isRanger)
			{
				enemyRange+= enemy.range;
			}
			var distance = HexCoordinates.getManhatanDistance(current.currentCordinates,enemy.currentCordinates);
			if(enemyRange >= distance)
				countOfEnemies++;
		}
		return countOfEnemies* (current.isRanger? DISTANCE_TO_ENEMY_REWARD_RANGER : DISTANCE_TO_ENEMY_REWARD_MELEE);
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
	
	

	
}