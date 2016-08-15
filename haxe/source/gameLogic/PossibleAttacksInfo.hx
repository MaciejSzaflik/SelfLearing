package gameLogic;
import flixel.math.FlxPoint;
import game.Creature;
import hex.Hex;

/**
 * ...
 * @author 
 */
class PossibleAttacksInfo
{
	public var listOfCreatures:Map<Int,Creature>;
	public var listOfCenters:List<FlxPoint>;
	public var listOfHex:Map<Int,Bool>;
	
	public function new(listOfCreatures:Map<Int,Creature>,listOfCenters:List<FlxPoint>,attackHexesIds:Map<Int,Bool>) 
	{
		this.listOfCenters = listOfCenters;
		this.listOfCreatures = listOfCreatures;
		this.listOfHex = attackHexesIds;
	}
	
	public var lenght(get, never):Int;
	function get_lenght():Int
	{
		return listOfCenters.length;
	}
	
}