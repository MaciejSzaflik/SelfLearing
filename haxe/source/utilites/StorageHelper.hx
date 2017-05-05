package utilites;

#if js
import js.Browser;
import js.html.Storage;
#end

/**
 * ...
 * @author 
 */
class StorageHelper
{

	public static var instance(get, null):StorageHelper;
	private static function get_instance():StorageHelper {
        if(instance == null) {
            instance = new StorageHelper();
        }
        return instance;
    }
	
	private function new() 
	{
		#if js
		var storage : Storage = Browser.getLocalStorage();
		if (storage != null)
			trace("Storage enabled");
		#end
	}
	
	public function saveItem(key : String, value : String)
	{
		#if js
		var storage : Storage = Browser.getLocalStorage();
		if (storage == null)
			return;
			
		storage.setItem(key, value);
		#end
	}
	
	public function getItem(key : String) : String
	{
		#if js
		var storage : Storage = Browser.getLocalStorage();
		if (storage == null)
			return "";
			
		return storage.getItem(key);
		#end
		return "";
	}
	
}