package gameLogic.states;

import game.Creature;
import gameLogic.Input;
import gameLogic.PossibleAttacksInfo;
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
	private var moveRangeInfo:RangeInformation;
	private var attacksInfo:PossibleAttacksInfo;
	
	public function new(stateMachine:StateMachine) 
	{
		this.stateName = "Select Move";
		super(stateMachine);
		
		selectedCreature = GameContext.instance.getNextCreature();
		if (selectedCreature == null)
		{
			GameContext.instance.inititativeQueue.fillWithPlayers(GameContext.instance.mapOfPlayers);
			selectedCreature = GameContext.instance.getNextCreature();
		}
		
		getMoveRange();
		getAttackRange();
	}
	
	private function getMoveRange()
	{
		moveRangeInfo = MainState.getInstance().getHexMap().getRange(selectedCreature.getTileId(), selectedCreature.range, true);
		
		MainState.getInstance().getDrawer().clear(1);
		colorRange();
		colorHexStandingOn();
	}
	
	private function getAttackRange()
	{
		attacksInfo = GameContext.instance.getCreaturesInAttackRange(selectedCreature);
		if(attacksInfo.lenght > 0)
			MainState.getInstance().drawHexesRange(attacksInfo.listOfCenters, 1, 0xaaffaa66);
		
	}
	
	private function colorRange()
	{
		MainState.getInstance().drawHexesRange(moveRangeInfo.centers, 1, 0x440033ff);
	}
	private function colorHexStandingOn()
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
		if (moveRangeInfo.hexList.exists(input.coor.toKey()))
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
		if(moveRangeInfo.hexList.exists(input.coor.toKey()))
			MainState.getInstance().drawHex(input.hexCenter, 2,0x99ffffff);
	}
	
	
}