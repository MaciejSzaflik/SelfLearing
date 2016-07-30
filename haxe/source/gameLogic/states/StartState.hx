package gameLogic.states;

import gameLogic.GameStateMachine;
import gameLogic.Player;
import gameLogic.StateMachine;

/**
 * ...
 * @author 
 */
class StartState extends State
{

	public function new(stateMachine:StateMachine) 
	{
		super(stateMachine);
		stateName = "Start";
	}
	
	private function selectRandomPlayer():Int
	{
		return Random.int(0, GameContext.instance.getNumberOfPlayers() - 1);
	}
	
	override public function onEnter():Void 
	{
		
	}
	
	public function placeCreaturesOnMap()
	{
		
	}
	
}