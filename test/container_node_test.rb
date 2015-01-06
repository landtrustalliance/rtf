require 'test_helper'

# Information class unit test class.
class ContainerNodeTest < Test::Unit::TestCase
  def test01
    nodes = []
    nodes.push(ContainerNode.new(nil))
    nodes.push(ContainerNode.new(nodes[0]))
    
    assert_equal 0, nodes[0].size
    assert_equal 0, nodes[1].size
    
    assert_nil nodes[0].first
    assert_nil nodes[0].last
    assert_nil nodes[1].first
    assert_nil nodes[1].last
    
    assert_nil nodes[0][0]
    assert_nil nodes[1][-1]
    
    count = 0
    nodes[0].each {|entry| count += 1}
    assert_equal 0, count
    nodes[1].each {|entry| count += 1}
    assert_equal 0, count
  end
  
  def test02
    node   = ContainerNode.new(nil)
    child1 = ContainerNode.new(nil)
    child2 = ContainerNode.new(nil)
    
    node.store(child1)
    assert_equal 1, node.size
    assert_equal child1, node[0]
    assert_equal child1, node[-1]
    assert_equal node, node[0].parent
    assert_equal child1, node.first
    assert_equal child1, node.last
    
    count = 0
    node.each {|entry| count += 1}
    assert_equal 1, count
    
    node.store(child2)
    assert_equal 2, node.size
    assert_equal child1, node[0]
    assert_equal child2, node[1]
    assert_equal child2, node[-1]
    assert_equal child1, node[-2]
    assert_equal node, node[0].parent
    assert_equal node, node[1].parent
    assert_equal child1, node.first
    assert_equal child2, node.last
  end
  
  def test_container_node_to_rtf_raises_exception
    assert_raise RTFError do
      ContainerNode.new(nil).to_rtf
    end
  end
end
