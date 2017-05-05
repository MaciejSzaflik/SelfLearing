package gameLogic.states;

import animation.Tweener;
import game.Creature;
import gameLogic.Input;
import gameLogic.PossibleAttacksInfo;
import gameLogic.StateMachine;
import gameLogic.actions.ActionFactory;
import gameLogic.actions.AttackAction;
import gameLogic.actions.DefendAction;
import gameLogic.actions.MoveAction;
import gameLogic.actions.WaitAction;
import gameLogic.ai.CurrentStateData;
import gameLogic.moves.ListOfMoves;
import gameLogic.moves.MoveData;
import gameLogic.moves.MoveType;
import haxe.Constraints.Function;
import source.Drawer;
import source.animation.WaitFrame;
import ui.ColorTable;
import utilites.InputType;
import utilites.StatsGatherer;

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
	private var enableAnimations = false;
	
	public static var moveCounter = 0;
	
	private var beforeMove : CurrentStateData;
	private var moveTypeSelected : MoveType;
	
	public function new(stateMachine:StateMachine,creature:Creature) 
	{
		this.stateName = "Select Move";
		moveCounter++;
		super(stateMachine);
		clearAll();
		cleanUpImpossibleCreatures();
		
		if (checkEndCondition())
			return;
		
		GameContext.instance.currentPlayerIndex = creature.idPlayerId;
		
		beforeMove = CurrentStateData.CalculateForCreature(creature, MoveType.Pass);
		selectedCreature = creature;
		
		//trace(selectedCreature.totalHealth + " " + selectedCreature.isSpriteEnabled() + " " + selectedCreature.id);
		isHuman = GameContext.instance.typeOfCurrentPlayer() == PlayerType.Human;
		if(isHuman)
		{
			getMoveRange();
			getAttackRange();
		}
	}

	override public function onEnter():Void 
	{
		if (MainState.getInstance().gameEnded)
			return;
		
		GameContext.instance.mapOfPlayers.get(selectedCreature.idPlayerId).tryToGenerateMove(
			consumeMove, 
			onAIPlayer, 
			onAIPlayerEnd);
	}

	private function consumeMove(move : MoveData)
	{
		Creature.ignoreUpdate = false;

		handleMove(move);
	}
	
	private function onAIPlayerEnd():Void 
	{
		MainState.getInstance().HideHourglass();
	}
	
	private function onAIPlayer()
	{
		if (GameContext.instance.typeOfCurrentPlayer() == PlayerType.Human)
			return;
		
		try{
			MainState.getInstance().SaveMomento();
			Creature.ignoreUpdate = true;
			MainState.getInstance().RotateHourglass();
		} catch (msg : String)
		{
			trace(msg);
		}
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
			MainState.getInstance().drawHexesRange(moveList.getListOCenters(MoveType.Attack), 1, ColorTable.MOVE_RANGE_COLOR);
		
		attacksInfo = GameContext.instance.getCreaturesInAttackRange(selectedCreature);
		MainState.getInstance().drawHexesRange(attacksInfo.listOfCenters, 1, ColorTable.ATTACK_POSSIBLE_COLOR);
	}
	
	private function colorRange()
	{
		MainState.getInstance().drawHexesRange(moveList.getListOCenters(MoveType.Move), 1, ColorTable.MOVE_RANGE_COLOR);
	}
	private function colorHexStandingOn()
	{
		MainState.getInstance().drawHex(MainState.getInstance().getHexMap().getHexCenterByAxialCor(selectedCreature.currentCordinates),1,ColorTable.SELF_COLOR);
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
	
	override public function handleButtonClick(buttonName:String) 
	{
		if (isAnimationPlaying || !isHuman)
			return;
			
		if (buttonName == "wait")
			handleMove(new MoveData(selectedCreature,MoveType.Wait, -1));
		else if (buttonName == "defend")
			handleMove(new MoveData(selectedCreature,MoveType.Defend, -1));
		else if (buttonName == "ability")
			handleAbilitySelected();
	}
	
	function handleAbilitySelected()
	{
		var ability = selectedCreature.getActiviableAbility();
		if (ability != null)
			stateMachine.setCurrentState(new SelectAbilityTarget(this.stateMachine,selectedCreature,ability));
	}
	
	override function handleMove(move:MoveData) 
	{
		if (move == null)
			move = new MoveData(null, MoveType.Pass, -1);
		
		moveTypeSelected = move.type;
			
		if (move.type == MoveType.Move)
		{
			handleMoveAction(move,function() {		
				isAnimationPlaying = false;
				endState();
			});
		}
		else if (move.type == MoveType.Attack)
		{
			var attackAction = ActionFactory.actionFromMoveData(move,function(){endState();},enableAnimations);
			if (selectedCreature.getTileId() == move.tileId)
				attackAction.performAction();
			else
			{
				handleMoveAction(new MoveData(selectedCreature,MoveType.Move,move.tileId),function() {
					attackAction.performAction();
				});
			}
		}
		else if (move.type == MoveType.Pass)
			handleAction(move,endState);
		else if (move.type == MoveType.Defend)
			handleAction(move,endState);
		else if (move.type == MoveType.Wait)
			handleAction(move, endState);
			
		
	}
	
	private function handleMoveAction(moveData:MoveData,callBack:Function)
	{
		isAnimationPlaying = true; 
		selectedCreature.moved = true;
		
		clearAll();
		var action = ActionFactory.actionFromMoveData(moveData, callBack,enableAnimations);
		action.performAction();
	}
	
	private function handleAction(move:MoveData,callBack:Function)
	{
		clearAll();
		var action = ActionFactory.actionFromMoveData(move, callBack,enableAnimations);
		action.performAction();
	}

	private function clearAll()
	{
		MainState.getInstance().getDrawer().clear(1);
		MainState.getInstance().getDrawer().clear(2);
	}
	
	private function handle(callBack:Function)
	{
		clearAll();
		var action = new DefendAction(selectedCreature, callBack);
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
			moveTypeSelected = MoveType.Attack;
			var moveData = new MoveData(selectedCreature, MoveType.Attack, selectedCreature.getTileId());
			moveData.affected = attacksInfo.listOfCreatures.get(key);
			var attackAction = ActionFactory.actionFromMoveData(moveData,function(){endState();},enableAnimations);
			attackAction.performAction();
		}

	}
	
	private function endState()
	{
		selectedCreature.redrawPosition();
		var afterMove = CurrentStateData.CalculateForCreature(selectedCreature, moveTypeSelected);
		var result = CurrentStateData.Evaluate(beforeMove, afterMove);
		StatsGatherer.instance.onMovePerformed(result);
		
		if (checkEndCondition())
			return;
		else if (GameContext.instance.getSizeOfQueue() == 0)
			stateMachine.setCurrentState(new StartRound(this.stateMachine));
		else
		{
			Tweener.instance.addAnimation(new WaitFrame(1, function(){
				
				if (MainState.getInstance().gameEnded)
					return;
				
				stateMachine.setCurrentState(new SelectMoveState(this.stateMachine, GameContext.instance.getNextCreature()));
			}));
		}
	}
	
	private function cleanUpImpossibleCreatures()
	{
		for ( creature in GameContext.instance.creaturesMap)
		{
			//if(creature.totalHealth <= 0)
				//GameContext.instance.onCreatureKilled(creature);
		}
	}
	
	private function checkEndCondition() : Bool
	{
		var counterOfPlayersWithCreatures = 0;
		for (player in GameContext.instance.mapOfPlayers)
		{
			if (player.creatures.length != 0)
				counterOfPlayersWithCreatures++;
		}
		if (counterOfPlayersWithCreatures == 1 || moveCounter >= 100)
		{
			stateMachine.setCurrentState(new EndState(this.stateMachine));
			return true;
		}
		
		return false;
	}
	
	private function handleMoveClick(input:Input)
	{
		moveTypeSelected = MoveType.Move;
		handleMoveAction(new MoveData(selectedCreature,MoveType.Move,input.coor.toKey()), function() {		
				MainState.getInstance().getDrawer().clear(1);
				moveList.movesByTypes.remove(MoveType.Move);			
				checkAttackPossiblity();
				isAnimationPlaying = false;
		});

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
		
		MainState.getInstance().drawCircle(input.rawPosition, 2, ColorTable.POINTER_COLOR);
		if (!moveList.movesByTypes.exists(MoveType.Move) || 
			moveList.checkIfExist(MoveType.Move,input.getKey()) || 
			attacksInfo.listOfHex.exists(input.coor.toKey()))
			MainState.getInstance().drawHex(input.hexCenter, 2, ColorTable.POINTER_COLOR);
			
		//MainState.getInstance().drawHexesRangeIds(GameContext.instance.map.findRangeNoObstacles(input.coor.toKey(), 2), 2, ColorTable.POINTER_COLOR);
	}
	
	
}