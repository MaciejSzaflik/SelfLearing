package gameLogic;
import flixel.math.FlxPoint;
import game.Creature;

/**
 * ...
 * @author 
 */
class PossibleAttacksInfo
{
	public var listOfCreatures:List<Creature>;
	public var listOfCenters:List<FlxPoint>;
	
	public function new(listOfCreatures:List<Creature>,listOfCenters:List<FlxPoint>) 
	{
		this.listOfCenters = listOfCenters;
		this.listOfCreatures = listOfCreatures;
	}
	
	public var lenght(get, never):Int;
	function get_lenght():Int
	{
		return listOfCenters.length;
	}
	
}