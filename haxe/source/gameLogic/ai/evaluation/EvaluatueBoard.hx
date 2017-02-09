package gameLogic.ai.evaluation;
import game.Creature;
import hex.HexMap;

/**
 * @author 
 */
interface EvaluatueBoard 
{
	public function evaluateBoard(map : HexMap, creature : Creature, enemyCreatures : Array<Creature>):RiskValues;
}