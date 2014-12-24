# encoding:UTF-8
require 'test_helper'

# Information class unit test class.
class TextNodeTest < Test::Unit::TestCase
   def setup
      @node = Node.new(nil)
   end

   def test01
      nodes = []
      nodes.push(TextNode.new(@node))
      nodes.push(TextNode.new(@node, 'Node 2'))
      nodes.push(TextNode.new(@node))
      nodes.push(TextNode.new(@node, ''))

      assert_nil   nodes[0].text
      assert_equal 'Node 2', nodes[1].text
      assert_nil   nodes[2].text
      assert_equal '', nodes[3].text

      nodes[0].text = 'This is the altered text for node 1.'
      assert_equal 'This is the altered text for node 1.', nodes[0].text

      nodes[1].append('La la la')
      nodes[2].append('La la la')
      assert_equal 'Node 2La la la', nodes[1].text
      assert_equal 'La la la', nodes[2].text

      nodes[2].text = nil
      nodes[1].insert(' - ', 6)
      nodes[2].insert('TEXT', 2)
      assert_equal 'Node 2 - La la la', nodes[1].text
      assert_equal 'TEXT', nodes[2].text

      nodes[2].text = nil
      nodes[3].text = '{\}'
      assert_equal 'This is the altered text for node 1.', nodes[0].to_rtf
      assert_equal 'Node 2 - La la la', nodes[1].to_rtf
      assert_equal '', nodes[2].to_rtf
      assert_equal '\{\\\}', nodes[3].to_rtf
   end

   def test_creating_text_node_without_parent_raises_exception
      assert_raise RTFError do
         TextNode.new(nil)
      end
   end

   def test_utf8
     nodes = []
     nodes.push(TextNode.new(@node))
     nodes.push(TextNode.new(@node))

     nodes[0].text = "ASCCI"
     assert_equal "ASCCI", nodes[0].to_rtf

     utf8 = "Á"
     exp = "\\u#{utf8.unpack("U")[0]}\\'3f"
     nodes[0].text=utf8
     assert_equal exp, nodes[0].to_rtf
   end
end
