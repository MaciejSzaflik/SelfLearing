package animation;

class Tweener
{
	private var animations:Map<Int,TweenAnimation>;
	private static var nextId:Int;
	
	public static var instance(get, null):Tweener;
	private static function get_instance():Tweener {
        if(instance == null) {
            instance = new Tweener();
        }
        return instance;
    }
	
	public function new() 
	{
		cancelAllAnimations();
	}
	
	public function update(elapsed:Float)
	{	
		var toRemove = new List<Int>();
		for (id in animations.keys()) {
			var finished = animations.get(id).Update(elapsed);
			if (finished)
				toRemove.add(id);
		}
		removeFromAnimations(toRemove);
	}
	
	public function cancelAnimation(id : Int)
	{
		if (animations.exists(id))
			animations.remove(id);
	}
	
	public function cancelAllAnimations()
	{
		this.animations = new Map<Int,TweenAnimation>();
		nextId = 0;
	}
	
	private function removeFromAnimations(idsToRemove:List<Int>)
	{
		for (id in idsToRemove)
			animations.remove(id);
	}
	
	public function addAnimation(animationToAdd:TweenAnimation):Int
	{
		animations.set(nextId, animationToAdd);
		nextId++;
		return nextId;
	}
	
}