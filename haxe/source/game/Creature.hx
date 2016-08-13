package game;
import data.CreatureDefinition;
import data.SpriteDefinition;
import flixel.FlxState;
import flixel.math.FlxPoint;
import gameLogic.GameContext;
import hex.HexCoordinates;
import source.SpriteFactory;
import utilites.GameConfiguration;

/**
 * ...
 * @author ...
 */
class Creature
{
	public var sprite:CreatureSprite;
	public var x:Int;
	public var y:Int;
	
	public var currentCordinates:HexCoordinates;
	
	public var initiative(get, never):Int;
	public var range(get, never):Int;
	
	function get_initiative():Int
	{
		return definition.initiative;
	}
	
	function get_range():Int
	{
		return definition.actionPoints;
	}
	
	public var idPlayerId:Int;
	public var definitionId:Int;
	
	private var _definition:CreatureDefinition;
	public var definition(get, never):CreatureDefinition;
	public function get_definition():CreatureDefinition
	{
		if (_definition == null)
		{
			_definition = GameConfiguration.instance.creatures.get(definitionId);
		}
		return _definition;
	}
	
	public static function fromDefinition(definition:CreatureDefinition):Creature
	{
		var creature = new Creature(null);
		creature.definitionId = definition.id;
		trace(definition.spriteDef);
		var spriteDefinition = GameConfiguration.instance.spriteDefinitions.get(definition.spriteDef);
		
		creature.sprite =SpriteFactory.instance.createNewCreature(spriteDefinition);
		return creature;
	}
	
	public function new(sprite:CreatureSprite,x:Int = 0,y:Int = 0)
	{
		this.x = x;
		this.y = y;
		this.sprite = sprite;
	}
	
	public function getTileId():Int
	{
		return currentCordinates.toKey();
	}
	
	public function setCoodinates(coor:HexCoordinates)
	{
		if (currentCordinates != null)
			GameContext.instance.setHexPassable(currentCordinates);
		currentCordinates = coor;
		GameContext.instance.setHexImpassable(currentCordinates);
	}
	
	public function setPosition(position:FlxPoint)
	{
		sprite.setPosition(position.x - getWidth()*0.5, position.y - getHeight()*0.5);
	}
	
	public function getHeight():Float
	{
		return sprite.height;
	}
	
	public function getWidth():Float
	{
		return sprite.width;
	}
	
	public function addCreatureToState(stateToAdd:FlxState)
	{	
		stateToAdd.add(sprite);
		sprite.setPosition(x, y);
	}
	
}