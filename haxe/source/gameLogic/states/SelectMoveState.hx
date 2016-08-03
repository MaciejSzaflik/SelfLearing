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
		
		var creature = GameContext.instance.getNextCreature();
		var rangeInfo = MainState.getInstance().getHexMap().getRange(creature.getTileId(), creature.range);
		MainState.getInstance().drawHexesRange(rangeInfo.centers, 1);
	}
	
	
}