package;

import animation.Tweener;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUITypedButton;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import game.Creature;
import game.StageDescription;
import gameLogic.GameContext;
import gameLogic.Input;
import gameLogic.GamePlayer;
import gameLogic.PlayerType;
import gameLogic.actions.ActionFactory;
import gameLogic.ai.AlphaBeta;
import gameLogic.ai.BestMove;
import gameLogic.ai.EnemyQueue;
import gameLogic.ai.MinMax;
import gameLogic.ai.RandomAI;
import gameLogic.ai.evaluation.BasicBoardEvaluator;
import gameLogic.ai.evaluation.EnemySelectEvaluation;
import gameLogic.ai.evaluation.EvaluationResult;
import gameLogic.ai.evaluation.KillTheWeakest;
import gameLogic.ai.evaluation.RewardBasedEvaluation;
import gameLogic.ai.evaluation.RiskByDistance;
import gameLogic.ai.evaluation.RiskMinimaizer;
import gameLogic.ai.evaluation.TotalHp;
import gameLogic.ai.tree.TreeVertex;
import gameLogic.moves.MoveType;
import haxe.Timer;
import hex.HexMap;
import hex.HexTopping;
import hex.RectangleHexMap;
import openfl.events.Event;
import source.Drawer;
import source.SpriteFactory;
import ui.ColorTable;
import ui.PortraitsQueue;
import utilites.GameConfiguration;
import utilites.InputType;
import utilites.MathUtil;
import utilites.ThreadProvider;

using flixel.util.FlxSpriteUtil;

class MainState extends FlxUIState
{
	static private var instance:MainState;
	static public function getInstance() : MainState
	{
		return instance;
	}
	
	public var stageDescription:StageDescription;

	private var btnPlay:FlxButton;
	private var drawer:Drawer;
	private var hexMap:HexMap;
	
	private var fpsText:FlxText;
	private var debugText:FlxText;
	private var currentStateText:FlxText;
	
	private var evaluationPlayer1:FlxText;
	private var evaluationPlayer2:FlxText;
	private var debugHexes: Map<Int,FlxSprite>;
	private var debugTexts: Map<Int,FlxText>;
	
	private var portraitQueue:PortraitsQueue;
	
	public function getHexMap() : HexMap
	{
		if (hexMap == null)
			createMap();
		return hexMap;
	}
	public function getDrawer() : Drawer
	{
		if (drawer == null)
			createDrawer();
		return drawer;
	}

	override public function create():Void
	{
		_xml_id = "battle_state";
		super.create();
		
	    GameConfiguration.init(function(){
			instance = this;
			
			stageDescription = new StageDescription();
			stageDescription.InitTestStage();
			drawMap(true);
			addText();
			CreateDebugMap();
			CreateGameContex();
		});
	}
	
	private function CreateDebugMap()
	{
		debugHexes = new Map<Int,FlxSprite>();
		debugTexts = new Map<Int,FlxText>();
		for (hex in getHexMap().getGraph().getVertices().keys())
		{
			var point = getHexMap().getHexCenter(hex);
			debugHexes[hex] = getDrawer().getDebugHex(point, Std.int(getHexMap().hexSize), 0x05FFFF00);
			debugTexts[hex] = new FlxText(point.x - 10, point.y, 40, "0");
			add(debugTexts[hex]);
		}
		EnableDebugRisk(false);
	}
	
	private function CreateUIQueue()
	{
		var uiRightPanel:FlxUI9SliceSprite = cast _ui.getAsset("right_panel");
		var uiQueue:FlxUI9SliceSprite = cast _ui.getAsset("queue_panel");
		var uiPortrait:FlxUI9SliceSprite = cast _ui.getAsset("portrait_panel");
		
		portraitQueue = new PortraitsQueue(GameContext.instance.inititativeQueue, uiQueue,uiPortrait, uiRightPanel.height, 64);
	}

