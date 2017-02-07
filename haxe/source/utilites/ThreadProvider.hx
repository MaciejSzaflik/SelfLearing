package utilites;
import haxe.Constraints.Function;
import lime.system.BackgroundWorker;
import neko.vm.Thread;

/**
 * ...
 * @author 
 */
class ThreadProvider
{
	private static var _instance:ThreadProvider;
	public static var instance(get, null):ThreadProvider;
	private static function get_instance():ThreadProvider {
        if(_instance == null) {
            _instance = new ThreadProvider(8);
        }
        return _instance;
    }
	
	private function new(threadCount:Int) 
	{
	}
	
	public function AddTask(work:Function)
	{
		var worker = new BackgroundWorker();
		
		worker.doWork.add(function(_){
			work();
		});
		worker.run();
	}
}