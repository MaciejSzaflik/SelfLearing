package game;
import data.CreatureDefinition;
import data.SpriteDefinition;
import flixel.FlxState;
import flixel.math.FlxPoint;
import gameLogic.GameContext;
import gameLogic.PossibleAttacksInfo;
import gameLogic.abilites.Ability;
import gameLogic.abilites.AbilityFactory;
import hex.HexCoordinates;
import source.SpriteFactory;
import utilites.GameConfiguration;

/**
 * ...
 * @author ...
 */
class Creature
{
	public static var ignoreUpdate : Bool = false;
	
	public static var creatureCounter:Int = 0;
	
	public var id:Int;
	public var sprite:CreatureSprite;
	public var label:CreatureLabel;
	public var x:Int;
	public var y:Int;
	
	public var dynamicInfo : CreatureDynamicInfo;
	
	public var canContrattack(get, never):Bool;
	
	public var contrattackCounter(get, set):Int;
	public var currentActionPoints(get, set):Int;
	public var defending(get, set):Bool;
	public var waited(get, set):Bool;
	public var currentHealth(get, set):Int;
	
	public var moved(get, set):Bool;
	public var lostHitPoints(get, set):Int;
	public var definitionId(get, set):Int;
	
	public var currentCordinates(get, set):HexCoordinates;
	
	////////////////////////////////////////////////
	
	public function get_contrattackCounter():Int 
	{
		return dynamicInfo.contrattackCounter;
	}
	
	public function set_contrattackCounter(value:Int):Int 
	{
		return dynamicInfo.contrattackCounter = value;
	}
	
	public function get_currentActionPoints():Int 
	{
		return dynamicInfo.currentActionPoints;
	}
	
	public function set_currentActionPoints(value:Int):Int 
	{
		return dynamicInfo.currentActionPoints = value;
	}
	
	public function get_defending():Bool 
	{
		return dynamicInfo.defending;
	}
	
	public function set_defending(value:Bool):Bool 
	{
		return dynamicInfo.defending = value;
	}
	
	public function get_waited():Bool 
	{
		return dynamicInfo.waited;
	}
	
	public function set_waited(value:Bool):Bool 
	{
		return dynamicInfo.waited = value;
	}
	
	public function get_currentHealth():Int 
	{
		return dynamicInfo.currentHealth;
	}
	
	public function set_currentHealth(value:Int):Int 
	{
		return dynamicInfo.currentHealth = value;
	}
	
	public function get_moved():Bool 
	{
		return dynamicInfo.moved;
	}
	
	public function set_moved(value:Bool):Bool 
	{
		return dynamicInfo.moved = value;
	}
	
	public function get_lostHitPoints():Int 
	{
		return dynamicInfo.lostHitPoints;
	}
	
	public function set_lostHitPoints(value:Int):Int 
	{
		return dynamicInfo.lostHitPoints = value;
	}
	
	public function get_definitionId():Int 
	{
		return dynamicInfo.definitionId;
	}
	
	public function set_definitionId(value:Int):Int 
	{
		return dynamicInfo.definitionId = value;
	}

	public function get_currentCordinates():HexCoordinates 
	{
		return dynamicInfo.currentCordinates;
	}
	
	public function set_currentCordinates(value:HexCoordinates) 
	{
		return dynamicInfo.currentCordinates = value;
	}
	
	///////////////////////////////////////////////
	
	
	
	public var initiative(get, never):Int;
	public var range(get, never):Int;
	public var attackRange(get, never):Int;
	
	
	public var totalHealth(get, never):Int;
	public var unitHealth(get, never):Int;
	public var attack(get, never):Int;
	public var attackVariance(get, never):Int;
	public var isRanger(get, never):Bool;
	
	public var stackCounter(get, set):Int;
	
	private var _idPlayerId:Int;
	public var idPlayerId(get, set):Int;
	
	
	public var summoned:Bool;
	
	private var _definition:CreatureDefinition;
	public var definition(get, never):CreatureDefinition;
	
