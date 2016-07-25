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
		var creature = new Creature(SpriteFactory.instance.createNewCreature(spriteDefinition),30,30);
		listOfCreatures.push(creature);
		/*var i = 0;
		while (i < 4)
		{
			var creature = new Creature(SpriteFactory.instance.createNewCreature(spriteDefinition),i*100,20);
			listOfCreatures.add(creature);
			i++;
		}*/
		
		mapRows = 18;
		mapCols = 30;
		mapHexSize = 35;
	}
	
	public function AddCreaturesToScene(scene:FlxState)
	{
		for (creature in listOfCreatures)
		{
			creature.addCreatureToState(scene);
		}
	}
	
}