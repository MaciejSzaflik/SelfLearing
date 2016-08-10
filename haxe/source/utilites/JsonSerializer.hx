package utilites;
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
	
	@:generic
	public static function fillObjectWithDynamic<T>(object:T, objectDynamic:Dynamic):T
	{
		for (field in Type.getInstanceFields(Type.getClass(object)))
		{
			if (Reflect.hasField(objectDynamic, field))
			{
				Reflect.setProperty(object, field, Reflect.getProperty(objectDynamic, field));
			}
		}
		return object;
	}
	
}