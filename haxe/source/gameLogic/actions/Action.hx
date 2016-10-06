package gameLogic.actions;
import haxe.Constraints.Function;

/**
 * ...
 * @author 
 */
class Action
{
	private var onFinish:Function;
	
	public function new() 
	{
		
	}
	
	public function performAction()
	{
		GameContext.instance.actionLog.addAbilityTooLog(this);
	}
	
	public function performLogic()
	{
		
	}
	
}