package gameLogic.ai.genetic;
import flixel.math.FlxRandom;
import thx.Floats;
import thx.Tuple.Tuple2;
import utilites.MathUtil;
import utilites.RandomUtil;
import utilites.StorageHelper;
import thx.Ints;
/**
 * ...
 * @author ...
 */
class RewardGenetic
{
	public var sizeOfPopulation = 5;
	public var generationNumber = 5;
	public static var instance(get, null):RewardGenetic;
	private static function get_instance():RewardGenetic {
        if(instance == null) {
            instance = new RewardGenetic(30,30);
        }
        return instance;
    }
	
	public var currentPopulationNumber : Int;
	public var currentItemEvaluated : Int;
	
	public var evaluations : Array<Float>;
	public var currentPopulation : Array<Array<Float>>;
	
	public var best : Array<Tuple2<Float,Array<Float>>>;
	public var bestEver : Tuple2<Float,Array<Float>>;
	
	public var generationMean : Array<Float>;	
	
	public var elitism : Int = 1;
	public var mutationPosibility : Float = 0.01;
	
	public function new(populationSize : Int, generationNumber : Int) 
	{
		this.sizeOfPopulation = populationSize;
		this.generationNumber = generationNumber;
		this.generationMean = new Array<Float>();
		generateInitialPopulation();
	}
	
	public function getCurrentConfiguration() : Array<Float>
	{
		return currentPopulation[currentItemEvaluated];
	}
	
	public function reportEvaluation(value : Float)
	{
		evaluations[currentItemEvaluated] = value;
		currentItemEvaluated++;
		
		
		if (currentItemEvaluated == sizeOfPopulation && currentPopulationNumber < generationNumber)
		{
			currentItemEvaluated = 0;
			currentPopulationNumber++;
			
			var sum = 0.0;
			for (value in evaluations)
			{
				sum += value;
			}
			sum /= evaluations.length;
			generationMean.push(sum);
			
			currentPopulation = generateNewPopulation();
		}
		
		if (currentPopulationNumber == generationNumber)
			trace(best);
		
		saveCurrent();
	}
	
	private function generateNewPopulation() : Array<Array<Float>>
	{
		trace("generateNewPopulation");
		var newPopulation = new Array<Array<Float>>();
		
		var currentRank = new Array<Tuple2<Int,Float>>();
		for (i in 0...sizeOfPopulation)
		{
			currentRank.push(new Tuple2(i, evaluations[i]));
		}
		currentRank.sort(function(x:Tuple2<Int,Float>, y:Tuple2<Int,Float>):Int {return -Floats.compare(x._1, y._1); });
		
		best.push(new Tuple2(currentRank[0]._1, currentPopulation[currentRank[0]._0]));
		if (currentRank[0]._1 > bestEver._0)
		{
			bestEver = new Tuple2(currentRank[0]._1, currentPopulation[currentRank[0]._0]);
		}
		
		var maximumRankValue = MathUtil.artmeticProgressionSum(0, sizeOfPopulation + 2, 1);
		for (i in 0...sizeOfPopulation)
		{
			var last = 0.0;
			if (i == 0)
				last = maximumRankValue;
			else
				last = currentRank[i - 1]._1;
			
			currentRank[i]._1 = last - MathUtil.artmeticProgressionElement(0, sizeOfPopulation - i + 2, 1);
		}
		
		var childrenGenerated = 0;
		
		for (i in 0...elitism)
		{
			newPopulation.push(currentPopulation[currentRank[i]._0]);
			childrenGenerated++;
		}
		trace(elitism + "  " + sizeOfPopulation);
		for (i in elitism...sizeOfPopulation)
		{
			trace("generateParents");
			var parentA = selectParentBasedOnRank(currentRank, maximumRankValue);
			var parentB = selectParentBasedOnRank(currentRank, maximumRankValue);
			
			var children = blxCrossover(parentA, parentB, 0.5);
			mutateChildren(parentA,parentB,children);
			
			if (newPopulation.length < sizeOfPopulation)
			{
				newPopulation.push(children._0);
			}
			if (newPopulation.length < sizeOfPopulation)
			{
				newPopulation.push(children._1);
			}
		}
		
		return newPopulation;
	}
	
	private function selectParentBasedOnRank(ranks : Array<Tuple2<Int,Float>>, maxiumum : Float) : Array<Float>
	{
		var parentSelection = Random.float(0, maxiumum);
		var iterator = new RangeIterator(ranks.length - 1, 0, -1);
		for (i in iterator)
		{
			if (parentSelection < ranks[i]._1)
			{
				return currentPopulation[ranks[i]._0];
			}
		}
		return currentPopulation[0];
	}
	
	
	public function generateInitialPopulation()
	{
		currentPopulationNumber = 0;
		currentItemEvaluated = 0;
		bestEver = new Tuple2(0.0, new Array<Float>());
		evaluations = new Array<Float>();
		currentPopulation = new Array<Array<Float>>();
		best = new Array<Tuple2<Float,Array<Float>>>();
		for (i in 0...sizeOfPopulation)
		{
			currentPopulation.push(generateArray(100, 12));
		}
	}
	
	public function blxCrossover(x : Array<Float>, y : Array<Float>, a : Float) : Tuple2<Array<Float>,Array<Float>>
	{
		var children = new Tuple2(new Array<Float>(),new Array<Float>());

		for (i in 0...x.length)
		{
			var d = Math.abs(x[i] - y[i]);
			var u1 = Random.float(Math.min(x[i], y[i]) - a * d, Math.max(x[i], y[i]) + a * d);
			var u2 = Random.float(Math.min(x[i], y[i]) - a * d, Math.max(x[i], y[i]) + a * d);
			
			children._0.push(u1);
			children._1.push(u2);
		}
		return children;
	}
	
	public function mutateChildren(x : Array<Float>,y : Array<Float>,children : Tuple2<Array<Float>,Array<Float>>)
	{
		fineMutation(x, y, children._0, mutationPosibility);
		fineMutation(x, y, children._1, mutationPosibility);
	}
	
	public function fineMutation(x : Array<Float>, y : Array<Float>, z : Array<Float>, p : Float)
	{
		for (i in 0...z.length)
		{
			if (Math.random() < p)
			{
				z[i] = z[i] + RandomUtil.boxMullerGaussian(0, Math.abs(x[i] - y[i]));
			}
		}
	}
	
	public function saveCurrent()
	{
		StorageHelper.instance.saveItem("currentPopulationNumber", Std.string(currentPopulationNumber));
		StorageHelper.instance.saveItem("currentEval", valuesToString(evaluations));
		for (i in 0...sizeOfPopulation)
		{
			StorageHelper.instance.saveItem("p."+i,valuesToString(currentPopulation[i]));
		}
	}
	
	public function valuesToString(values : Array<Float>) : String
	{
		var sb : StringBuf = new StringBuf();
		for ( value in values)
		{
			sb.add(value);
			sb.addChar(59);
		}
		return sb.toString();
	}
	
	public function stringToValues(value : String) : Array<Float>
	{
		var toReturn : Array<Float> = new Array<Float>();
		for (number in value.split(";"))
		{
			if (number != "")
			{
				toReturn.push(Std.parseFloat(number));
			}
		}
		return toReturn;
	}
	
	
	public function generateArray(range:Int, size : Int = 12) : Array<Float>
	{
		var toReturn : Array<Float> = new Array<Float>();
		
		for (i in 0...size)
		{
			toReturn.push(Random.float( -range, range));
		}
		
		
		return toReturn;
	}
	
}