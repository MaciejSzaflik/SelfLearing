package gameLogic;
import flixel.util.FlxColor;
import game.Creature;
import gameLogic.ai.ArtificialInteligence;
import gameLogic.ai.BestMove;
import gameLogic.ai.RandomAI;
import gameLogic.ai.evaluation.KillTheWeakest;
import gameLogic.moves.MoveData;
import gameLogic.moves.MoveType;
import utilites.UtilUtil;

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
	public var deadCreatures:Map<Int,Creature>;
	public var artificialInt:ArtificialInteligence;
	public var reversedSprites:Bool;
	
	public function new(id:Int,creatures:Array<Creature>,color:FlxColor,playerType:PlayerType,reversedSprites:Bool) 
	{
		this.playerType = playerType;
		this.id = id;
		this.color = color;
		this.deadCreatures = new Map<Int,Creature>();
		this.creatures = new Array<Creature>();
		this.reversedSprites = reversedSprites;
		
		for (creature in creatures)
			addCreatureToPlayer(creature);
			
		if (playerType != PlayerType.Human)
			createAI();
	}
	
	public function totalHp()
	{
		var total = 0;
		for (creature in creatures)
		{
			total += creature.totalHealth;
		}
		return total;
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
		deadCreatures.set(killed.id, killed);
	}
	
	public function onCreatureResurected(res:Creature)
	{
		deadCreatures.remove(res.id);
		creatures.push(res);
	}
	
	public function tryToGenerateMove(moveConsumerer: MoveData->Void, before : Void->Void , after : Void->Void)
	{
		if (playerType == PlayerType.AI && artificialInt != null)
		{
			artificialInt.generateMoveWithThread(moveConsumerer, before, after);
		}
		return null;
	}
	
	public var numberOfDead(get, never):Int;
	function get_numberOfDead():Int
	{
		return UtilUtil.CountMap(this.deadCreatures);
	}
	
	
}