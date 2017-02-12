package gameLogic.ai.evaluation;
import game.Creature;
import gameLogic.ai.evaluation.RiskValues;
import hex.HexCoordinates;
import hex.HexMap;
import utilites.MathUtil;

/**
 * ...
 * @author 
 */
class RiskByDistance implements EvaluatueBoard 
{

	public function new() 
	{
		
	}
	
	public function evaluateBoard(map : HexMap, creature : Creature, enemyCreatures : Array<Creature>):RiskValues
	{
		var values = new RiskValues();
		if (creature.currentCordinates == null)
			return values;
			
		for (hex in map.getGraph().getVertices().keys())
		{
			values.values[hex] = 0;
			var coor = map.getHexByIndex(hex).getCoor();
			for (enemy in enemyCreatures)
			{
				if (enemy.currentCordinates != null)
					values.values[hex] += HexCoordinates.getManhatanDistance(enemy.currentCordinates, coor) / 10.0;
			}	
			values.values[hex] = MathUtil.clamp01(values.values[hex]/enemyCreatures.length);
			if (values.values[hex] > values.maxValue)
				values.maxValue = values.values[hex];
		}
		return values;
	}
}
