package gameLogic.actions;
import game.Creature;
import haxe.Constraints.Function;

/**
 * ...
 * @author 
 */
class Action
{
	public var performer:Creature;
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
	
	public function resetAction()
	{
		
	}
	
	
}