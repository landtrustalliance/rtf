require 'test_helper'

# Information class unit test class.
class NodeTest < Test::Unit::TestCase
  def test01
    nodes = []
    nodes.push(Node.new(nil))
    nodes.push(Node.new(nodes[0]))
    
    assert_nil     nodes[0].parent
    assert_not_nil nodes[1].parent
    assert_equal   nodes[0], nodes[1].parent
    
    assert_true  nodes[0].is_root? 
    assert_false nodes[1].is_root?
    
    assert_equal nodes[0], nodes[0].root
    assert_equal nodes[0], nodes[1].root
    
    assert_nil nodes[0].previous_node
    assert_nil nodes[0].next_node
    assert_nil nodes[1].previous_node
    assert_nil nodes[1].next_node
  end
end
