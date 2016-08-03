package gameLogic;
import flixel.math.FlxPoint;
import game.Creature;
import hex.BoardShape;
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
	public var listOfPlayers:Array<Player>;
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
	
	public function handleInput(input:Input)
	{
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
		this.listOfPlayers = listOfPlayers;
		this.inititativeQueue = new InitiativeQueue();
		stateMachine = new GameStateMachine(this);
	}
	
	public function Start()
	{
		stateMachine.init();
	}
	
	public function get_currentPlayerIndex():Int
	{
		return _currentPlayerIndex;
	}
	
	public function set_currentPlayerIndex(index:Int)
	{
		currentPlayer = listOfPlayers[index];
		return _currentPlayerIndex = index;
	}
	
	public function getNumberOfPlayers():Int
	{
		return listOfPlayers.length;
	}
	
}