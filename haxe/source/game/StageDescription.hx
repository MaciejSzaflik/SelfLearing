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
	public static var scaleFactor:Float;
	
	public function new() 
	{
		
	}
	
	public function InitTestStage()
	{
		mapRows = 5;
		mapCols = 5;
		mapHexSize = 60;
		waterLevel = 1;
		scaleFactor = (mapHexSize-1) / 51.0;
	}
	
}