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
		trace("Start Round");
		GameContext.instance.inititativeQueue.fillWithPlayers(GameContext.instance.mapOfPlayers);
		resertOnTurnEffects();
		stateMachine.setCurrentState(new SelectMoveState(this.stateMachine,GameContext.instance.getNextCreature()));
	}
	
	private function resertOnTurnEffects()
	{
		for (creature in GameContext.instance.inititativeQueue.queue)
			creature.waited = false;
	}
}