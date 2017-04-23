package utilites;

/**
 * ...
 * @author 
 */
class UtilUtil
{

	@:generic public static function CountMap<T,G>(map: Map<T,G>) 
	{
	   var ret = 0; 
	   for (_ in map.keys()) ret++; 
	   return ret; 
	}
	
	@:generic public static function CountIterable<T>(iterable: Iterable<T>) 
	{
	   var ret = 0; 
	   for (_ in iterable) ret++; 
	   return ret; 
	}
	
	@:generic public static inline function IncremanteIfPossible<T>(map : Map<T,Int>, key : T) 
	{
		var value = map.get(key);
		if (value != null)
			map.set(key,value + 1);
		else
			map.set(key, 1);

			
	}
	
	public static function getIndexOf<T> (array:Array < T > , value:T):Int {
		
		for (i in 0...array.length)
		{
			if (array[i] == value) 
				return i;
		}
		return -1;
	}
	
}