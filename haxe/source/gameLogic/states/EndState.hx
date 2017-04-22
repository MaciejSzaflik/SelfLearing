package gameLogic.states;

import gameLogic.StateMachine;
import utilites.StatsGatherer;

/**
 * ...
 * @author 
 */
class EndState extends State
{

	public function new(stateMachine:StateMachine) 
	{
		super(stateMachine);
		this.stateName = "End";
		
		MainState.getInstance().getDrawer().clear(1);
		MainState.getInstance().getDrawer().clear(2);
		
		trace(GameContext.instance.mapOfPlayers.get(0).creatures.length);
		
		StatsGatherer.instance.finish();
	}
	
}