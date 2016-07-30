package gameLogic;
import gameLogic.states.StartState;

/**
 * ...
 * @author ...
 */
class GameStateMachine extends StateMachine
{
	public var gameData:GameContext;
	
	public function new(gameData:GameContext); 
	{
		this.gameData = gameData;
		set_currentState(new StartState());
	}
	
}