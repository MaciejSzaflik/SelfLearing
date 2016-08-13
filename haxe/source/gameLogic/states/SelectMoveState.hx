package gameLogic.states;

import game.Creature;
import gameLogic.Input;
import gameLogic.StateMachine;
import gameLogic.actions.MoveAction;
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
		if (selectedCreature == null)
		{
			GameContext.instance.inititativeQueue.fillWithPlayers(GameContext.instance.listOfPlayers);
			selectedCreature = GameContext.instance.getNextCreature();
		}
		
		
		rangeInfo = MainState.getInstance().getHexMap().getRange(selectedCreature.getTileId(), selectedCreature.range);
		
		MainState.getInstance().getDrawer().clear(1);
		colorRange();
		colorHexStatingOn();
	}
	
	private function colorRange()
	{
		MainState.getInstance().drawHexesRange(rangeInfo.centers, 1, 0x440033ff);
	}
	private function colorHexStatingOn()
	{
		MainState.getInstance().drawHex(MainState.getInstance().getHexMap().getHexCenterByAxialCor(selectedCreature.currentCordinates),1,0x99ff0000);
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
		if (rangeInfo.hexList.exists(input.coor.toKey()))
		{
			MainState.getInstance().getDrawer().clear(1);
			MainState.getInstance().getDrawer().clear(2);
			
			
			var action = new MoveAction(selectedCreature,input.coor,		
				function() 
				{	
					MainState.getInstance().getDrawer().clear(1);
					stateMachine.setCurrentState(new SelectMoveState(this.stateMachine));				
				}
			);
			action.performAction();
		}
	}
	
	private function handleMove(input:Input) 
	{
		MainState.getInstance().getDrawer().clear(2);
		if(rangeInfo.hexList.exists(input.coor.toKey()))
			MainState.getInstance().drawHex(input.hexCenter, 2,0x99ffffff);
	}
	
	
}