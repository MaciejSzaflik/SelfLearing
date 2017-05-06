package;

import flixel.FlxGame;
import gameLogic.ai.genetic.RewardGenetic;
import haxe.unit.TestRunner;
import openfl.Lib;
import openfl.display.Sprite;
import test.AlphaBetaTest;
import utilites.RandomUtil;
import utilites.StorageHelper;

class Main extends Sprite
{
	public function new()
	{
		super();
		
		StorageHelper.instance.saveItem("Hello", "Hello");
		
		addChild(new FlxGame(0, 0, MainState,1,60,60,true));
		runTest();
		checkBlend();
	}
	
	public function checkBlend()
	{
		var tuple = RewardGenetic.instance.blxCrossover([1, 2, 3], [2, 3, 4], 0.5);
		trace(tuple._0);
		trace(tuple._1);
		RewardGenetic.instance.mutateChildren([1, 2, 3],  [2, 3, 4],tuple);
		trace(tuple._0);
		trace(tuple._1);
	}
	
	public function runTest()
	{
		var r = new haxe.unit.TestRunner();
		r.add(new AlphaBetaTest());

		r.run();
	}
}
