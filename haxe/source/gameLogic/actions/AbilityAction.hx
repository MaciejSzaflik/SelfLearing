package gameLogic.actions;
import gameLogic.abilites.Ability;

/**
 * ...
 * @author 
 */
class AbilityAction extends Action
{
	var ability:Ability;
	public function new(ability:Ability) 
	{
		super();
		this.ability = ability;
	}
	
	override public function performAction() 
	{
		super.performAction();
		this.ability.perform();
	}
	
}