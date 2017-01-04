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
	
}