package gameLogic;
import gameLogic.states.StartState;

/**
 * ...
 * @author ...
 */
class GameStateMachine extends StateMachine
{
	public var gameData:GameContext;
	
	public function new(gameData:GameContext)
	{
		this.gameData = gameData;
	   
		super();
	}
	public function init()
	{
		this.currentState = new StartState(this);
	}
	
}