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
	public var listOfSpriteDefinition:List<SpriteDefinition>;
	public var listOfCreatures:Array<Creature>;
	public var mapRows:Int;
	public var mapCols:Int;
	public var mapHexSize:Float;
	
	public function new() 
	{
		
	}
	
	public function InitTestStage()
	{
		this.listOfSpriteDefinition = new List<SpriteDefinition>();
		this.listOfCreatures = new Array<Creature>();
		
		var animationDef = new FrameAnimationDef("idle", 6, true, [0, 1, 2, 3, 4, 5]);
		var animationList = new List<FrameAnimationDef>();
		animationList.add(animationDef);
		var spriteDefinition = new SpriteDefinition("assets/images/blob.png", true, 36, 32, animationList);
		listOfSpriteDefinition.add(spriteDefinition);
		var i = 0;
		while (i < 5)
		{
			var creature = new Creature(SpriteFactory.instance.createNewCreature(spriteDefinition),0,20);
			listOfCreatures.push(creature);
			i++;
		}
		
		mapRows = 15;
		mapCols = 10;
		mapHexSize = 40;
	}
	
	public function AddCreaturesToScene(scene:FlxState)
	{
		for (creature in listOfCreatures)
		{
			creature.addCreatureToState(scene);
		}
	}
	
}