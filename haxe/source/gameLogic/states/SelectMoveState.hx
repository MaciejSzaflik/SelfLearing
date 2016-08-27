package gameLogic.states;

import game.Creature;
import gameLogic.Input;
import gameLogic.PossibleAttacksInfo;
import gameLogic.StateMachine;
import gameLogic.actions.AttackAction;
import gameLogic.actions.MoveAction;
import gameLogic.moves.ListOfMoves;
import gameLogic.moves.MoveData;
import gameLogic.moves.MoveType;
import haxe.Constraints.Function;
import utilites.InputType;

/**
 * ...
 * @author 
 */
class SelectMoveState extends State
{
	private var selectedCreature:Creature;
	private var moveList:ListOfMoves;
	private var attacksInfo:PossibleAttacksInfo;
	
	private var isAnimationPlaying = false;
	private var isHuman = false;
	
	public function new(stateMachine:StateMachine) 
	{
		this.stateName = "Select Move";
		super(stateMachine);
		trace("--------------------------------------");
		getNextCreature();
		isHuman = GameContext.instance.typeOfCurrentPlayer() == PlayerType.Human;
		if(isHuman)
		{
			getMoveRange();
			getAttackRange();
		}
	}
	
	private function getNextCreature()
	{
		selectedCreature = GameContext.instance.getNextCreature();
	}
	
	override public function onEnter():Void 
	{
		var move = GameContext.instance.mapOfPlayers.get(selectedCreature.idPlayerId).generateMove();
		if (move != null)
			handleMove(move);
	}
	
	private function getMoveRange()
	{
		moveList = GameContext.instance.generateListOfMovesForCreature(selectedCreature);
		
		MainState.getInstance().getDrawer().clear(1);
		colorRange();
		colorHexStandingOn();
	}
	
	private function getAttackRange()
	{
		if(!selectedCreature.moved)
			MainState.getInstance().drawHexesRange(moveList.getListOCenters(MoveType.Attack), 1, 0x44ccffff);
		
		attacksInfo = GameContext.instance.getCreaturesInAttackRange(selectedCreature);
		MainState.getInstance().drawHexesRange(attacksInfo.listOfCenters, 1, 0xaaee1111);
	}
	
	private function colorRange()
	{
		MainState.getInstance().drawHexesRange(moveList.getListOCenters(MoveType.Move), 1, 0x440033ff);
	}
	private function colorHexStandingOn()
	{
		MainState.getInstance().drawHex(MainState.getInstance().getHexMap().getHexCenterByAxialCor(selectedCreature.currentCordinates),1,0x99ff0000);
	}
	
	override public function handleInput(input:Input) 
	{
		if (isAnimationPlaying || !isHuman)
			return;
		
		if (input.type == InputType.move)
			handleMouseMove(input);
		else
			handleClick(input);
	}
	
	override function handleMove(move:MoveData) 
	{
		if (move.type == MoveType.Move)
		{
			handleMoveAction(function() {		
				isAnimationPlaying = false;
				endState();
			},move.tileId);
		}
		else if (move.type == MoveType.Attack)
		{
			var attackAction = new AttackAction(selectedCreature,move.attacked);
			if (selectedCreature.getTileId() == move.tileId)
			{
				attackAction.performAction();
				endState();
			}
			else
			{
				handleMoveAction(function() {
					attackAction.performAction();
					endState();
				},move.tileId);
			}
		}
		else if (move.type == MoveType.Pass)
		{
			endState();
		}
	}
	
	private function handleMoveAction(callBack:Function,whereTile:Int)
	{
		isAnimationPlaying = true; 
		selectedCreature.moved = true;
		
		MainState.getInstance().getDrawer().clear(1);
		MainState.getInstance().getDrawer().clear(2);
		
		var action = new MoveAction(selectedCreature,whereTile,callBack);
		action.performAction();
	}
	
	private function handleClick(input:Input)
	{
		var key = input.coor.toKey();
		if (moveList !=null && moveList.checkIfExist(MoveType.Move,input.getKey()))
		{
			handleMoveClick(input);
		}
		else if (attacksInfo != null && attacksInfo.listOfHex.exists(key))
		{
			handleAttackClick(key);
		}
		else if (!moveList.movesByTypes.exists(MoveType.Move))
			endState();
	}
	
	private function handleAttackClick(key:Int)
	{
		if (attacksInfo.listOfCreatures.exists(key))
		{
			var attackAction = new AttackAction(selectedCreature, attacksInfo.listOfCreatures.get(key));
			attackAction.performAction();
		}
		endState();
	}
	
	private function endState()
	{
		var counterOfPlayersWithCreatures = 0;
		for (player in GameContext.instance.mapOfPlayers)
		{
			if (player.creatures.length != 0)
				counterOfPlayersWithCreatures++;
		}
		if (counterOfPlayersWithCreatures == 1)
			stateMachine.setCurrentState(new EndState(this.stateMachine));
		else
			stateMachine.setCurrentState(new SelectMoveState(this.stateMachine));
	}
	
	private function handleMoveClick(input:Input)
	{
		handleMoveAction(function() {		
				MainState.getInstance().getDrawer().clear(1);
				moveList.movesByTypes.remove(MoveType.Move);			
				checkAttackPossiblity();
				isAnimationPlaying = false;
		},input.coor.toKey());
	}
	
	
	private function checkAttackPossiblity()
	{
		getAttackRange();
		if (attacksInfo.lenght <= 0)
			endState();
	}
	
	private function handleMouseMove(input:Input) 
	{
		MainState.getInstance().getDrawer().clear(2);
		if (!moveList.movesByTypes.exists(MoveType.Move) || 
			moveList.checkIfExist(MoveType.Move,input.getKey()) || 
			attacksInfo.listOfHex.exists(input.coor.toKey()))
			MainState.getInstance().drawHex(input.hexCenter, 2,0x99ffffff);
	}
	
	
}