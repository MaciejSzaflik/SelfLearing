package gameLogic.states;

import game.Creature;
import gameLogic.StateMachine;
import gameLogic.abilites.Ability;

/**
 * ...
 * @author 
 */
class SelectAbilityTarget extends State
{
	private var selectedCreature:Creature;
	private var ability:Ability;
	
	public function new(stateMachine:StateMachine,creature:Creature,ability:Ability) 
	{
		this.stateName = "Ability";
		this.selectedCreature = creature;
		super(stateMachine);
		MainState.getInstance().getDrawer().clear(1);
		MainState.getInstance().getDrawer().clear(2);
		
		this.ability = ability;
		
	}
	
	override public function handleButtonClick(buttonName:String) 
	{
		if (buttonName == "ability")
			stateMachine.setCurrentState(new SelectMoveState(this.stateMachine,selectedCreature));
	}
	
}