package test;

import gameLogic.ai.AlphaBeta;
import gameLogic.ai.AlphaBeta.SimpleNode;
import gameLogic.ai.MinMax.MinMaxNode;
import gameLogic.ai.tree.TreeVertex;
import haxe.unit.TestCase;

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
	
	public function testTestSimpleTree()
	{
		assertEquals(3, AlphaBeta.valueAlfaBeta(generateTree1(), -1000, 1000));
		assertEquals(7, AlphaBeta.valueAlfaBeta(generateTree2(),-1000,1000));
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