	public var position(get, never):FlxPoint;
	public var name(get, never):String;
	public var level(get, never):Int;
	
	function get_position():FlxPoint
	{
		return GameContext.instance.map.getHexCenter(currentCordinates.toKey());
	}	
	function get_stackCounter():Int
	{
		return dynamicInfo.stackSize;
	}
	function set_stackCounter(value:Int)
	{
		dynamicInfo.stackSize = value;
		
		if (!Creature.ignoreUpdate)
			label.setText(Std.string(value) + ":" + id);
			
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
	inline function get_totalHealth():Int
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
		return contrattackCounter < definition.contrattactsNumber;
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
		lostHitPoints += hitPower;
		if (newHealth <= 0)
		{
			currentHealth = 0;
			stackCounter = 0;
			return false;
		}
		
		recalculateStackSize(newHealth);
		return true;
	}
	
	public function recalculateStackSize(newHealth:Int)
	{
		stackCounter = Math.ceil(newHealth / unitHealth);
		currentHealth = newHealth - stackCounter * unitHealth;
	}
	
	public function startAnimation()
	{
		if(sprite.animation.getByName("idle") != null)
			sprite.animation.play("idle");
	}
	
	public function getActiviableAbility():Ability
	{
		if (definition.abilites != null && definition.abilites.length > 0)
			return  AbilityFactory.instance.getAbility(this,definition.abilites[0]);
		return null;
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
	
	public function getEmptyNeighbours():Array<Int>
	{
		return GameContext.instance.map.getNeighborsArray(getTileId());
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
		creature.recalculateStackSize(definition.health*stackCounter);
		return creature;
	}
	
	public function new(sprite:CreatureSprite,x:Int = 0,y:Int = 0)
	{
		this.id = creatureCounter++;
		this.x = x;
		this.y = y;
		this.sprite = sprite;
		this.label = SpriteFactory.instance.createNewLabel();
		this.dynamicInfo = new CreatureDynamicInfo();
	}
	
	public function isSpriteEnabled():Bool
	{
		return this.sprite.alive;
	}
	
	public function toString():String
	{
		return "a";
	}
	
	public function getTileId():Int
	{
		return currentCordinates.toKey();
	}
	
	public function setCoodinates(coor:HexCoordinates)
	{
		GameContext.instance.changeCreatureHex(currentCordinates, coor, this);
		currentCordinates = coor;
	}
	
	public function redrawPosition()
	{
		if (Creature.ignoreUpdate)
			return;
		
		setPosition(GameContext.instance.map.getHexCenter(getTileId()));
		label.setText(Std.string(stackCounter) + ":" + id);
		enable(stackCounter>0);
	}
	
	public function setPosition(position:FlxPoint)
	{
		if (Creature.ignoreUpdate)
			return;
		
		sprite.setPosition(position.x, position.y);
		label.setPosition(position.x, sprite.getPosition().y + getHeight());
	}
	
	public function flipSprite(flip)
	{
		#if neko
		sprite.flipX = !flip;
		#else
		sprite.flipX = flip;
		#end
	}
	
	public function getHeight():Float
	{
		return sprite.height;
	}
	
	public function getWidth():Float
	{
		return sprite.width;
	}
	
	public function get_level():Int
	{
		return definition.level;
	}
	
	public function addCreatureToState(stateToAdd:FlxState)
	{	
		MainState.getInstance().getDrawer().AddToCreatureGroup(this);
		GameContext.instance.creaturesMap.set(this.id, this);
		sprite.setPosition(x, y);
		label.setPosition(x, y);
	}
	
	public function enable(enable:Bool)
	{
		if (Creature.ignoreUpdate)
			return;
		
		label.enable(enable);
		if (enable)
			sprite.reset(this.position.x, this.position.y);
		else
			sprite.kill();
	}
	
	public function getDynamicInfoCopy() : CreatureDynamicInfo
	{
		return dynamicInfo.copy();
	}
	
	public function applyDynamicInfo(info : CreatureDynamicInfo)
	{
		dynamicInfo.applyInfo(info);
	}
	
}