package utilites;
import game.CreatureDefinition;
import tjson.TJSON;
class JsonSerializer
{
	
	public function new() 
	{
		
	}
	
	@:generic
	public static function serialize<T>(object:T):String
	{
		return TJSON.encode(object,'fancy');
	}
	
	public static function deserialize(json:String):Dynamic
	{
		return TJSON.parse(json);
	}
	
	public static function deserializeCreature(encoded:String):CreatureDefinition
	{
		var parsed:Dynamic = TJSON.parse(encoded);
		var result:CreatureDefinition = Type.createEmptyInstance(CreatureDefinition);
		for (field in Type.getInstanceFields(CreatureDefinition))
		{
			if (Reflect.hasField(parsed, field))
			{
				Reflect.setProperty(result, field, Reflect.getProperty(parsed, field));
			}
		}
		return result;
	}
	
}