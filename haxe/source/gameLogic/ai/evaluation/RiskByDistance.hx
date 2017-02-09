package gameLogic.ai.evaluation;
import game.Creature;
import hex.HexCoordinates;
import hex.HexMap;

/**
 * ...
 * @author 
 */
class RiskByDistance implements EvaluatueBoard 
{

	public function new() 
	{
		
	}
	
	public function evaluateBoard(map : HexMap, creature : Creature, enemyCreatures : Array<Creature>):Map<Int,Float>
	{
		var values = new Map<Int,Float>();
		if (creature.currentCordinates == null)
			return values;
			
		for (hex in map.getGraph().getVertices().keys())
		{
			values[hex] = 0;
			var coor = map.getHexByIndex(hex).getCoor();
			for (enemy in enemyCreatures)
			{
				if (enemy.currentCordinates != null)
					values[hex] += HexCoordinates.getManhatanDistance(enemy.currentCordinates, coor) / 10.0;
			}	
		}
		return values;
	}
	
	
	public class RiskValues()
	{
		public var values:Map<Int,Float>; 
		public var maxValue:Float;
		public function RiskValues()
		{
			values = new Map<Int,Float>();
		}
	}
}