package gameLogic.ai.evaluation;
import game.Creature;
import hex.HexMap;
import gameLogic.ai.evaluation.RiskValues;
import thx.Tuple.Tuple2;

/**
 * ...
 * @author ...
 */
class BasicBoardEvaluator implements EvaluatueBoard 
{
	public function new()
	{
		
	}
	
	public function evaluateStateSingle(myId:Int, enemyId:Int): Float
	{
		var enemy = RewardBasedEvaluation.GetEvaluation(enemyId);
		if(enemy > 0)
			return RewardBasedEvaluation.GetEvaluation(myId) / enemy;
		else
			return 10;
	}
	
	
	public function evaluateState(myId:Int, enemyId:Int):Tuple2<Float, Float> 
	{
		return new Tuple2<Float,Float>(
			RewardBasedEvaluation.GetEvaluation(myId),
			RewardBasedEvaluation.GetEvaluation(enemyId));
	}
	
	public function evaluateBoard(map:HexMap, creature:Creature, enemyCreatures:Array<Creature>):RiskValues 
	{
		return null;
	}
	
}