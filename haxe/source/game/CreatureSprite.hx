package game;
import data.FrameAnimationDef;
import data.SpriteDefinition;
import flixel.FlxSprite;
import utilites.GameConfiguration;

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
			var animationDef = GameConfiguration.instance.frameAnimations.get(animation);
			this.animation.add(animationDef.name, animationDef.frameOrder, animationDef.framesPerSecond, animationDef.looped);
		}
	}
	
}