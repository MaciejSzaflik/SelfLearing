package gameLogic.states;

import gameLogic.StateMachine;

/**
 * ...
 * @author 
 */
class EndState extends State
{

	public function new(stateMachine:StateMachine) 
	{
		super(stateMachine);
		this.stateName = "End";
		
		MainState.getInstance().getDrawer().clear(1);
		MainState.getInstance().getDrawer().clear(2);
	}
	
}