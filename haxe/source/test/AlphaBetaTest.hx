package test;

import gameLogic.ai.AlphaBeta;
import gameLogic.ai.AlphaBeta.SimpleNode;
import gameLogic.ai.MinMax.MinMaxNode;
import gameLogic.ai.NegaMax;
import gameLogic.ai.NegaScout;
import gameLogic.ai.tree.TreeVertex;
import haxe.unit.TestCase;
import thx.Tuple.Tuple2;
/**
 * ...
 * @author 
 */
class AlphaBetaTest extends TestCase
{

	public function new() 
	{
		super();
		
	}
	
	
	public function testGenericTreeAlfaBeta()
	{
		TreeVertex.idGenerator = 0;
		var firstTree = generateTree1();
		var value = AlphaBeta.genericAlfaBeta(2, 0, firstTree,
			function(node : TreeVertex<SimpleNode>) { return new Tuple2<TreeVertex<SimpleNode>,Float>(node,node.value.getValue()); },
			function(node : SimpleNode) { return node.getPlayerType(); },
			function(node : TreeVertex<SimpleNode>, currentDepth : Int) { return node.children; },
			-1000, 1000);
		assertEquals(3.0, value._1);
		assertEquals(4, value._0.id);
			
		var secondTree = generateTree2();
		value = AlphaBeta.genericAlfaBeta(5, 0, secondTree,
			function(node : TreeVertex<SimpleNode>) { return new Tuple2<TreeVertex<SimpleNode>,Float>(node,node.value.getValue()); },
			function(node : SimpleNode) { return node.getPlayerType(); },
			function(node : TreeVertex<SimpleNode>, currentDepth : Int) { return node.children; },
			-1000, 1000);
		assertEquals(7.0, value._1);
		assertEquals(17, value._0.id);
		
		trace(TreeVertex.getOneBeforeRoot(value._0).id);
		
	}
	
	public function testTestSimpleTreeAlfaBeta()
	{
		assertEquals(3, AlphaBeta.valueAlfaBeta(generateTree1(), -1000, 1000));
		assertEquals(7, AlphaBeta.valueAlfaBeta(generateTree2(), -1000, 1000));
	}
	
	
	public function testTestSimpleTreeNegaScout()
	{
		assertEquals(3.0, NegaScout.valueNegaScout(generateTree1(), 2, 0, -1000, 1000));
		assertEquals(7.0, NegaScout.valueNegaScout(generateTree2(), 2, 0, -1000, 1000));
	}
	
	
	public function testTestGenericTreeNegaScout()
	{
		assertEquals(3.0, NegaScout.genericNegaScout(generateTree1(), 2, 0, -1000, 1000,
			function(node : SimpleNode) { return node.getColor();},
			function(node : SimpleNode) { return node.getValue(); },
			function(node : TreeVertex<SimpleNode>) { return node.children; }));
		assertEquals(7.0, NegaScout.genericNegaScout(generateTree2(), 2, 0, -1000, 1000,
			function(node : SimpleNode) { return node.getColor(); },
			function(node : SimpleNode) { return node.getValue(); },
			function(node : TreeVertex<SimpleNode>) { return node.children; }));
	}
	
	public function testTestGenericTreeNegaMax()
	{
		assertEquals(3.0, NegaMax.genericNegaMax(generateTree1(), 2, 0, -1000, 1000,
		function(node : SimpleNode) { return node.getColor(); },
		function(node : SimpleNode) { return node.getValue(); },
		function(node : TreeVertex<SimpleNode>) { return node.children; }));
		assertEquals(7.0, NegaMax.genericNegaMax(generateTree2(), 2, 0, -1000, 1000,
		function(node : SimpleNode) { return node.getColor(); },
		function(node : SimpleNode) { return node.getValue(); },
		function(node : TreeVertex<SimpleNode>) { return node.children; }));
	}
	
	public function testTestSimpleTreeNegaMax()
	{
		assertEquals(3.0, NegaMax.valueNegaMax(generateTree1(), 2, 0, -1000, 1000));
		assertEquals(7.0, NegaMax.valueNegaMax(generateTree2(), 2, 0, -1000, 1000));
	}
	
	public function generateTree1() : TreeVertex<SimpleNode>
	{
		var treeRoot = new TreeVertex<SimpleNode>(null, new SimpleNode(null,true));
		var firstLayer1 = new TreeVertex<SimpleNode>(treeRoot, new SimpleNode(null,false));
		var firstLayer2 = new TreeVertex<SimpleNode>(treeRoot, new SimpleNode(null,false));
		var firstLayer3 = new TreeVertex<SimpleNode>(treeRoot, new SimpleNode(null,false));
		
		var secLayer1_1 = new TreeVertex<SimpleNode>(firstLayer1, new SimpleNode(3,true));
		var secLayer1_2 = new TreeVertex<SimpleNode>(firstLayer1, new SimpleNode(12,true));
		var secLayer1_3 = new TreeVertex<SimpleNode>(firstLayer1, new SimpleNode(8,true));
		
		var secLayer2_1 = new TreeVertex<SimpleNode>(firstLayer2, new SimpleNode(2,true));
		var secLayer2_2 = new TreeVertex<SimpleNode>(firstLayer2, new SimpleNode(4,true));
		var secLayer2_3 = new TreeVertex<SimpleNode>(firstLayer2, new SimpleNode(8,true));
		
		var secLayer3_1 = new TreeVertex<SimpleNode>(firstLayer3, new SimpleNode(14,true));
		var secLayer3_2 = new TreeVertex<SimpleNode>(firstLayer3, new SimpleNode(5,true));
		var secLayer3_3 = new TreeVertex<SimpleNode>(firstLayer3, new SimpleNode(2, true));
		
		return treeRoot;
	}
	
	public function generateTree2() : TreeVertex<SimpleNode>
	{
		var treeRoot = new TreeVertex<SimpleNode>(null, new SimpleNode(null,true));
		var firstLayer1 = new TreeVertex<SimpleNode>(treeRoot, new SimpleNode(null,false));
		var firstLayer2 = new TreeVertex<SimpleNode>(treeRoot, new SimpleNode(null,false));
		var firstLayer3 = new TreeVertex<SimpleNode>(treeRoot, new SimpleNode(null,false));
		
		var secLayer1_1 = new TreeVertex<SimpleNode>(firstLayer1, new SimpleNode(7,true));
		var secLayer1_2 = new TreeVertex<SimpleNode>(firstLayer1, new SimpleNode(12,true));
		var secLayer1_3 = new TreeVertex<SimpleNode>(firstLayer1, new SimpleNode(8,true));
		
		var secLayer2_1 = new TreeVertex<SimpleNode>(firstLayer2, new SimpleNode(10,true));
		var secLayer2_2 = new TreeVertex<SimpleNode>(firstLayer2, new SimpleNode(4,true));
		var secLayer2_3 = new TreeVertex<SimpleNode>(firstLayer2, new SimpleNode(6,true));
		
		var secLayer3_1 = new TreeVertex<SimpleNode>(firstLayer3, new SimpleNode(1,true));
		var secLayer3_2 = new TreeVertex<SimpleNode>(firstLayer3, new SimpleNode(5,true));
		var secLayer3_3 = new TreeVertex<SimpleNode>(firstLayer3, new SimpleNode(2, true));
		
		return treeRoot;
	}
	
}