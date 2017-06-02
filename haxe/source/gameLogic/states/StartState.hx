package gameLogic.states;

import gameLogic.GameStateMachine;
import gameLogic.GamePlayer;
import gameLogic.StateMachine;
import hex.HexCoordinates;
import hex.TestMapType;
import ui.ColorTable;
import utilites.ThreadProvider;
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
		GameContext.instance.map.reInitFinders();
		placeCreaturesOnMap();
		stateMachine.setCurrentState(new StartRound(this.stateMachine));
	}
	
	public function placeCreaturesOnMap()
	{
		
		switch(MainState.getInstance().typeTest)
		{
			case TestMapType.None:
				placeCreaturesOnMapRandom();
			case TestMapType.Small:
				placeCreaturesOnSmall();
			case TestMapType.Medium:
				placeCreaturesOnMedium();
			case TestMapType.Large:
				placeCreaturesOnLarge();
		}
	}
	
	private function placeCreaturesOnSmall()
	{
		var player : GamePlayer= GameContext.instance.mapOfPlayers.get(0);
		var hex = GameContext.instance.map.getHexByIndex(1);
		player.creatures[0].setPosition(hex.center);
		player.creatures[0].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(2);
		player.creatures[1].setPosition(hex.center);
		player.creatures[1].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(0);
		player.creatures[2].setPosition(hex.center);
		player.creatures[2].setCoodinates(hex.getCoor());
		
		player = GameContext.instance.mapOfPlayers.get(1);
		hex = GameContext.instance.map.getHexByIndex(8);
		player.creatures[0].setPosition(hex.center);
		player.creatures[0].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(7);
		player.creatures[1].setPosition(hex.center);
		player.creatures[1].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(12);
		player.creatures[2].setPosition(hex.center);
		player.creatures[2].setCoodinates(hex.getCoor());
	}
	
	private function placeCreaturesOnMedium()
	{
		var player : GamePlayer = GameContext.instance.mapOfPlayers.get(0);
		//////////////////////////////////////////////////////////
		var hex = GameContext.instance.map.getHexByIndex(5);
		player.creatures[0].setPosition(hex.center);
		player.creatures[0].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(4);
		player.creatures[1].setPosition(hex.center);
		player.creatures[1].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(1);
		player.creatures[2].setPosition(hex.center);
		player.creatures[2].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(12507503);
		player.creatures[3].setPosition(hex.center);
		player.creatures[3].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(0);
		player.creatures[4].setPosition(hex.center);
		player.creatures[4].setCoodinates(hex.getCoor());
		/////////////////////////////////////////////////
		player  = GameContext.instance.mapOfPlayers.get(1);
		hex = GameContext.instance.map.getHexByIndex(60);
		player.creatures[0].setPosition(hex.center);
		player.creatures[0].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(49);
		player.creatures[1].setPosition(hex.center);
		player.creatures[1].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(48);
		player.creatures[2].setPosition(hex.center);
		player.creatures[2].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(71);
		player.creatures[3].setPosition(hex.center);
		player.creatures[3].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(58);
		player.creatures[4].setPosition(hex.center);
		player.creatures[4].setCoodinates(hex.getCoor());
	}
	
	private function placeCreaturesOnLarge()
	{
		var player : GamePlayer = GameContext.instance.mapOfPlayers.get(0);
		//////////////////////////////////////////////////////////
		var hex = GameContext.instance.map.getHexByIndex(12522516);
		player.creatures[0].setPosition(hex.center);
		player.creatures[0].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(12517510);
		player.creatures[1].setPosition(hex.center);
		player.creatures[1].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(5);
		player.creatures[2].setPosition(hex.center);
		player.creatures[2].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(19);
		player.creatures[3].setPosition(hex.center);
		player.creatures[3].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(12522518);
		player.creatures[4].setPosition(hex.center);
		player.creatures[4].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(0);
		player.creatures[5].setPosition(hex.center);
		player.creatures[5].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(12512507);
		player.creatures[6].setPosition(hex.center);
		player.creatures[6].setCoodinates(hex.getCoor());
		/////////////////////////////////////////////////
		player  = GameContext.instance.mapOfPlayers.get(1);
		hex = GameContext.instance.map.getHexByIndex(59);
		player.creatures[0].setPosition(hex.center);
		player.creatures[0].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(97);
		player.creatures[1].setPosition(hex.center);
		player.creatures[1].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(82);
		player.creatures[2].setPosition(hex.center);
		player.creatures[2].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(68);
		player.creatures[3].setPosition(hex.center);
		player.creatures[3].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(128);
		player.creatures[4].setPosition(hex.center);
		player.creatures[4].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(66);
		player.creatures[5].setPosition(hex.center);
		player.creatures[5].setCoodinates(hex.getCoor());
		
		hex = GameContext.instance.map.getHexByIndex(95);
		player.creatures[6].setPosition(hex.center);
		player.creatures[6].setCoodinates(hex.getCoor());
	}
	
	private function placeCreaturesOnMapRandom()
	{
		//trace("start : placeCreaturesOnMap");
		
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
		//trace("end : placeCreaturesOnMap");
	}
}