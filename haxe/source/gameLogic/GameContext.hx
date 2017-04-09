package gameLogic;
import data.CreatureDefinition;
import flixel.math.FlxPoint;
import game.Creature;
import gameLogic.ActionLog;
import gameLogic.actions.Action;
import gameLogic.ai.MinMax.MinMaxNode;
import gameLogic.ai.tree.TreeVertex;
import gameLogic.moves.ListOfMoves;
import gameLogic.moves.MoveData;
import gameLogic.moves.MoveType;
import gameLogic.queue.ContinuesQueue;
import gameLogic.queue.CreatureQueue;
import gameLogic.queue.InitiativeQueue;
import gameLogic.states.SelectMoveState;
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
	public var mapOfPlayers:Map<Int,GamePlayer>;
	public var currentPlayerIndex(get, set):Int;
	public var tileToCreature:Map<Int,Creature>;
	public var inititativeQueue:CreatureQueue;
	public var currentCreature:Creature;
	public var stateMachine:GameStateMachine;
	public var actionLog:ActionLog;
	
	public var creaturesMap:Map<Int,Creature>;
	
	private var currentPlayer:GamePlayer;
	private var _currentPlayerIndex:Int;
	
	public function new() 
	{
		set_instance(this);
		tileToCreature = new Map<Int,Creature>();
		actionLog = new ActionLog();
		creaturesMap = new Map<Int,Creature>();
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
		stateMachine.handleInput(input);
	}
	
	public function redrawCreaturesPositions()
	{
		for (creature in inititativeQueue.getQueueIterator())
		{
			creature.redrawPosition();
		}
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
		return inititativeQueue.getSizeOfQueue();
	}
	
	public function getPositionOnMapOddR(x:Int, y:Int):FlxPoint
	{
		return this.map.getHexCenterByAxialCor(HexCoordinates.fromOddR(x, y));
	}
	
	public function getPositionOnMap(coor:HexCoordinates):FlxPoint
	{
		return this.map.getHexCenterByAxialCor(coor);
	}
	
	public function Init(map:HexMap, listOfPlayers:Array<GamePlayer>)
	{
		this.map = map;
		this.mapOfPlayers = new Map<Int,GamePlayer>();
		for (player in listOfPlayers)
			mapOfPlayers.set(player.id, player);
		
		this.inititativeQueue = new ContinuesQueue();
		stateMachine = new GameStateMachine(this);
	}
	
	public function Start()
	{
		stateMachine.init();
	}
	
	public function getPlayerCreatures(playerId:Int):Array<Creature>
	{
		return mapOfPlayers.get(playerId).creatures;
	}
	
	public function getEnemies(playerId:Int):Array<Creature>
	{
		var enemies = new Array<Creature>();
		for (player in mapOfPlayers)
		{
			if (player.id != playerId)
			{
				enemies = enemies.concat(player.creatures);
			}
		}
		return enemies;
	}
	
	public function getEnemyCreatures(playerId):PossibleAttacksInfo
	{
		var attackTargets = new Map<Int,Creature>();
		var attackCenters = new List<FlxPoint>();
		var attackHexesIds = new Map<Int,Bool>();
		for (player in mapOfPlayers)
		{
			if (player.id != playerId)
			{
				for (playerCreature in player.creatures)
				{
						attackTargets.set(playerCreature.getTileId(),playerCreature);
						attackCenters.push(map.getHexCenterByAxialCor(playerCreature.currentCordinates));
						attackHexesIds.set(playerCreature.getTileId(), true);
				}
			}
			else
				continue;
		}
		return new PossibleAttacksInfo(attackTargets,attackCenters,attackHexesIds);
	}
	
	public function getEnemyId(id : Int) : Int
	{
		return id == 0 ? 1 : 0;
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
		if (creature.isRanger && !creature.moved)
			return getEnemiesInRange(creature.getTileId(), creature.attackRange, creature.idPlayerId);
		return getEnemiesInRange(creature.getTileId(), 1, creature.idPlayerId);
	}
	
	private function addMeleeAttacks(creature:Creature,listOfMoves:ListOfMoves,rangeInformation:Map<Int,Int>,enemies:Array<Creature>)
	{
		for (enemy in enemies)
		{	
			var attackPossiblites = map.findRangeNoObstacles(enemy.getTileId(), 1);
			for (hex in attackPossiblites)
			{
				if (rangeInformation.exists(hex))
				{
					var move = MoveData.createAttackMove(creature, MoveType.Attack, hex, enemy);
					listOfMoves.addMove(move);
				}
			}
		}
	}
	
	private function addRangerAttacks(creature:Creature, listOfMoves:ListOfMoves, rangeInformation:Map<Int,Int>, enemies:Array<Creature>)
	{
		if (creature.isRanger && !creature.moved)
		{
			if (creature.getEnemyNeighbours().lenght > 0)
				return;
			
			
			var range = map.findRangeNoObstacles(creature.getTileId(), creature.attackRange);
			for (enemy in enemies)
			{
				if (range.exists(enemy.getTileId()))
				{
					listOfMoves.addMove(MoveData.createAttackMove(creature, MoveType.Attack, creature.getTileId(), enemy));
				}
			}
		}
	}
	
	private function getCreatureAttackTargets(creature:Creature,listOfMoves:ListOfMoves,rangeInformation:Map<Int,Int>)
	{
		var enemies = getEnemies(creature.idPlayerId);
		addMeleeAttacks(creature, listOfMoves, rangeInformation, enemies);
		addRangerAttacks(creature, listOfMoves, rangeInformation, enemies);
	}
	
	public function generateMovesForCurrentCreature():ListOfMoves
	{
		return generateListOfMovesForCreature(currentCreature);
	}
	
	public function generateTreeVertexListMoves(root : TreeVertex<MinMaxNode>, creature :Creature) : List<TreeVertex<MinMaxNode>>
	{
		var toReturn : List<TreeVertex<MinMaxNode>> = new List<TreeVertex<MinMaxNode>>();
		for (move in generateListOfMovesForCreature(creature).moves)
		{
			var node : MinMaxNode = new MinMaxNode(0, move, null);
			node.playerId = creature.idPlayerId;
			toReturn.add(new TreeVertex<MinMaxNode>(root,node));
		}
		return toReturn;
	}
	
	
	public function generateListOfMovesForCreature(creature:Creature):ListOfMoves
	{
		var listOfMoves = new ListOfMoves();
		var range =  map.getRange(creature.getTileId(), creature.range, true);
		getCreatureAttackTargets(creature, listOfMoves, range);
		for (tileId in range)
			listOfMoves.addMove(new MoveData(creature,MoveType.Move, tileId));
			
		return listOfMoves;
	}
	
	public function generateListOfMoveMoves(creature:Creature):ListOfMoves
	{
		var listOfMoves = new ListOfMoves();
		var range =  map.getRange(creature.getTileId(), creature.range, true);
		for (tileId in range)
			listOfMoves.addMove(new MoveData(creature,MoveType.Move, tileId));
		return listOfMoves;
	}
	
	public function generateListOfAttackMoves(creature:Creature):ListOfMoves
	{
		var listOfMoves = new ListOfMoves();
		var range =  map.getRange(creature.getTileId(), creature.range, true);
		getCreatureAttackTargets(creature, listOfMoves, range);
		return listOfMoves;
	}
	
	public function onCreatureKilled(creature:Creature):Int
	{
		mapOfPlayers.get(creature.idPlayerId).onCreatureKilled(creature);
		creature.enable(false);
		map.getGraph().setPassable(creature.getTileId());
		return inititativeQueue.removeCreatureFromQueue(creature);
	}
	
	public function resurectCreature(creature:Creature, positionInQueue:Int)
	{
		mapOfPlayers.get(creature.idPlayerId).onCreatureResurected(creature);
		inititativeQueue.putCreatureOnIndex(creature,positionInQueue);
		creature.enable(true);
		map.getGraph().setImpassable(creature.getTileId());
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
	
	
	public function undoNextAction()
	{
		var backedAction = actionLog.goBack();
		if (backedAction == null)
			return false;
		return true;
		
		//inititativeQueue.putCreatureOnTop(currentCreature);	
			
		//resetCreaturesPositions();
		//inititativeQueue.putCreatureOnTop(backedAction.performer);
		//currentCreature = backedAction.performer;
		//stateMachine.setCurrentState(new SelectMoveState(stateMachine, inititativeQueue.getNextCreature()));
		//inititativeQueue.informOnFill();
	}
	public function redoNextAction()
	{
		//not yet
	}
	
	public function resetCreaturesPositions()
	{
		for (player in mapOfPlayers)
		{
			for (playerCreature in player.creatures)
			{
				playerCreature.setPosition(map.getHexCenterByAxialCor(playerCreature.currentCordinates));
				playerCreature.recalculateStackSize(playerCreature.totalHealth);
			}
		}
	}
}