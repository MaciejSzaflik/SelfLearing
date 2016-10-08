package gameLogic.actions;
import game.Creature;
import haxe.Constraints.Function;

/**
 * ...
 * @author 
 */
class DefendAction extends Action
{
	public function new(defending:Creature,onFinish:Function) 
	{
		super();
		this.performer = defending;
		this.onFinish = onFinish;
	}
	
	override public function performAction() 
	{
		super.performAction();
		this.performer.defending = true;
		if (onFinish != null)
			onFinish();
	}
	
	override public function resetAction() 
	{
		this.performer.defending = false;
	}
}