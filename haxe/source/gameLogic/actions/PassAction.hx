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
	
}