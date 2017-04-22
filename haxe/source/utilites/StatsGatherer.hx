package utilites;
#if neko
import sys.io.File;
import sys.io.FileOutput;
#end

/**
 * ...
 * @author ...
 */
class StatsGatherer 
{
	#if neko
	private var output : FileOutput;
	#end
	private var outputString : String;
	
	static public var instance(get, never) : StatsGatherer;
	static private var _instance : StatsGatherer;
	static function get_instance() : StatsGatherer
	{
		if (_instance == null)
		{
			_instance = new StatsGatherer();
		}
		return _instance;
	}
	
	private function new() 
	{
		openOutput();
	}
	
	private function openOutput()
	{
		#if neko
		output = File.write("test.csv", false);
		#end
		outputString = "";
	}
	
	public function finish()
	{
		#if neko
		output.close();
		output = null;
		#end
		trace(outputString);
		outputString = "";
	}
	
	public function write(moveCounter : Int, totalTime: Float, moveTime : Float, evaluationTime : Float, nodes : Int, childeren : Int)
	{
		#if neko
		if (output == null)
			openOutput();
		output.writeString(moveCounter + "," + totalTime+"," + moveTime+"," + evaluationTime+"," + nodes + "," + childeren);
		#end
		outputString += moveCounter + "," + totalTime+"," + moveTime+"," + evaluationTime+"," + nodes + "," + childeren + "\n";
	}
}