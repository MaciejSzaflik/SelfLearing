package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxBasic;
import game.StageDescription;
import hex.HexagonalHexMap;
import hex.RectangleHexMap;
import source.Drawer;
import hex.HexMap;
import hex.HexTopping;

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
		
		stageDescription.AddCreaturesToScene(this);
			
		super.create();
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
		this.hexMap = new RectangleHexMap(
			new FlxPoint(FlxG.width * 0.1, FlxG.height * 0.7),
			stageDescription.mapHexSize,
			stageDescription.mapCols,
			stageDescription.mapRows);
			
		this.hexMap.InitPoints();
	}
	private function createDrawer():Void
	{
		this.drawer = new Drawer(2,this);
	}
	private function drawMap():Void
	{
		getDrawer().drawHexMap(getHexMap(),0xFFFFFFFF,0x00000000,0);
	}

	override public function update(elapsed:Float):Void
	{
		setTextToTextObj(fpsText, Math.floor(1 / elapsed) + ":time");
		onMouse();
		super.update(elapsed);
	}
	
	private function onMouse()
	{
		var mousePoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
		var coor = getHexMap().positionToHex(mousePoint);
		setTextToTextObj(debugText, coor.toString());

		var center = getHexMap().getHexCenterByAxialCor(coor);
		drawer.clear(1);
		drawer.drawHex(center, getHexMap().hexSize, HexTopping.Pointy, FlxColor.WHITE,1);
	}
}
