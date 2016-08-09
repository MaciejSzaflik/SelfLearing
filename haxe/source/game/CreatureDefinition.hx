package game;

/**
 * ...
 * @author 
 */
class CreatureDefinition
{
	public var id:Int;
	
	public var initiative:Int;
	public var health:Int;
	public var actionPoints:Int;
	public var attackRange:Int;
	public var attackPointCost:Int;
	
	public var attackPower:Int;
	public var attackRandom:Int;
	
	public var name:String;
	public var spriteName:String;
	
	public function new(id:Int,attackPower:Int,attackRandom:Int,initiative:Int,health:Int,actionPoints:Int,attackRange:Int,attackPointCost:Int,name:String,spriteName:String) 
	{
		this.id = id;
		this.attackPower = attackPower;
		this.attackRandom = attackRandom;
		this.initiative = initiative;
		this.health = health;
		this.actionPoints = actionPoints;
		this.attackRange = attackRange;
		this.attackPointCost = attackPointCost;
		
		this.name = name;
		this.spriteName = spriteName;
	}
	
	public static function fromDynamic(object:Dynamic):CreatureDefinition
	{
		return new CreatureDefinition(
			object.id,
			object.attackPower,
			object.attackRandom,
			object.initiative,
			object.health,
			object.actionPoints,
			object.attackRange,
			object.attackPointCost,
			
			object.name,
			object.spriteName
		);
	}
	
	public function toString():String
	{
		return 'I:$initiative, H:$health, AP:$actionPoints, APC:$attackPointCost, N:$name, SN:$spriteName';
	}
	
}