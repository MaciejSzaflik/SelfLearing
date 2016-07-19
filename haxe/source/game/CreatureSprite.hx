package game;
import data.FrameAnimationDef;
import data.SpriteDefinition;
import flixel.FlxSprite;

class CreatureSprite extends FlxSprite
{
	private var spriteDef:SpriteDefinition;
	public function new(spriteDef:SpriteDefinition) 
	{
		super();
		this.spriteDef = spriteDef;
	}
	public function InitGraphic()
	{
		if (spriteDef == null)
			return;
			
		this.loadGraphic(spriteDef.graphicName, spriteDef.animated, spriteDef.widght, spriteDef.height);
		if (spriteDef.animationList == null)
			return; 
			
		for (animation in spriteDef.animationList)
		{
			this.animation.add(animation.name, animation.frameOrder, animation.framesPerSecond, animation.looped);
		}
	}
	
}