package gameLogic;
import flixel.util.FlxColor;
import game.Creature;
import gameLogic.ai.ArtificialInteligence;
import gameLogic.ai.BestMove;
import gameLogic.ai.RandomAI;
import gameLogic.ai.evaluation.KillTheWeakest;
import gameLogic.moves.MoveData;
import gameLogic.moves.MoveType;

/**
 * ...
 * @author ...
 */
class GamePlayer
{
	public var id(default, null):Int;
	public var playerType:PlayerType;
	public var color:FlxColor;
	public var creatures:Array<Creature>;
	public var deadCreatures:Array<Creature>;
	public var artificialInt:ArtificialInteligence;
	public var reversedSprites:Bool;
	
	public function new(id:Int,creatures:Array<Creature>,color:FlxColor,playerType:PlayerType,reversedSprites:Bool) 
	{
		this.playerType = playerType;
		this.id = id;
		this.color = color;
		this.deadCreatures = new Array<Creature>();
		this.creatures = new Array<Creature>();
		this.reversedSprites = reversedSprites;
		
		for (creature in creatures)
			addCreatureToPlayer(creature);
			
		if (playerType != PlayerType.Human)
			createAI();
	}
	
	public function addCreatureToPlayer(creature:Creature)
	{
		creature.idPlayerId = id;
		creature.label.setLabelColor(color);
		creature.flipSprite(reversedSprites);
		creature.startAnimation();
		creatures.push(creature);
	}
	
	private function createAI()
	{
		artificialInt = new BestMove(new KillTheWeakest(false));
	}
	
	public function setAI(AI:ArtificialInteligence)
	{
		//playerType = PlayerType.AI;
		artificialInt = AI;
	}
	
	public function onCreatureKilled(killed:Creature)
	{
		if (killed.idPlayerId != id)
			return;
		
		creatures.remove(killed);
		deadCreatures.push(killed);
	}
	
	public function onCreatureResurected(res:Creature)
	{
		deadCreatures.remove(res);
		creatures.push(res);
	}
	
	public function generateMove():MoveData
	{
		if (artificialInt != null && playerType == PlayerType.AI)
		{
			var move = artificialInt.generateMove();				
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