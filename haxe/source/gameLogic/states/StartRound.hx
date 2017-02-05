package gameLogic.states;

import gameLogic.StateMachine;

/**
 * ...
 * @author 
 */
class StartRound extends State
{

	public function new(stateMachine:StateMachine) 
	{
		this.stateName = "Start Round";
		super(stateMachine);
	}
	
	override public function onEnter():Void 
	{
		try
		{
		trace(GameContext.instance.inititativeQueue == null);
		trace(GameContext.instance.mapOfPlayers == null);
		GameContext.instance.inititativeQueue.fillWithPlayers(GameContext.instance.mapOfPlayers);
		resertOnTurnEffects();
		trace(stateMachine == null);
		stateMachine.setCurrentState(new SelectMoveState(this.stateMachine, GameContext.instance.getNextCreature()));
		}
		catch (msg : String)
		{
			trace(msg);
		}
	}
	
	private function resertOnTurnEffects()
	{
		trace(GameContext.instance.inititativeQueue == null);
		trace(GameContext.instance.inititativeQueue.queue == null);
		for (creature in GameContext.instance.inititativeQueue.queue)
		{
			trace("Creature " + (creature == null));
			creature.waited = false;
		}
	}
}