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
	public var ourRangerCount : Int;
	public var theirRangerCount : Int;
	
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
	}
	
	public static function CalculateForCreature(creature: Creature,moveType : MoveType) : CurrentStateData
	{
		var calc : CurrentStateData = new CurrentStateData();
		calc.isCreatureRanger = creature.isRanger;
		calc.moveType = moveType;	
			
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
	
	public static function Evaluate(before : CurrentStateData, after : CurrentStateData) : Tuple3<Float,MoveDiagnose,MoveDiagnose>
	{
		var toReturn : Tuple3<Float,MoveDiagnose,MoveDiagnose> = new Tuple3<Float,MoveDiagnose,MoveDiagnose>(0, MoveDiagnose.Pass, MoveDiagnose.Pass);
		var theirDiff = before.theirHealth - after.theirHealth;
		var ourDiff = before.ourHealth - after.ourHealth;
		
		if (before.moveType == MoveType.Attack)
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
		else if (before.moveType == MoveType.Move)
		{
			if (before.currentTotalDistance > after.currentTotalDistance)
				toReturn._1 = MoveDiagnose.Flee;
			else
				toReturn._1 = MoveDiagnose.Move;
		}
		else
			toReturn._1 = MoveDiagnose.Pass;
		
		
		if (theirDiff > 0)
		{
			toReturn._0 =  (ourDiff/theirDiff)*1000;
			toReturn._0 += (before.ourCount - after.ourCount) * ( -150);
			toReturn._0 += (before.theirCount - after.theirCount) * ( 150);
			toReturn._0 += (after.ourRangerCount) * (150);
			toReturn._0 += (after.theirRangerCount) * ( -150);
			
			if (after.theirHealth <= 0)
				toReturn._0 += 20000;
		}
			
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