	private function CreateGameContex()
	{
		var player1 = new GamePlayer(0, DebugArmy(), ColorTable.PLAYER1_COLOR, PlayerType.Human,true);
		var player2 = new GamePlayer(1, DebugArmy(), ColorTable.PLAYER2_COLOR, PlayerType.Human,false);
		GameContext.instance.Init(getHexMap(), [player1, player2]); 
		//player2.setAI(new EnemyQueue(1, new EnemySelectEvaluation()));
		//player1.setAI(new EnemyQueue(1, new RewardBasedEvaluation()));
		CreateUIQueue();
		GameContext.instance.stateMachine.addNewStateChangeListener(function(state:String)
		{
			if (state == "Start Game")
				return;
			
			var evaluator : BasicBoardEvaluator = new BasicBoardEvaluator();
			var result = evaluator.evaluateState(0, 1);
			currentStateText.text = state;
			evaluationPlayer1.text = "Pl1: " + result._0;
			evaluationPlayer2.text = "Pl1: " + result._1;

		});
		
		GameContext.instance.stateMachine.addNewStateChangeListener(function(state:String)
		{
			if(state == "Select Move")
				ShowRiskByDistance();
				
		});
				
		GameContext.instance.Start();
	}
	
	private function ShowRiskByDistance()
	{
		if (!debugEnabled)
			return;
		
		ThreadProvider.instance.AddTask(function(){
			getDrawer().clear(3);
			var boardEvaluation = new RiskByDistance();
			var values = boardEvaluation.evaluateBoard(
				getHexMap(),  
				GameContext.instance.mapOfPlayers.get(0).creatures[0], 
				GameContext.instance.mapOfPlayers.get(1).creatures);
			for (index in values.values.keys())	
			{
				var realValue = values.values[index] / values.maxValue;
				if (debugHexes.exists(index))
				{
					debugHexes[index].color = FlxColor.PURPLE;
					debugHexes[index].alpha = realValue*0.75;
					debugTexts[index].text = Std.string(values.values[index]);
				}
			}
		});
	}
	
	private function GetSingleCreature(creature:Int,count:Int):Array<Creature>
	{
		var creatureList = new Array<Creature>();
		var creatureDefinition = GameConfiguration.instance.creatures.get(creature);
		var creature = Creature.fromDefinition(creatureDefinition,count);
		creatureList.push(creature);
		creature.addCreatureToState(this);
		return creatureList;
	}
	
	
	private function DebugArmy():Array<Creature>
	{
		var creatureList = new Array<Creature>();
		
		var knightDefinition = GameConfiguration.instance.creatures.get(0);
		var archerDefinition = GameConfiguration.instance.creatures.get(1);
		var priestDefinition = GameConfiguration.instance.creatures.get(2);
		
		var knight = Creature.fromDefinition(knightDefinition,15);
		creatureList.push(knight);
		knight.addCreatureToState(this);
		knight = Creature.fromDefinition(knightDefinition,15);
		creatureList.push(knight);
		knight.addCreatureToState(this);
		knight = Creature.fromDefinition(knightDefinition,15);
		creatureList.push(knight);
		knight.addCreatureToState(this);
		knight = Creature.fromDefinition(knightDefinition,15);
		creatureList.push(knight);
		knight.addCreatureToState(this);
		knight = Creature.fromDefinition(priestDefinition,15);
		creatureList.push(knight);
		knight.addCreatureToState(this);
		
		
		var archer = Creature.fromDefinition(archerDefinition,10);
		creatureList.push(archer);
		archer.addCreatureToState(this);
		archer = Creature.fromDefinition(archerDefinition,10);
		creatureList.push(archer);
		archer.addCreatureToState(this);
		archer = Creature.fromDefinition(archerDefinition,10);
		creatureList.push(archer);
		archer.addCreatureToState(this);
		
		return creatureList;
	}
	
	private function CreateDubugCreatureList(count : Int):Array<Creature>
	{
		var creatureList = new Array<Creature>();
		var i = 0;
		while (i < count)
		{
			var creatureDefinition = GameConfiguration.instance.creatures.get(Random.int(0, 1));
			var creature = Creature.fromDefinition(creatureDefinition,Random.int(10,12));
			creatureList.push(creature);
			creature.addCreatureToState(this);
			i++;
		}
		return creatureList;
	}
	
	private function addText()
	{
		fpsText = new FlxText(0, 0, 500);
		debugText = new FlxText(0, 10, 500);
		currentStateText = new FlxText(0, 20, 500);
		
		evaluationPlayer1 = new FlxText(FlxG.width / 2, FlxG.height - 40,500, "Eval 1:");
		evaluationPlayer2 = new FlxText(FlxG.width / 2, FlxG.height - 20,500, "Eval 2:");
		
		add(fpsText);
		add(debugText);
		add(currentStateText);
		
		add(evaluationPlayer1);
		add(evaluationPlayer2);
	}
	
