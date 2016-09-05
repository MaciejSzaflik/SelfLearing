package game;
import data.CreatureDefinition;
import data.SpriteDefinition;
import flixel.FlxState;
import flixel.math.FlxPoint;
import gameLogic.GameContext;
import gameLogic.PossibleAttacksInfo;
import hex.HexCoordinates;
import source.SpriteFactory;
import utilites.GameConfiguration;

/**
 * ...
 * @author ...
 */
class Creature
{
	public static var creatureCounter:Int = 0;
	
	public var id:Int;
	public var sprite:CreatureSprite;
	public var label:CreatureLabel;
	public var x:Int;
	public var y:Int;
	
	public var canContrattack(get, never):Bool;
	public var contrattackCountter:Int;
	public var currentActionPoints:Int;
	
	public var currentCordinates:HexCoordinates;
	
	public var initiative(get, never):Int;
	public var range(get, never):Int;
	public var attackRange(get, never):Int;
	
	public var currentHealth:Int;
	public var totalHealth(get, never):Int;
	public var unitHealth(get, never):Int;
	public var attack(get, never):Int;
	public var attackVariance(get, never):Int;
	public var isRanger(get, never):Bool;
	
	private var _stackCounter:Int;
	public var stackCounter(get, set):Int;
	
	public var _idPlayerId:Int;
	public var idPlayerId(get, set):Int;
	public var definitionId:Int;
	
	private var _definition:CreatureDefinition;
	public var definition(get, never):CreatureDefinition;
	
	public var moved:Bool = false;
	
	public var position(get, never):FlxPoint;
	public var name(get, never):String;
	
	function get_position():FlxPoint
	{
		return GameContext.instance.map.getHexCenter(currentCordinates.toKey());
	}	
	function get_stackCounter():Int
	{
		return _stackCounter;
	}
	function set_stackCounter(value:Int):Int
	{
		_stackCounter = value;
		label.setText(Std.string(value));
		return value;
	}
	
	function get_idPlayerId():Int
	{
		return _idPlayerId;
	}
	function set_idPlayerId(value:Int):Int
	{
		_idPlayerId = value;
		return value;
	}
	function get_attack():Int
	{
		return definition.attackPower;
	}
	function get_attackVariance():Int
	{
		return definition.attackRandom;
	}
	function get_unitHealth():Int
	{
		return definition.health;
	}
	function get_totalHealth():Int
	{
		return unitHealth*stackCounter + currentHealth;
	}
	function get_initiative():Int
	{
		return definition.initiative;
	}
	function get_range():Int
	{
		return definition.actionPoints;
	}
	function get_attackRange():Int
	{
		if ((definition.isRanger && getEnemyNeighbours().lenght>0) || (definition.isRanger && moved))
			return 1;
		return  definition.attackRange;
	}
	function get_canContrattack():Bool
	{
		trace(contrattackCountter + " " + definition.contrattactsNumber);
		return contrattackCountter < definition.contrattactsNumber;
	}
	function get_isRanger():Bool
	{
		return definition.isRanger;
	}
	function get_name():String
	{
		return definition.name;
	}
	
	public function getHit(hitPower:Int):Bool
	{
		var newHealth = totalHealth - hitPower;
		if (newHealth <= 0)
			return false;
		
		stackCounter = Math.ceil(newHealth / unitHealth);
		currentHealth = newHealth - stackCounter * unitHealth;
		return true;
	}
	
	public function startAnimation()
	{
		sprite.animation.play("idle");
	}
	
	public function calculateAttack():Int
	{
		var basicValue = (attack * stackCounter) + Random.int(-attackVariance*stackCounter, attackVariance*stackCounter);
		if (definition.isRanger)
		{
			if(getEnemyNeighbours().lenght > 0)
				basicValue = Math.ceil(basicValue*0.5);
		}
		return basicValue;
	}
	
	public function getEnemyNeighbours():PossibleAttacksInfo
	{
		return GameContext.instance.getEnemiesInRange(getTileId(), 1, idPlayerId);
	}
	
	public function get_definition():CreatureDefinition
	{
		if (_definition == null)
		{
			_definition = GameConfiguration.instance.creatures.get(definitionId);
		}
		return _definition;
	}
	
	
	public static function fromDefinition(definition:CreatureDefinition,stackCounter:Int):Creature
	{
		var creature = new Creature(null);
		creature.stackCounter = stackCounter;
		creature.definitionId = definition.id;
		var spriteDefinition = GameConfiguration.instance.spriteDefinitions.get(definition.spriteDef);
		
		creature.sprite = SpriteFactory.instance.createNewCreature(spriteDefinition);
		return creature;
	}
	
	public function new(sprite:CreatureSprite,x:Int = 0,y:Int = 0)
	{
		this.id = creatureCounter++;
		this.x = x;
		this.y = y;
		this.sprite = sprite;
		this.label = SpriteFactory.instance.createNewLabel();
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
		sprite.setPosition(position.x, position.y);
		label.setPosition(position.x, sprite.getPosition().y + getHeight());
	}
	
	public function flipSprite(flip)
	{
		sprite.flipX = flip;
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
		
		label.addToState(stateToAdd);
		label.setPosition(x, y);
	}
	
	public function disable()
	{
		sprite.kill();
		label.disable();
	}
	
}