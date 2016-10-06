package gameLogic.abilites;
import data.AbilityDefinition;
import game.Creature;
import utilites.GameConfiguration;

/**
 * ...
 * @author 
 */
class AbilityFactory
{
	private static var _instance:AbilityFactory;
	public static var instance(get, null):AbilityFactory;
	private static function get_instance():AbilityFactory {
        if(_instance == null) {
            _instance = new AbilityFactory();
        }
        return _instance;
    }
	private function new() 
	{
	}
	
	public function getAbility(creature:Creature, id:Int):Ability
	{
		if (!GameConfiguration.instance.abilitesDefinitions.exists(id))
			return null;
		
		var definition = GameConfiguration.instance.abilitesDefinitions.get(id);
		switch(definition.abilityType)
		{
			case AbilityType.Heal:
				return createHealAbility(definition,creature);
			case AbilityType.Summon:
				return createSummonAbility(definition,creature);
		}
		return null;
	}
	
	private function createHealAbility(definition:AbilityDefinition, creature:Creature):Heal
	{
		var heal = new Heal(creature);
		heal.range = Std.parseInt(definition.params[0]);
		heal.power = Std.parseInt(definition.params[1]);
		return heal;
	}
	
	private function createSummonAbility(definition:AbilityDefinition, creature:Creature):Summon
	{
		var summon = new Summon(creature);
		summon.range = Std.parseInt(definition.params[0]);
		summon.creatureId = Std.parseInt(definition.params[1]);
		summon.power = Std.parseInt(definition.params[2]);
		return summon;
	}
}