package game;
import data.FrameAnimationDef;
import data.SpriteDefinition;
import flixel.FlxState;
import source.SpriteFactory;

/**
 * ...
 * @author ...
 */
class StageDescription
{
	public var mapRows:Int;
	public var mapCols:Int;
	public var mapHexSize:Float;
	
	public function new() 
	{
		
	}
	
	public function InitTestStage()
	{
		mapRows = 15;
		mapCols = 14;
		mapHexSize = 40;
	}
	
}