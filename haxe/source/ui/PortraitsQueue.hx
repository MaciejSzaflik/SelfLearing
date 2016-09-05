package ui;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.group.FlxGroup;
import gameLogic.InitiativeQueue;
import source.SpriteFactory;

/**
 * ...
 * @author 
 */
class PortraitsQueue
{
	private var portraitGroup:FlxTypedGroup<FlxSprite>;
	private var frame:FlxUI9SliceSprite;
	private var maxSize:Int;
	
	private var sizeOfPortrait:Int;
	private var logicData:InitiativeQueue;
	
	public function new(logicData:InitiativeQueue,frame:FlxUI9SliceSprite,posibbleSize:Float,sizeOfPortrait:Int) 
	{
		this.logicData = logicData;
		this.sizeOfPortrait = sizeOfPortrait;
		this.frame = frame;
		this.maxSize = Math.floor(posibbleSize / sizeOfPortrait);
		this.frame.resize(sizeOfPortrait + 8, Math.floor(posibbleSize / sizeOfPortrait) * sizeOfPortrait + 8);
		
		this.portraitGroup = new FlxTypedGroup<FlxSprite>(maxSize+2);
		attachListeners();
	}
	
	private function attachListeners()
	{
		this.logicData.addFillListener(onFill);
	}
	
	private function onFill()
	{
		var i = 0;
		while (i < maxSize)
		{
			var creature = logicData.getInOrder(i);
			if (creature != null)
			{
				var portrait = SpriteFactory.instance.createNewPortrait(creature.name);
				portrait.setPosition(frame.getPosition().x + 4,frame.getPosition().y + 4 + 64*i);
				MainState.getInstance().add(portrait);
				portraitGroup.add(portrait);
			}
			i++;
		}
	}
	
	
}