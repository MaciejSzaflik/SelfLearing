package gameLogic.ai;
import game.Creature;
import gameLogic.moves.MoveType;
import hex.HexCoordinates;
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
	
	public function new() 
	{
		ourHealth = 0;
		theirHealth = 0;
		currentTotalDistance = 0;
		isCreatureRanger = false;
		ourCount = 0;
		theirCount = 0;
		moveType = MoveType.Pass;
	}
	
	public static function CalculateForCreature(creature: Creature, moveType : MoveType) : CurrentStateData
	{
		var calc : CurrentStateData = new CurrentStateData();
		calc.isCreatureRanger = creature.isRanger;
		calc.moveType = moveType;
		for (enemy in GameContext.instance.getEnemies(creature.idPlayerId))
		{
			calc.theirHealth += enemy.totalHealth;
			calc.currentTotalDistance = HexCoordinates.getManhatanDistance(creature.currentCordinates, enemy.currentCordinates);
			calc.theirCount++;
		}
		for (friend in GameContext.instance.getPlayerCreatures(creature.idPlayerId))
		{
			calc.ourHealth += friend.totalHealth;
			calc.ourCount++;
		}
		return calc;
	}
	
	public static function Evaluate(before : CurrentStateData, after : CurrentStateData) : Tuple3<Float,MoveDiagnose,MoveDiagnose>
	{
		var toReturn : Tuple3<Float,MoveDiagnose,MoveDiagnose> = new Tuple3<Float,MoveDiagnose,MoveDiagnose>(0,MoveDiagnose.Pass,MoveDiagnose.Pass);
		
		if (before.moveType == MoveType.Attack)
		{
			var theirDiff = before.theirHealth - after.ourHealth;
			var ourDiff = before.theirHealth - after.ourHealth;
			
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
		else if (before.moveType == MoveType.Move)
		{
			if (before.currentTotalDistance > after.currentTotalDistance)
				toReturn._1 = MoveDiagnose.Flee;
			else
				toReturn._1 = MoveDiagnose.Move;
		}
		else
			toReturn._1 = MoveDiagnose.Pass;
		
		
		if (after.theirHealth > 0)
		{
			toReturn._0 = after.ourHealth / after.theirHealth;
			toReturn._0 += (before.ourCount - after.ourCount) * ( -150);
			toReturn._0 += (before.theirCount - after.theirCount) * ( 150);
		}
		else
			toReturn._0 = 1000000000000;
		
		
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
}