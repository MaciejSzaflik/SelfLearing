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
import gameLogic.ai.BestMove;
import gameLogic.ai.MinMax;
import gameLogic.ai.RandomAI;
import gameLogic.ai.evaluation.KillTheWeakest;
import gameLogic.ai.evaluation.RiskByDistance;
import gameLogic.ai.evaluation.TotalHp;
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
	
	private var btnPlay:FlxButton;
	private var drawer:Drawer;
	private var hexMap:HexMap;
	private var stageDescription:StageDescription;
	
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
			drawMap(false);
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
			debugHexes[hex] = getDrawer().getDebugHex(point, Std.int(getHexMap().hexSize), 0x70FFFF00);
			debugTexts[hex] = new FlxText(point.x, point.y, 30, "0");
			add(debugTexts[hex]);
		}
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
		var player1 = new GamePlayer(0, CreateDubugCreatureList(2), ColorTable.PLAYER1_COLOR, PlayerType.Human,true);
		var player2 = new GamePlayer(1, CreateDubugCreatureList(2), ColorTable.PLAYER2_COLOR, PlayerType.Human,false);
		//player2.setAI(new BestMove(new KillTheWeakest(true)));
		//player1.setAI(new BestMove(new KillTheWeakest(true)));
		//player1.setAI(new RandomAI());
		GameContext.instance.Init(getHexMap(), [player1, player2]);
		CreateUIQueue();
		GameContext.instance.stateMachine.addNewStateChangeListener(function(state:String)
		{
			currentStateText.text = state;
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
					debugHexes[index].color = FlxColor.BLUE;
					debugHexes[index].alpha = realValue;
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
	
	private function CreateDubugCreatureList(count : Int):Array<Creature>
	{
		var creatureList = new Array<Creature>();
		var i = 0;
		while (i < count)
		{
			var creatureDefinition = GameConfiguration.instance.creatures.get(Random.int(0, 3));
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
		
		var startPoisitionX =  (mapWidth / FlxG.width)*0.28;
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
		//getDrawer().drawHexMap(getHexMap(), 0xffAAAA77, 0x00000000, 0);
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
				if(!isButtonMainInterface(params.toString()))
					GameContext.instance.stateMachine.handleButtonInput(params.toString());
				else
					handleButtonClick(params.toString());
			}
		}
	}
	
	private static var mainInterfaceButtons:Array<String> = ["back", "forward"];
	private function isButtonMainInterface(buttonName:String):Bool
	{
		return mainInterfaceButtons.indexOf(buttonName) != -1;
	}
	
	private function handleButtonClick(buttonName:String)
	{
		if (buttonName == "back")
			GameContext.instance.undoNextAction();
		else if (buttonName == "forward")
		{
			getDrawer().clear(0);
			getHexMap().DestroyBackground();
			this.hexMap = null;
			drawMap(true);
		}
	}
}
