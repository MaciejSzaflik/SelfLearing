package gameLogic.actions;
import haxe.Constraints.Function;

/**
 * ...
 * @author ...
 */
class PassAction extends Action
{

	public function new(onFinish:Function) 
	{
		super();
		this.onFinish = onFinish;
	}
	
	override public function performAction() 
	{
		super.performAction();
		if (onFinish != null)
			onFinish();
	}
	
}