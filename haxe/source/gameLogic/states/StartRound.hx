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
		GameContext.instance.inititativeQueue.fillWithPlayers(GameContext.instance.listOfPlayers);
		stateMachine.currentState = new SelectMoveState(this.stateMachine);
	}
}