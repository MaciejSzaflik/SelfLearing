package gameLogic.actions;

/**
 * ...
 * @author 
 */
class AttackInfo
{
	public var isAlive:Bool;
	public var attackPower:Int;
	
	public function new(isAlive:Bool,attackPower:Int)
	{
		this.isAlive = isAlive;
		this.attackPower = attackPower;
	}
}