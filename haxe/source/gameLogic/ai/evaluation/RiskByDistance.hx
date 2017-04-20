package gameLogic.ai.evaluation;
import game.Creature;
import game.CreatureSprite;
import gameLogic.ai.evaluation.RiskValues;
import gameLogic.moves.MoveData;
import hex.HexCoordinates;
import hex.HexMap;
import thx.Tuple.Tuple2;
import utilites.MathUtil;

/**
 * ...
 * @author 
 */
class RiskByDistance implements EvaluatueBoard 
{
	var baseValueMelee : Float = 0.5;
	var controlerValueMelee : Float = 0.8;
	
	var baseValueRanger : Float = 0.3;
	var controlerValueRanger : Float = 0.9;
	public function new() 
	{
		
	}
	var dmgToCreature : Map<Int,Int>;
	
	public function evaluateStateSingle(myId : Int, enemyId : Int, moveData : MoveData)
	{
		var tup = evaluateState(myId, enemyId);
		if (tup._1 > 0)
			return tup._0 / tup._1;
		else
			return 10;
	}
	
	public function evaluateState(myId : Int, enemyId : Int):Tuple2<Float,Float>
	{
		var sumForMe:Float = 0;
		var sumForThem:Float = 0;
		dmgToCreature = new Map<Int,Int>();
		
		for (hex in GameContext.instance.map.getGraph().getVertices().keys())
		{
			var coor = GameContext.instance.map.getHexByIndex(hex).getCoor();
			
			sumForThem = forEachCreature(enemyId,coor);
			sumForMe = forEachCreature(myId,coor);
		}
		return new Tuple2(sumForMe, sumForThem);
	}
	
	private function forEachCreature(playerId : Int, coor : HexCoordinates) : Float
	{
		var sum : Float = 0;
		for (enemy in GameContext.instance.mapOfPlayers.get(playerId).creatures)
			{	
				if (enemy.currentCordinates == null)
					continue;
				
				if(!enemy.isRanger)
					sum += calculateMeleeValue(enemy,HexCoordinates.getManhatanDistance(enemy.currentCordinates, coor));
				else
					sum += calculateRangerValue(enemy,HexCoordinates.getManhatanDistance(enemy.currentCordinates, coor));
			}	
			
		return sum;
	}
	
	public function evaluateBoard(map : HexMap, creature : Creature, enemyCreatures : Array<Creature>):RiskValues
	{
		var values = new RiskValues();
		dmgToCreature = new Map<Int,Int>();
		if (creature.currentCordinates == null)
			return values;
			
		for (hex in map.getGraph().getVertices().keys())
		{
			values.values[hex] = 0;
			var coor = map.getHexByIndex(hex).getCoor();
			var dmgOutput = 0;
			for (enemy in enemyCreatures)
			{	
				if (enemy.currentCordinates == null)
					continue;
				
				if(!enemy.isRanger)
					values.values[hex] += calculateMeleeValue(enemy,HexCoordinates.getManhatanDistance(enemy.currentCordinates, coor));
				else
					values.values[hex] += calculateRangerValue(enemy,HexCoordinates.getManhatanDistance(enemy.currentCordinates, coor));
			}	
			values.sum += values.values[hex];
			if (values.values[hex] > values.maxValue)
				values.maxValue = values.values[hex];
		}
		return values;
	}
	
	private function getDmgOutput(creature : Creature) : Int
	{
		if (!dmgToCreature.exists(creature.id))
			dmgToCreature[creature.id] = creature.attack * creature.stackCounter;
		return dmgToCreature[creature.id];
	}
	
	private function calculateRangerValue(creature : Creature, distance : Float) : Float
	{
		var attackValue = getDmgOutput(creature);
		
		if (distance == 1)
			return attackValue * 0.5;
		if (distance < creature.attackRange)
			return attackValue;
		
		var movesToGetThere =  Math.floor(distance / creature.range) + 1;
		if (movesToGetThere == 0)
			return 0;
		
			
		return attackValue * Math.pow(baseValueRanger,(movesToGetThere-1)*baseValueRanger);
	}
	
	private function calculateMeleeValue(creature : Creature, distance : Float) : Float
	{
		var attackValue = getDmgOutput(creature);
		var movesToGetThere =  Math.floor(distance / (creature.range+1)) + 1;
		if (movesToGetThere == 0)
			return 0;
		
		return attackValue * Math.pow(baseValueMelee,(movesToGetThere-1)*controlerValueMelee);
	}
}
