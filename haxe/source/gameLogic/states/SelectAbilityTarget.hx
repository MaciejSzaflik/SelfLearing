package gameLogic.states;

import flixel.input.FlxPointer;
import flixel.math.FlxPoint;
import game.Creature;
import gameLogic.Input;
import gameLogic.PossibleAttacksInfo;
import gameLogic.StateMachine;
import gameLogic.abilites.Ability;
import utilites.InputType;

/**
 * ...
 * @author 
 */
class SelectAbilityTarget extends State
{
	private var selectedCreature:Creature;
	private var ability:Ability;
	private var rangeOfHexes:PossibleAttacksInfo;
	
	public function new(stateMachine:StateMachine,creature:Creature,ability:Ability) 
	{
		this.stateName = "Ability";
		this.selectedCreature = creature;
		super(stateMachine);
		MainState.getInstance().getDrawer().clear(1);
		MainState.getInstance().getDrawer().clear(2);
		
		this.ability = ability;	
		rangeOfHexes = this.ability.getTargets();
		if(rangeOfHexes.listOfCenters!=null)
			colorRange(rangeOfHexes.listOfCenters);
	}
	
	override public function handleButtonClick(buttonName:String) 
	{
		if (buttonName == "ability")
			stateMachine.setCurrentState(new SelectMoveState(this.stateMachine,selectedCreature));
	}
	
	private function colorRange(points:List<FlxPoint>)
	{
		MainState.getInstance().drawHexesRange(points, 1, 0x4433aa33);
	}
	
	override public function handleInput(input:Input) 
	{
		if (input.type == InputType.move)
			handleMouseMove(input);
		else
			handleClick(input);
	}
	
	private function handleClick(input:Input)
	{
		if (rangeOfHexes.listOfHex.exists(input.coor.toKey()))
		{
			ability.setTarget(input.coor.toKey());
			ability.perform();
			endState();
		}
	}
	
	private function endState()
	{
		var counterOfPlayersWithCreatures = 0;
		for (player in GameContext.instance.mapOfPlayers)
		{
			if (player.creatures.length != 0)
				counterOfPlayersWithCreatures++;
		}
		if (counterOfPlayersWithCreatures == 1)
			stateMachine.setCurrentState(new EndState(this.stateMachine));
		else if (GameContext.instance.getSizeOfQueue() == 0)
			stateMachine.setCurrentState(new StartRound(this.stateMachine));
		else
			stateMachine.setCurrentState(new SelectMoveState(this.stateMachine,GameContext.instance.getNextCreature()));
	}

	private function handleMouseMove(input:Input) 
	{
		MainState.getInstance().getDrawer().clear(2);
		MainState.getInstance().drawCircle(input.rawPosition, 2,0x99ffffff);
		if (rangeOfHexes.listOfHex.exists(input.coor.toKey()))
			MainState.getInstance().drawHex(input.hexCenter, 2, 0x99ffffff);
	}
	
}