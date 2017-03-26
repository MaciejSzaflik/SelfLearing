package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import test.AlphaBetaTest;

class MainTest extends Sprite
{
	public function new()
	{
		super();
		runTest();
	}
	
	public function runTest()
	{
		var r = new haxe.unit.TestRunner();
		r.add(new AlphaBetaTest());

		r.run();
	}
}
