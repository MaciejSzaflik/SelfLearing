package;

import animation.MoveBetweenPoints;
import animation.Tweener;
import data.FrameAnimationDef;
import data.SpriteDefinition;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxBasic;
import game.Creature;
import data.CreatureDefinition;
import game.StageDescription;
import gameLogic.GameContext;
import gameLogic.Input;
import gameLogic.Player;
import gameLogic.PlayerType;
import gameLogic.ai.BestMove;
import gameLogic.ai.RandomAI;
import gameLogic.ai.evaluation.KillTheWeakest;
import graph.BreadthFirstSearch;
import graph.Vertex;
import hex.HexagonalHexMap;
import hex.RectangleHexMap;
import source.Drawer;
import hex.HexMap;
import hex.HexTopping;
import source.SpriteFactory;
import utilites.GameConfiguration;
import utilites.InputType;
import utilites.JsonSerializer;

using flixel.util.FlxSpriteUtil;

class MainState extends FlxState
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
		super.create();
		
		GameConfiguration.init(function(){
			instance = this;
			stageDescription = new StageDescription();
			stageDescription.InitTestStage();
			drawMap();
			addText();
			drawDebugGraph();
			CreateGameContex();
		});
		
	}

	private function CreateGameContex()
	{
		var player1 = new Player(0, CreateDubugCreatureList(), 0xffcc1111, PlayerType.Human,true);
		//player1.setAI(new RandomAI());
		var player2 = new Player(1, CreateDubugCreatureList(), 0xff1111ff, PlayerType.Human,false);
		player2.setAI(new BestMove(new KillTheWeakest(false)));
		
		GameContext.instance.Init(getHexMap(), [player1, player2]);
		
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
			var creatureDefinition = GameConfiguration.instance.creatures.get(Random.int(0,0));
			var creature = Creature.fromDefinition(creatureDefinition,10);
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
		
		var startPoisitionX = (1 - (mapWidth / FlxG.width))/2;
		var startPoisitionY = 1 - ((1- (mapHeight / FlxG.height))/2);
		
		this.hexMap = new RectangleHexMap(
			new FlxPoint(FlxG.width * startPoisitionX, FlxG.height * startPoisitionY),
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
		getDrawer().drawHexMap(getHexMap(),0xFFFFFFFF,0x00000000,0);
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
}