	private function setTextToTextObj(textObj:FlxText, text:String)
	{
		if (textObj != null)
			textObj.text = text;
	}
	
	private function createMap():Void
	{
		var mapWidth = stageDescription.mapCols * stageDescription.mapHexSize;
		var mapHeight = stageDescription.mapRows * stageDescription.mapHexSize*0.75;
		
		var startPoisitionX =  0.15 + stageDescription.mapHexSize/ FlxG.width;
		
		var startPoisitionY = 1 - ((1- (mapHeight / FlxG.height))*0.82);
		var mapCenter = new FlxPoint(FlxG.width * startPoisitionX, FlxG.height * startPoisitionY);
		this.hexMap = new RectangleHexMap(
			mapCenter,
			stageDescription.mapHexSize,
			stageDescription.mapCols,
			stageDescription.mapRows,
			stageDescription.waterLevel);
			
		this.hexMap.InitPoints();
	}
	private function createDrawer():Void
	{
		this.drawer = new Drawer(4,this);
	}
	private function drawMap(drawDebug:Bool):Void
	{
		getHexMap().createBackground();
		if(drawDebug)
			drawDebugGraph(0);
	}
	
	public function drawHexesRangeIds(range:Map<Int,Int>,layer:Int,color:FlxColor)
	{
		for (hex in range)  
			getDrawer().drawHex(getHexMap().getHexCenter(hex), getHexMap().hexSize, HexTopping.Pointy, color, layer); 
	}
	
	public function drawHexesRange(range:List<FlxPoint>,layer:Int,color:FlxColor)
	{
		for (hex in range)  
			getDrawer().drawHex(hex, getHexMap().hexSize, HexTopping.Pointy, color, layer); 
	}
	public function drawHex(position:FlxPoint, layer:Int, color:FlxColor) : FlxSprite
	{
		return getDrawer().drawHex(position, getHexMap().hexSize, HexTopping.Pointy, color, layer); 
	}
	public function drawHexId(hex:Int, layer:Int, color:FlxColor) : FlxSprite
	{
		return drawHex(getHexMap().getHexCenter(hex), layer, color); 
	}
	
	public function drawCircle(position:FlxPoint,layer:Int,color:FlxColor)
	{
		getDrawer().drawCircle(position,5, color, layer); 
	}
	
	private function drawDebugGraph(layer:Int):Void
	{
		var lines = getHexMap().getArrayOfPoints(getHexMap().getGraph());
		getDrawer().drawListOfLines(lines, 0x6600FF00, layer);
		
		var lines = getHexMap().getArrayOfPoints(getHexMap().getGraph().subGraph);
		getDrawer().drawListOfLines(lines, 0x66FF0000, layer);
	}

	override public function update(elapsed:Float):Void
	{
		if (instance == null)
			return;
		
		setTextToTextObj(fpsText, Math.floor(1.0 / FlxG.elapsed) + ":time");
		
		Tweener.instance.update(elapsed);
		onMouse();
		
		if (FlxG.mouse.justReleased)
		{
			onClick();
		}
		
		super.update(elapsed);
	}
	
	private function onClick()
	{
		GameContext.instance.handleInput(getInputFromMouse(InputType.click));
	}
	
	private function onMouse()
	{
		var input = getInputFromMouse(InputType.move);
		setTextToTextObj(debugText,input.coor.toString() + " " + input.coor.toKey());
		
		GameContext.instance.handleInput(input);
	}
	
	private function getInputFromMouse(type:InputType)
	{
		var mousePoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
		var coor = getHexMap().positionToHex(mousePoint);
		var center = getHexMap().getHexCenterByAxialCor(coor);
		
		return new Input(type, center, mousePoint, coor);
	}
	
	private override function reloadUI(?e:Event):Void
	{
		super.reloadUI(e);
	}
	
