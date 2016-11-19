package;

import animation.Tweener;
import flixel.FlxG;
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
import gameLogic.ai.evaluation.KillTheWeakest;
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
			drawMap();
			addText();
			CreateGameContex();
		});	
	}
	
	private function CreateUIQueue()
	{
		var uiRightPanel:FlxUI = cast _ui.getAsset("right_panel");
		var uiQueue:FlxUI9SliceSprite = cast _ui.getAsset("queue_panel");
		var uiPortrait:FlxUI9SliceSprite = cast _ui.getAsset("portrait_panel");
		portraitQueue = new PortraitsQueue(GameContext.instance.inititativeQueue, uiQueue,uiPortrait, uiRightPanel.height, 64);
		
		
	}

	private function CreateGameContex()
	{
		var player1 = new GamePlayer(0, CreateDubugCreatureList(), ColorTable.PLAYER1_COLOR, PlayerType.Human,true);
		var player2 = new GamePlayer(1, CreateDubugCreatureList(), ColorTable.PLAYER2_COLOR, PlayerType.Human,false);
		//player2.setAI(new BestMove(new KillTheWeakest(false)));
		//player1.setAI(new BestMove(new KillTheWeakest(true)));
		GameContext.instance.Init(getHexMap(), [player1, player2]);
		CreateUIQueue();
		GameContext.instance.stateMachine.addNewStateChangeListener(function(state:String)
		{
			currentStateText.text = state;
		});
		
		GameContext.instance.Start();
	}
	
	private function CreateDubugCreatureList():Array<Creature>
	{
		var creatureList = new Array<Creature>();
		var i = 0;
		while (i < 8)
		{
			var creatureDefinition = GameConfiguration.instance.creatures.get(Random.int(0,3));
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
		add(fpsText);
		add(debugText);
		add(currentStateText);
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
			stageDescription.mapRows);
			
		this.hexMap.InitPoints();
	}
	private function createDrawer():Void
	{
		this.drawer = new Drawer(7,this);
	}
	private function drawMap():Void
	{
		getHexMap().createBackground();
		getDrawer().drawHexMap(getHexMap(), 0xffAAAA77, 0x00000000, 0);
	}
	
	public function drawHexesRange(range:List<FlxPoint>,layer:Int,color:FlxColor)
	{
		for (hex in range)  
			drawer.drawHex(hex, getHexMap().hexSize, HexTopping.Pointy, color, layer); 
	}
	public function drawHex(position:FlxPoint,layer:Int,color:FlxColor)
	{
		drawer.drawHex(position, getHexMap().hexSize, HexTopping.Pointy, color, layer); 
	}
	public function drawCircle(position:FlxPoint,layer:Int,color:FlxColor)
	{
		drawer.drawCircle(position,5, color, layer); 
	}
	
	private function drawDebugGraph():Void
	{
		var lines = getHexMap().getArrayOfPoints();
		getDrawer().drawListOfLines(lines, 0x66FF0000, 0);
	}

	override public function update(elapsed:Float):Void
	{
		if (instance == null)
			return;
			
		setTextToTextObj(fpsText, Math.floor(1 / elapsed) + ":time");
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
			var minMax = new MinMax(5,null);
			minMax.generateMove();
		}
	}
}
