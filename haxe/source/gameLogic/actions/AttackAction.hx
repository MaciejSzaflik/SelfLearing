package gameLogic.actions;
import game.Creature;
import hex.HexCoordinates;

/**
 * ...
 * @author 
 */
class AttackAction extends Action
{
	private var attacker:Creature;
	private var defender:Creature;
	
	public function new(attacker:Creature,defender:Creature) 
	{
		super();
		this.attacker = attacker;
		this.defender = defender;
	}
	
	override public function performAction() 
	{
		var isAlive = attack(attacker, defender);
		var distance = HexCoordinates.getManhatanDistance(attacker.currentCordinates, defender.currentCordinates);
		if (isAlive && distance == 1 && defender.canContrattack)
		{
			attack(defender, attacker);
			defender.contrattackCountter++;
		}
	}
	
	private function attack(hitter:Creature,gettingHit:Creature):Bool
	{
		
		var attackPower = hitter.calculateAttack();
		var isAlive = gettingHit.getHit(attackPower);
		
		if (!isAlive)
			GameContext.instance.onCreatureKilled(gettingHit);
		
		trace(hitter.definition.name + " attacked " + gettingHit.definition.name + " for " + attackPower);
		return isAlive;
		
	}
	
	
	
}