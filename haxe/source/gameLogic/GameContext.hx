package gameLogic;
import data.CreatureDefinition;
import flixel.math.FlxPoint;
import game.Creature;
import gameLogic.moves.AttackMove;
import gameLogic.moves.ListOfMoves;
import gameLogic.moves.MoveMove;
import gameLogic.moves.MoveType;
import hex.BoardShape;
import hex.Hex;
import hex.HexCoordinates;
import hex.HexMap;
import source.BoardMap;

/**
 * ...
 * @author 
 */
class GameContext
{
	@:isVar static public var instance(get,set) : GameContext;
	static function get_instance() : GameContext
	{
		if (instance == null)
		{
			instance = new GameContext();
		}
		return instance;
	}
	
	static function set_instance(contex:GameContext)
	{
		return instance = contex;
	}
	
	public var map:HexMap;
	public var mapOfPlayers:Map<Int,Player>;
	private var _currentPlayerIndex:Int;
	public var currentPlayerIndex(get,set):Int;
	public var inititativeQueue:InitiativeQueue;
	private var currentPlayer:Player;
	
	public var stateMachine:GameStateMachine;
	
	public function new() 
	{
	}
	
	public function mapHeight():Int
	{
		return map.height;
	}
	
	public function mapWidth():Int
	{
		return map.width;
	}
	
	public function setHexImpassable(hex:hex.HexCoordinates)
	{
		map.setHexImpassable(hex);
	}
	public function setHexPassable(hex:hex.HexCoordinates)
	{
		map.setHexPassable(hex);
	}
	
	public function handleInput(input:Input)
	{
		//trace("input context");
		stateMachine.handleInput(input);
	}
	public function getNextCreature():Creature
	{
		return inititativeQueue.getNextCreature();
	}
	
	public function getPositionOnMapOddR(x:Int, y:Int):FlxPoint
	{
		return this.map.getHexCenterByAxialCor(HexCoordinates.fromOddR(x, y));
	}
	
	public function getPositionOnMap(coor:HexCoordinates):FlxPoint
	{
		return this.map.getHexCenterByAxialCor(coor);
	}
	
	public function Init(map:HexMap, listOfPlayers:Array<Player>)
	{
		this.map = map;
		this.mapOfPlayers = new Map<Int,Player>();
		for (player in listOfPlayers)
			mapOfPlayers.set(player.id, player);
		
		this.inititativeQueue = new InitiativeQueue();
		stateMachine = new GameStateMachine(this);
	}
	
	public function Start()
	{
		stateMachine.init();
	}
	
	public function getCreaturesInAttackRange(creature:Creature):PossibleAttacksInfo
	{
		var rangeInformation = map.getRange(creature.getTileId(), creature.attackRange, false);
		var attackTargets = new Map<Int,Creature>();
		var attackCenters = new List<FlxPoint>();
		var attackHexesIds = new Map<Int,Bool>();
		for (player in mapOfPlayers)
		{
			if (player.id != creature.idPlayerId)
			{
				for (playerCreature in player.creatures)
				{
					if (rangeInformation.exists(playerCreature.getTileId()))
					{
						attackTargets.set(playerCreature.getTileId(),playerCreature);
						attackCenters.push(map.getHexCenterByAxialCor(playerCreature.currentCordinates));
						attackHexesIds.set(playerCreature.getTileId(), true);
					}
				}
			}
			else
				continue;
		}
		return new PossibleAttacksInfo(attackTargets,attackCenters,attackHexesIds);
	}
	
	private function getCreatureAttackTargets(creature:Creature,listOfMoves:ListOfMoves,rangeInformation:Map<Int,Int>)
	{
		for (player in mapOfPlayers)
		{
			if (player.id != creature.idPlayerId)
			{
				for (playerCreature in player.creatures)
				{
						var attackPossiblites = map.getRange(playerCreature.getTileId(), creature.attackRange, false);
						for (hex in attackPossiblites)
						{
							if (rangeInformation.exists(hex))
								listOfMoves.addMove(new AttackMove(MoveType.Attack, playerCreature, hex));
						}
				}
			}
			else
				continue;
		}
	}
	
	public function generateListOfMovesForCreature(creature:Creature):ListOfMoves
	{
		var listOfMoves = new ListOfMoves();
		var range =  map.getRange(creature.getTileId(), creature.range, true);
		for (tileId in range)
		{
			listOfMoves.addMove(new MoveMove(MoveType.Move, tileId));
			
		}
		getCreatureAttackTargets(creature, listOfMoves, range);
		trace("Count of attack moves: " + listOfMoves.getListOCenters(MoveType.Attack).length);
		return listOfMoves;
	}
	
	public function onCreatureKilled(creature:Creature)
	{
		mapOfPlayers.get(creature.idPlayerId).onCreatureKilled(creature);
		inititativeQueue.removeCreatureFromQueue(creature);
		creature.disable();
		map.getGraph().setPassable(creature.getTileId());
	}
	
	private function getSumOfDead()
	{
		var numberOfDead = 0;
		for (player in mapOfPlayers)
		{
			numberOfDead += player.numberOfDead;
		}
		return numberOfDead;
	}
	
	public function get_currentPlayerIndex():Int
	{
		return _currentPlayerIndex;
	}
	
	public function set_currentPlayerIndex(index:Int)
	{
		currentPlayer = mapOfPlayers[index];
		return _currentPlayerIndex = index;
	}
	
	public function getNumberOfPlayers():Int
	{
		var counter = 0;
		for (player in mapOfPlayers)
			counter++;
		return counter;
	}
}