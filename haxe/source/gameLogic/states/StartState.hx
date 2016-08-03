package gameLogic.states;

import gameLogic.GameStateMachine;
import gameLogic.Player;
import gameLogic.StateMachine;
import hex.HexCoordinates;

/**
 * ...
 * @author 
 */
class StartState extends State
{

	public function new(stateMachine:StateMachine) 
	{
		super(stateMachine);
		stateName = "Start Game";
	}
	
	private function selectRandomPlayer():Int
	{
		return Random.int(0, GameContext.instance.getNumberOfPlayers() - 1);
	}
	
	override public function onEnter():Void 
	{
		placeCreaturesOnMap();
		stateMachine.setCurrentState(new StartRound(this.stateMachine));
	}
	
	public function placeCreaturesOnMap()
	{
		var playerIndex = 0;
		for (player in GameContext.instance.listOfPlayers)
		{
			var creatureIndex = 0;
			for (creature in player.creatures)
			{
				var col = playerIndex % 2 == 0 ? 0 : GameContext.instance.mapWidth() - 1;
				var coor = HexCoordinates.fromOddR(creatureIndex, col);
				var point = GameContext.instance.getPositionOnMap(coor);
				creature.setPosition(point);
				creature.setCoodinates(coor);
				creatureIndex+=2;
			}
			playerIndex++;
		}
	}
}