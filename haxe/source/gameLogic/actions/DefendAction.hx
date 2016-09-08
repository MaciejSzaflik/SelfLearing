package gameLogic.actions;
import game.Creature;
import haxe.Constraints.Function;

/**
 * ...
 * @author 
 */
class DefendAction extends Action
{
	var defending:Creature;
	
	public function new(defending:Creature,onFinish:Function) 
	{
		super();
		this.defending = defending;
		this.onFinish = onFinish;
	}
	
	override public function performAction() 
	{
		super.performAction();
		this.defending.defending = true;
		if (onFinish != null)
			onFinish();
	}
}