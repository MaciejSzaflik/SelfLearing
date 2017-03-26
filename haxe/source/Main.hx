package;

import flixel.FlxGame;
import haxe.unit.TestRunner;
import openfl.Lib;
import openfl.display.Sprite;
import test.AlphaBetaTest;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, MainState));
		runTest();
	}
	
	public function runTest()
	{
		var r = new haxe.unit.TestRunner();
		r.add(new AlphaBetaTest());

		r.run();
	}
}
