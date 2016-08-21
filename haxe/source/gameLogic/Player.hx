package gameLogic;
import flixel.util.FlxColor;
import game.Creature;
import gameLogic.ai.ArtificialInteligence;
import gameLogic.ai.RandomAI;
import gameLogic.moves.Move;

/**
 * ...
 * @author ...
 */
class Player
{
	public var id(default, null):Int;
	public var playerType:PlayerType;
	public var color:FlxColor;
	public var creatures:Array<Creature>;
	public var deadCreatures:Array<Creature>;
	public var artificialInt:ArtificialInteligence;
	public function new(id:Int,creatures:Array<Creature>,color:FlxColor,playerType:PlayerType) 
	{
		this.playerType = playerType;
		this.id = id;
		this.color = color;
		this.deadCreatures = new Array<Creature>();
		this.creatures = creatures;
		for (creature in creatures)
		{
			creature.idPlayerId = id;
			creature.label.setLabelColor(color);
		}
		if (playerType != PlayerType.Human)
			createAI();
	}
	
	private function createAI()
	{
		artificialInt = new RandomAI();
	}
	
	public function onCreatureKilled(killed:Creature)
	{
		if (killed.idPlayerId != id)
			return;
		
		creatures.remove(killed);
		deadCreatures.push(killed);
	}
	
	public function generateMove():Move
	{
		if (artificialInt != null && playerType == PlayerType.AI)
		{
			return artificialInt.generateMove();
		}
		return null;
	}
	
	public var numberOfDead(get, never):Int;
	function get_numberOfDead():Int
	{
		return deadCreatures.length;
	}
	
	
}