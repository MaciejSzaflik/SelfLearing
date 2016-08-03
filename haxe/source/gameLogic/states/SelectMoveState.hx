package gameLogic.states;

import gameLogic.StateMachine;

/**
 * ...
 * @author 
 */
class SelectMoveState extends State
{

	public function new(stateMachine:StateMachine) 
	{
		this.stateName = "Select Move";
		super(stateMachine);
		
	}
	
}