package gameLogic.states;

import game.Creature;
import gameLogic.Input;
import gameLogic.StateMachine;
import hex.RangeInformation;
import utilites.InputType;

/**
 * ...
 * @author 
 */
class SelectMoveState extends State
{
	private var selectedCreature:Creature;
	private var rangeInfo:RangeInformation;
	
	public function new(stateMachine:StateMachine) 
	{
		this.stateName = "Select Move";
		super(stateMachine);
		
		selectedCreature = GameContext.instance.getNextCreature();
		rangeInfo = MainState.getInstance().getHexMap().getRange(selectedCreature.getTileId(), selectedCreature.range);
		
		MainState.getInstance().getDrawer().clear(1);
		MainState.getInstance().drawHexesRange(rangeInfo.centers, 1);
	}
	
	override public function handleInput(input:Input) 
	{
		if (input.type == InputType.move)
			handleMove(input);
		else
			handleClick(input);
	}
	
	private function handleClick(input:Input)
	{
		MainState.getInstance().getDrawer().clear(1);
		MainState.getInstance().getDrawer().clear(2);
		//stateMachine.setCurrentState(new MoveState(this.stateMachine));
	}
	
	private function handleMove(input:Input) 
	{
		MainState.getInstance().getDrawer().clear(2);
		if(rangeInfo.hexList.exists(input.coor.toKey()))
			MainState.getInstance().drawHex(input.hexCenter, 2);
	}
	
	
}