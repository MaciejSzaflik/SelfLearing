package gameLogic;
import data.CreatureDefinition;
import flixel.math.FlxPoint;
import game.Creature;
import gameLogic.moves.ListOfMoves;
import gameLogic.moves.MoveData;
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
	static public var instance(get, set) : GameContext;
	static private var _instance : GameContext;
	static function get_instance() : GameContext
	{
		if (_instance == null)
		{
			_instance = new GameContext();
		}
		return _instance;
	}
	
	static function set_instance(contex:GameContext)
	{
		return _instance = contex;
	}
	
	public var map:HexMap;
	public var mapOfPlayers:Map<Int,Player>;
	public var currentPlayerIndex(get, set):Int;
	public var tileToCreature:Map<Int,Creature>;
	public var inititativeQueue:InitiativeQueue;
	public var currentCreature:Creature;
	public var stateMachine:GameStateMachine;
	
	private var currentPlayer:Player;
	private var _currentPlayerIndex:Int;
	
	public function new() 
	{
		tileToCreature = new Map<Int,Creature>();
	}
	
	public function mapHeight():Int
	{
		return map.height;
	}
	
	public function mapWidth():Int
	{
		return map.width;
	}
	
	public function changeCreatureHex(previousHex:HexCoordinates, currentHex:HexCoordinates, creature:Creature)
	{
		trace("changeCreatureHex: " + previousHex== null);
		if (previousHex != null)
		{
			setHexPassable(previousHex);
			tileToCreature.remove(previousHex.toKey());
		}
		setHexImpassable(currentHex);
		tileToCreature.set(currentHex.toKey(), creature);
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
	
	public function typeOfCurrentPlayer():PlayerType
	{
		return mapOfPlayers.get(currentCreature.idPlayerId).playerType;
	}
	
	public function getNextCreature():Creature
	{
		currentCreature = inititativeQueue.getNextCreature();
		return currentCreature;
	}
	
	public function getSizeOfQueue():Int
	{
		return inititativeQueue.queue.length;
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
	
	public function getCreaturesInRange(rangeCenter:Int, rangeSize:Int, playerId:Int, checkPlayer:Bool = false):PossibleAttacksInfo
	{
		var rangeInformation = map.getRange(rangeCenter, rangeSize, false);
		var attackTargets = new Map<Int,Creature>();
		var attackCenters = new List<FlxPoint>();
		var attackHexesIds = new Map<Int,Bool>();
		for (player in mapOfPlayers)
		{
			if (!checkPlayer || player.id != playerId)
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
	public function getEnemiesInRange(rangeCenter:Int, rangeSize:Int, playerId:Int):PossibleAttacksInfo
	{
		return getCreaturesInRange(rangeCenter, rangeSize, playerId, true);
	}
	
	public function getCreaturesInAttackRange(creature:Creature):PossibleAttacksInfo
	{
		return getEnemiesInRange(creature.getTileId(), creature.attackRange, creature.idPlayerId);
	}
	
	private function getCreatureAttackTargets(creature:Creature,listOfMoves:ListOfMoves,rangeInformation:Map<Int,Int>)
	{
		var creatureEffectiveRange = creature.isRanger?1:creature.attackRange;
		for (player in mapOfPlayers)
		{
			if (player.id != creature.idPlayerId)
			{
				for (playerCreature in player.creatures)
				{
					
						var attackPossiblites = map.getRange(playerCreature.getTileId(), creatureEffectiveRange, false);
						for (hex in attackPossiblites)
						{
							if (rangeInformation.exists(hex))
							{
								var move = MoveData.createAttackMove(MoveType.Attack, hex, playerCreature);
								listOfMoves.addMove(move);
							}
						}
				}
			}
			else
				continue;
		}
		if (creature.isRanger)
		{
			var attackPosbilites = getCreaturesInAttackRange(creature);
			for (enemyCreature in attackPosbilites.listOfCreatures)
			{
				var move = MoveData.createAttackMove(MoveType.Attack, creature.getTileId(), enemyCreature);
				listOfMoves.addMove(move);
			}
		}
	}
	
	public function generateMovesForCurrentCreature():ListOfMoves
	{
		return generateListOfMovesForCreature(currentCreature);
	}
	
	public function generateListOfMovesForCreature(creature:Creature):ListOfMoves
	{
		var listOfMoves = new ListOfMoves();
		var range =  map.getRange(creature.getTileId(), creature.range, true);
		for (tileId in range)
		{
			listOfMoves.addMove(new MoveData(MoveType.Move, tileId));
			
		}
		getCreatureAttackTargets(creature, listOfMoves, range);
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