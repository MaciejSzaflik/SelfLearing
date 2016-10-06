package gameLogic;
import gameLogic.actions.Action;

/**
 * ...
 * @author 
 */
class ActionLog
{
	public var actionLog:List<Action>;
	public function new() 
	{
		actionLog = new List<Action>();
	}
	
	public function addAbilityTooLog(action:Action)
	{
		actionLog.push(action);
		trace(actionLog.length);
	}
	
}