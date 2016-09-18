package data;
import gameLogic.abilites.AbilityType;

/**
 * ...
 * @author 
 */
class AbilityDefinition
{
	public var id:Int;
	public var abilityType:AbilityType;
	public var params:Array<String>;
		
	public static function createEmpty():AbilityDefinition
	{
		return new AbilityDefinition( -1, AbilityType.Heal, null);
	}
	
	public function new(id:Int,abilityType:AbilityType,params:Array<String>)
	{
		this.id = id;
		this.abilityType = abilityType;
		this.params = params;
	}
}