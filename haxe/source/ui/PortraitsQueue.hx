package ui;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import game.Creature;
import gameLogic.GameContext;
import gameLogic.queue.CreatureQueue;
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
	private var logicData:CreatureQueue;
	
	private var currentPortrait:FlxSprite;
	private var positionOfPortrait:FlxPoint;
	
	public function new(logicData:CreatureQueue,frame:FlxUI9SliceSprite,portraitFrame:FlxUI9SliceSprite,posibbleSize:Float,sizeOfPortrait:Int) 
	{
		this.logicData = logicData;
		this.sizeOfPortrait = sizeOfPortrait;
		this.frame = frame;
		this.maxSize = Math.floor(posibbleSize / sizeOfPortrait) -2;
		this.frame.resize(sizeOfPortrait + 8, maxSize * sizeOfPortrait + 8);
		
		positionOfPortrait = portraitFrame.getPosition();
		currentPortrait = new FlxSprite(portraitFrame.getPosition().x + 4, portraitFrame.getPosition().y + 4);
		MainState.getInstance().add(currentPortrait);
		
		this.portraitGroup = new FlxTypedGroup<FlxSprite>(maxSize+2);
		attachListeners();
	}
	
	public function revalidate()
	{
		//return;
		setPortrait(GameContext.instance.currentCreature.name);
		onFill();
	}
	
	private function attachListeners()
	{
		//return;
		this.logicData.addFillListener(onFill);
		this.logicData.addPopListener(onPop);
	}
	
	private function onPop(creaturePoped:Creature)
	{
		//return;
		setPortrait(creaturePoped.name);
		killAll();
		createOrRevive();
	}
	
	private function setPortrait(creatureName:String)
	{
		//return;
		currentPortrait.loadGraphic(SpriteFactory.instance.getPortraitPath(creatureName), false, 64, 64);
		currentPortrait.scale.set(2, 2);
		currentPortrait.setPosition(positionOfPortrait.x+36, positionOfPortrait.y+36);
	}
	
	private function killAll()
	{
		//return;
		portraitGroup.forEach(function(sprite:FlxSprite)
		{
			sprite.kill();
		});
	}
	private function createOrRevive()
	{
		//return;
		
		var i = 0;
		while (i < maxSize)
		{
			var creature = logicData.getInOrder(i + 1);
			
			if (creature != null)
			{
				var portrait = portraitGroup.recycle();
				if (portrait == null)
				{
					portrait = SpriteFactory.instance.createNewPortrait(creature.name);
					MainState.getInstance().add(portrait);
					portraitGroup.add(portrait);
				}
				else
				{
					portrait.loadGraphic(SpriteFactory.instance.getPortraitPath(creature.name), false, 64, 64);
				}
				portrait.setPosition(frame.getPosition().x + 4, frame.getPosition().y + 4 + 64 * i);
			
				portrait.color = GameContext.instance.mapOfPlayers.get(creature.idPlayerId).color;
				if (i >= logicData.getSizeOfQueue() - logicData.getCurrentPosition() - 1)
				{
					portrait.color = 0xFF00FFCC;
				}
				
			}
			i++;
		}
	}
	
	private function onFill()
	{
		//return;
		
		killAll();
		createOrRevive();
	}
	
	
}