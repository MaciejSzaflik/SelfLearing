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
	
	public static function getIndexOf<T> (array:Array < T > , value:T):Int {
		
		for (i in 0...array.length)
		{
			if (array[i] == value) 
				return i;
		}
		return -1;
	}
	
}