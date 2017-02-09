package gameLogic.ai.evaluation;

/**
 * ...
 * @author 
 */
class RiskValues
{
	public var values:Map<Int,Float>; 
	public var maxValue:Float;
	public function new ()
	{
		values = new Map<Int,Float>();
		maxValue = -1;
	}
}