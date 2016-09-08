package gameLogic.actions;
import game.Creature;
import haxe.Constraints.Function;

/**
 * ...
 * @author 
 */
class WaitAction extends Action
{
	var waiter:Creature;
	
	public function new(waiter:Creature,onFinish:Function) 
	{
		super();
		this.waiter = waiter;
		this.onFinish = onFinish;
	}
	
	override public function performAction() 
	{
		super.performAction();
		if (!waiter.waited)
		{
			waiter.waited = true;
			GameContext.instance.inititativeQueue.putCreatureOnQueueBottom(waiter);	
		}
		if (onFinish != null)
				onFinish();
	}	
}