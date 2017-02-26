package graph;

/**
 * @author ...
 */
interface Pathfinder 
{
	public function findPath(start:Int, end:Int):Array<Int>;
	public function findPathMultipleEnds(start:Int, ends:Array<Int>):Array<Int>;
}