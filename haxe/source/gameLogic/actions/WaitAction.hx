package gameLogic.actions;
import game.Creature;
import haxe.Constraints.Function;

/**
 * ...
 * @author 
 */
class WaitAction extends Action
{
	public function new(waiter:Creature,onFinish:Function) 
	{
		super();
		this.performer = waiter;
		this.onFinish = onFinish;
	}
	
	override public function performAction() 
	{
		super.performAction();
		if (!performer.waited)
		{
			performer.waited = true;
			GameContext.instance.inititativeQueue.MakeCreatureWait(performer);	
		}
		if (onFinish != null)
				onFinish();
	}
	
	override public function resetAction()
	{
		GameContext.instance.inititativeQueue.removeCreatureFromQueue(performer);
	}
}