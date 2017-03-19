package gameLogic.ai.evaluation;
import game.Creature;
import hex.HexMap;
import thx.Tuple.Tuple2;

/**
 * @author 
 */
interface EvaluatueBoard 
{
	public function evaluateStateSingle(myId : Int, enemyId : Int):Float;
	public function evaluateState(myId : Int, enemyId : Int):Tuple2<Float,Float>;
	public function evaluateBoard(map : HexMap, creature : Creature, enemyCreatures : Array<Creature>):RiskValues;
}