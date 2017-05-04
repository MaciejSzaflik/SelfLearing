package gameLogic.ai;
import game.Creature;
import gameLogic.moves.MoveType;
import hex.HexCoordinates;
import thx.Floats;
import thx.Ints;
import thx.Tuple.Tuple3;

/**
 * ...
 * @author ...
 */
class CurrentStateData 
{
	public var ourHealth : Int;
	public var theirHealth : Int;
	public var currentTotalDistance : Float; 
	public var isCreatureRanger : Bool;
	public var moveType : MoveType;
	public var ourCount : Int;
	public var theirCount : Int;
	public var ourRangerCount : Int;
	public var theirRangerCount : Int;
	public var tileId : Int;
	public var theirStartHp : Int;
	
	public function new() 
	{
		ourHealth = 0;
		theirHealth = 0;
		currentTotalDistance = 0;
		isCreatureRanger = false;
		ourCount = 0;
		theirCount = 0;
		ourRangerCount = 0;
		theirRangerCount = 0;
		moveType = MoveType.Pass;
		tileId = 0;
		theirStartHp = 0;
	}
	
	public static function CalculateForCreature(creature: Creature,moveType : MoveType) : CurrentStateData
	{
		var calc : CurrentStateData = new CurrentStateData();
		calc.isCreatureRanger = creature.isRanger;
		calc.moveType = moveType;	
		calc.tileId = creature.getTileId();
		
		calc.theirStartHp = GameContext.instance.getStartHpOfPlayer(GameContext.instance.getEnemyId(creature.idPlayerId));
		
		for (enemy in GameContext.instance.getEnemies(creature.idPlayerId))
		{
			calc.theirHealth += enemy.totalHealth;
			calc.currentTotalDistance = HexCoordinates.getManhatanDistance(creature.currentCordinates, enemy.currentCordinates);
			calc.theirCount++;
			if (enemy.isRanger)
				calc.theirRangerCount++;
		}
		for (friend in GameContext.instance.getPlayerCreatures(creature.idPlayerId))
		{
			calc.ourHealth += friend.totalHealth;
			calc.ourCount++;
			
			if (friend.isRanger)
				calc.ourRangerCount++;
		}
		return calc;
	}
	
	public static function EvaluateForPlayer(playerId : Int) : Float
	{
		var endValue = 0.0;
		
		var calc : CurrentStateData = new CurrentStateData();
		for (enemy in GameContext.instance.getEnemies(playerId))
		{
			calc.theirHealth += enemy.totalHealth;
			//calc.currentTotalDistance = HexCoordinates.getManhatanDistance(creature.currentCordinates, enemy.currentCordinates);
			calc.theirCount++;
			if (enemy.isRanger)
				calc.theirRangerCount++;
		}
		for (friend in GameContext.instance.getPlayerCreatures(playerId))
		{
			calc.ourHealth += friend.totalHealth;
			calc.ourCount++;
			
			if (friend.isRanger)
				calc.ourRangerCount++;
		}
		
		var hpLost = GameContext.instance.getStartHpOfPlayer(GameContext.instance.getEnemyId(playerId)) - calc.theirHealth;
		if (calc.theirHealth > 0)
		{
			endValue =  (calc.ourHealth/calc.theirHealth*10)*100;
			endValue += calc.ourCount * 150;
			endValue += calc.theirCount * -150;
			endValue += calc.ourRangerCount*150;
			endValue += calc.theirRangerCount * -150;
			//endValue += calc.currentTotalDistance * -30;
			endValue += hpLost*10;
		}
		else 
			endValue += Math.POSITIVE_INFINITY;
			
		return endValue;
	}
	
	public static function Evaluate(before : CurrentStateData, after : CurrentStateData) : Tuple3<Float,MoveDiagnose,MoveDiagnose>
	{
		var toReturn : Tuple3<Float,MoveDiagnose,MoveDiagnose> = new Tuple3<Float,MoveDiagnose,MoveDiagnose>(0, MoveDiagnose.Empty, MoveDiagnose.Empty);
		var theirDiff = before.theirHealth - after.theirHealth;
		var ourDiff = before.ourHealth - after.ourHealth;
		var hpLost = before.theirStartHp - after.theirHealth;
		if (after.moveType == MoveType.Attack)
		{
			if (!before.isCreatureRanger)
				toReturn._1 = MoveDiagnose.AttackMeleeByMelee;
			else	
			{
				if (ourDiff > 0)
					toReturn._1 = MoveDiagnose.AttackMeleeByRanger;
				else
					toReturn._1 = MoveDiagnose.AttackRangerByRanger;
			}
			
			if (ourDiff > theirDiff)
					toReturn._2 = MoveDiagnose.AttackRecklessly;
				else
					toReturn._2 = MoveDiagnose.AttackWithAdvantage;
					
			
		}
		else if (after.moveType == MoveType.Move)
		{
			if (before.currentTotalDistance < after.currentTotalDistance)
				toReturn._1 = MoveDiagnose.Flee;
			else
				toReturn._1 = MoveDiagnose.Move;
		}
		else
			toReturn._1 = MoveDiagnose.Pass;
		
		if (after.theirHealth > 0)
		{
			toReturn._0 =  (after.ourHealth/after.theirHealth*10)*100;
			toReturn._0 += after.ourCount * 150;
			toReturn._0 += after.theirCount * -150;
			toReturn._0 += after.ourRangerCount*150;
			toReturn._0 += after.theirRangerCount * -150;
			toReturn._0 += after.currentTotalDistance * -30;
			toReturn._0 += hpLost*10;
		}
		else 
			toReturn._0 += Math.POSITIVE_INFINITY;
		return toReturn;
	}
	
}

enum MoveDiagnose
{
	Move;
	Flee;
	AttackMeleeByMelee;
	AttackRangerByRanger;
	AttackMeleeByRanger;
	AttackRecklessly;
	AttackWithAdvantage;
	Pass;
	Empty;
}