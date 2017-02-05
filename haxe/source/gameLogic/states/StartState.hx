package gameLogic.states;

import gameLogic.GameStateMachine;
import gameLogic.GamePlayer;
import gameLogic.StateMachine;
import hex.HexCoordinates;
import ui.ColorTable;
import utilites.UtilUtil;

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
		trace("start : placeCreaturesOnMap");
		GameContext.instance.map.reInitFinders();
		var playerIndex = 0;
		for (player in GameContext.instance.mapOfPlayers)
		{
			var rangeSize = 1;
			var range = new Map<Int,Int>();
			
			var hexIndex = playerIndex%2==0?GameContext.instance.map.findMinXHex().getIndex():GameContext.instance.map.findMaxXHex().getIndex();
			do
			{
				range = GameContext.instance.map.getRange(hexIndex, rangeSize, true);
				rangeSize++;
			}
			while (UtilUtil.CountMap(range) < player.creatures.length);
			
			for (creature in player.creatures)
			{
				var key = Random.fromIterable(range);
				range.remove(key);
				var hex = GameContext.instance.map.getHexByIndex(key);
				creature.setPosition(hex.center);
				creature.setCoodinates(hex.getCoor());
			}
			
			playerIndex++;
		}
		trace("end : placeCreaturesOnMap");
	}
}