	public override function getRequest(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Dynamic
	{
		return null;
	}	
	
	public override function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void
	{
		if (params != null)
		{
			if (name == FlxUITypedButton.CLICK_EVENT)
			{
				if (!isButtonMainInterface(params[0].toString()))
				{
					GameContext.instance.stateMachine.handleButtonInput(params[0].toString());
				}
				else
					handleButtonClick(params[0].toString());
			}
		}
	}
	
	private static var mainInterfaceButtons:Array<String> = ["back", "debug", "eval_1", "eval_2","eval_3"];
	private function isButtonMainInterface(buttonName:String):Bool
	{
		return mainInterfaceButtons.indexOf(buttonName) != -1;
	}
	
	private function handleButtonClick(buttonName:String)
	{
		if (buttonName == "back")
			GameContext.instance.undoNextAction();
		else if (buttonName == "debug")
			EnableDebugRisk(!debugEnabled);
		else if (buttonName == "eval_1")
		{
			var a1 = new EnemyQueue(GameContext.instance.currentPlayerIndex, new EnemySelectEvaluation());	
			var result = a1.getEvaluationResult();
			EvalCurrentSituation(!evalShown,result);
		}
		else if (buttonName == "eval_2")
		{
			var a1 = new EnemyQueue(GameContext.instance.currentPlayerIndex, new RewardBasedEvaluation());	
			var result = a1.getEvaluationResult();
			EvalCurrentSituation(!evalShown,result);
		}
		else if (buttonName == "eval_3")
		{
			var boardEvaluator : BasicBoardEvaluator = new BasicBoardEvaluator();
			var minimaxNode = new MinMaxNode(0, null, null);

			var treeVertex = new TreeVertex<MinMaxNode>();
			treeVertex.value = minimaxNode;
			treeVertex.value.playerId = GameContext.instance.currentPlayerIndex;
			var playerId = GameContext.instance.currentPlayerIndex;
			var enemyPlayerId =  GameContext.instance.currentPlayerIndex == 0 ? 1 : 0;
			
			
			var totalTimer = 0;
			var moveGenerationTimer = 0;
			var evaluationTimer = 0;
			
			var result = AlphaBeta.genericAlfaBeta(2, 0, treeVertex,
				function(node : MinMaxNode) { 
					var action = ActionFactory.actionFromMoveData(node.moveData, null);
					action.performAction();
					
					var value = boardEvaluator.evaluateStateSingle(playerId, enemyPlayerId);
					
					GameContext.instance.undoNextAction();
					return value;
				},
				function(node : MinMaxNode) {
					return node.playerId == playerId;
				},
				function(vertex : TreeVertex<MinMaxNode>){
					if (vertex.value.moveData != null)
					{
						var action = ActionFactory.actionFromMoveData(vertex.value.moveData, null);
						action.performAction();
					}
					return GameContext.instance.generateTreeVertexListMoves(vertex);
					
				}, -1000000, 1000000,
				function(node : MinMaxNode) { 
					return GameContext.instance.undoNextAction();
				});
				
			trace(result);
		}
	}
	
	private var debugEnabled:Bool = false;
	private var evalShown:Bool = false;
	private function EvalCurrentSituation(enable:Bool, evaluation:EvaluationResult)
	{
		evalShown = enable;
		for (text in debugTexts)
		{
			if (enable)
			{
				text.revive();
				text.text = "";
			}
			else
				text.kill();
		}
		
		for (hex in debugHexes)
		{
			if (enable)
			{
				hex.revive();
				hex.color = FlxColor.WHITE;
			}
			else
				hex.kill();
		}
		
		for (i in 0...evaluation.evaluationResults.length)
		{
			var moveData = evaluation.listOfMoves.moves[i];
			if (moveData.type == MoveType.Move)
			{
				debugHexes[moveData.tileId].color = FlxColor.PURPLE;
				debugTexts[moveData.tileId].text = "M:" + evaluation.evaluationResults[i];
			}
			else if(moveData.type == MoveType.Attack)
			{
				var tile = moveData.affected.getTileId();
				debugHexes[moveData.tileId].color = FlxColor.YELLOW;
				debugHexes[tile].color = FlxColor.ORANGE;
				debugTexts[tile].text = "A:" + evaluation.evaluationResults[i];
			}
		}
	}
	private function EnableDebugRisk(enable:Bool)
	{
		debugEnabled = enable;
		for (text in debugTexts)
		{
			if(enable)
				text.revive();
			else
				text.kill();
		}
		for (hex in debugHexes)
		{
			if(enable)
				hex.revive();
			else
				hex.kill();
		}
	}
}
