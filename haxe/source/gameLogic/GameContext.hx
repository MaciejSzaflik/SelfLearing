package gameLogic;
import hex.BoardShape;
import hex.HexMap;
import source.BoardMap;

/**
 * ...
 * @author 
 */
class GameContext
{
	static public var instance(get,never) : GameContext;
	function get_instance() : GameContext
	{
		if (instance == null)
		{
			instance == new GameContext();
		}
		return instance;
	}
	
	public var map:HexMap;
	public var listOfPlayers:Array<Player>;
	public var currentPlayerIndex(get,set):Int;
	public var inititativeQueue:InitiativeQueue;
	private var currentPlayer:Player;
	
	public var stateMachine:GameStateMachine;
	
	public function new() 
	{
		stateMachine = new GameStateMachine();
	}
	
	public function Init(map:HexMap, numberOfPlayers:Int)
	{
		
	}
	
	public function get_currentPlayerIndex():Int
	{
		return currentPlayerIndex;
	}
	
	public function set_currentPlayerIndex(index:Int)
	{
		currentPlayerIndex = index;
		currentPlayer = listOfPlayers[index];
	}
	
	public function getNumberOfPlayers():Int
	{
		return listOfPlayers.length;
	}
	
}