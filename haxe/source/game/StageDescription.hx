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
	public var waterLevel:Float;
	
	public function new() 
	{
		
	}
	
	public function InitTestStage()
	{
		mapRows = 11;
		mapCols = 11;
		mapHexSize = 52;
		waterLevel = 1;
	}
	
}