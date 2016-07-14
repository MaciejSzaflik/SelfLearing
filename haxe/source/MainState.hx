package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import source.Drawer;
import source.HexMap;

using flixel.util.FlxSpriteUtil;

class MainState extends FlxState
{
	static private var _instance:MainState;
	static public function getInstance() : MainState
	{
		return _instance;
	}
	
	private var btnPlay:FlxButton;
	private var canvas:FlxSprite;
	private var drawer:Drawer;
	private var hexMap:HexMap;
	
	public function getCanvas() : FlxSprite
	{
		if (canvas == null)
			createCanvas();
		return canvas;
	}
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
		drawMap();
		super.create();
	}
	
	private function createCanvas():Void
	{
		canvas = new FlxSprite();
		canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(canvas);
	}
	private function createMap():Void
	{
		this.hexMap = new HexMap(new FlxPoint(FlxG.width*0.5, FlxG.height*0.5),30, 6);
	}
	private function createDrawer():Void
	{
		this.drawer = new Drawer(getCanvas());
	}
	private function drawMap():Void
	{
		getDrawer().drawHexMap(getHexMap(),0xFFFFFFFF,0x00000000);
	}


	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
