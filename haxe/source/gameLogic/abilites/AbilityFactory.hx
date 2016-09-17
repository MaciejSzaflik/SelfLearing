package gameLogic.abilites;
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
	
	public function getAbility(id:Int):Ability
	{
		if (!GameConfiguration.instance.abilitesDefinitions.exists(id))
			return null;
		
		var definition = GameConfiguration.instance.abilitesDefinitions.get(id);
		switch(definition.abilityType)
		{
			case AbilityType.Heal:
				return null;
			case AbilityType.Spawn:
				return null;
		}
		return null;
	}
}