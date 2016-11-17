package gameLogic;
import gameLogic.actions.Action;

/**
 * ...
 * @author 
 */
class ActionLog
{
	public var actionLog:Array<Action>;
	private var currentActionIndex = 0;
	public function new() 
	{
		actionLog = new Array<Action>();
	}
	
	public function addAbilityTooLog(action:Action)
	{
		if (currentActionIndex != 0)
		{
			actionLog.splice(0, currentActionIndex);
			currentActionIndex = 0;
		}
		actionLog.insert(0,action);
	}
	
	public function goBack():Action
	{
		if (currentActionIndex >= actionLog.length)
			return null;
		actionLog[currentActionIndex].resetAction();
		currentActionIndex++;
		return actionLog[currentActionIndex-1];
	}
	
	//public
}