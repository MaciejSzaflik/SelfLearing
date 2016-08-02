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
import game.StageDescription;
import gameLogic.GameContext;
import gameLogic.Player;
import graph.BreadthFirstSearch;
import graph.Vertex;
import hex.HexagonalHexMap;
import hex.RectangleHexMap;
import source.Drawer;
import hex.HexMap;
import hex.HexTopping;
import source.SpriteFactory;

using flixel.util.FlxSpriteUtil;

class MainState extends FlxState
{
	static private var _instance:MainState;
	static public function getInstance() : MainState
	{
		return _instance;
	}
	
	private var btnPlay:FlxButton;
	private var drawer:Drawer;
	private var hexMap:HexMap;
	private var stageDescription:StageDescription;
	
	private var fpsText:FlxText;
	private var debugText:FlxText;
	
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
		_instance = this;
		stageDescription = new StageDescription();
		stageDescription.InitTestStage();
		drawMap();
		addText();
		drawDebugGraph();
		
		//TestCreatureMovement();
		CreateGameContex();
		super.create();
	}
	
	private function CreateGameContex()
	{
		var player1 = new Player(0, CreateDubugCreatureList());
		var player2 = new Player(1, CreateDubugCreatureList());
		GameContext.instance.Init(getHexMap(), [player1, player2]);
	}
	
	private function CreateDubugCreatureList():Array<Creature>
	{
		var animationDef = new FrameAnimationDef("idle", 6, true, [0, 1, 2, 3, 4, 5]);
		var animationList = new List<FrameAnimationDef>();
		animationList.add(animationDef);
		var spriteDefinition = new SpriteDefinition("assets/images/blob.png", true, 36, 32, animationList);
		var creatureList = new Array<Creature>();
		
		var i = 0;
		while (i < 5)
		{
			var creature = new Creature(SpriteFactory.instance.createNewCreature(spriteDefinition),0,20);
			creatureList.push(creature);
			i++;
		}
		return creatureList;
	}
	
	
	private function TestCreatureMovement()
	{
		stageDescription.AddCreaturesToScene(this);
		var creatureIndex = 0;
		for (creature in stageDescription.listOfCreatures)
		{
			var hex = getHexMap().getRandomHex();
			addTestAnimation(creatureIndex, 0, hex.getIndex());
			creatureIndex++;
		}
	}
	private function addTestAnimation(creatureIndex:Int,from:Int, to:Int)
	{
		var checkpoints = getHexMap().getPathCenters(from, to);
		
		drawer.clear(creatureIndex + 1);
		for (hex in checkpoints)
			drawer.drawHex(hex, getHexMap().hexSize, HexTopping.Pointy, 0x7700ffff, creatureIndex + 1);
		
		var testMoveAnimation = new MoveBetweenPoints(
			stageDescription.listOfCreatures[creatureIndex],
			checkpoints
			,0.1,
			function() 
			{	
				var randomHex = 0;
				do
					randomHex = getHexMap().getRandomHex().getIndex()
				while (randomHex == to);
				
				addTestAnimation(creatureIndex,to,randomHex); 				
			});
		Tweener.instance.addAnimation(testMoveAnimation);
	}
	
	private function addText()
	{
		fpsText = new FlxText(0, 0, 500);
		debugText = new FlxText(0, 10, 500);
		add(fpsText);
		add(debugText);
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
	
	private function drawDebugGraph():Void
	{
		var lines = getHexMap().getArrayOfPoints();
		getDrawer().drawListOfLines(lines, 0x66FF0000, 0);
	}

	override public function update(elapsed:Float):Void
	{
		setTextToTextObj(fpsText, Math.floor(1 / elapsed) + ":time");
		Tweener.instance.update(elapsed);
		onMouse();
		super.update(elapsed);
	}
	
	private function onMouse()
	{
		var mousePoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
		var coor = getHexMap().positionToHex(mousePoint);
		setTextToTextObj(debugText, coor.toString() + " " + coor.toKey());

		var center = getHexMap().getHexCenterByAxialCor(coor);
	}
}
