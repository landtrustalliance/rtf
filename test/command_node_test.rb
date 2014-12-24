require 'test_helper'

# Information class unit test class.
class CommandNodeTest < Test::Unit::TestCase
   def test_basics
      nodes = []
      nodes.push(CommandNode.new(nil, 'prefix'))
      nodes.push(CommandNode.new(nil, '', 'lalala'))
      nodes.push(CommandNode.new(nodes[0], '', nil, false))

      assert_equal 'prefix', nodes[0].prefix
      assert_equal '', nodes[1].prefix
      assert_equal '', nodes[2].prefix

      assert_nil   nodes[0].suffix
      assert_equal 'lalala', nodes[1].suffix
      assert_nil   nodes[2].suffix

      assert_true  nodes[0].split
      assert_true  nodes[1].split
      assert_false nodes[2].split
   end

   # Test line breaks.
   def test_line_break
      root = CommandNode.new(nil, nil)

      assert_nil   root.line_break
      assert_equal 1, root.size
      assert_equal CommandNode, root[0].class
      assert_equal '\line', root[0].prefix
      assert_nil   root[0].suffix
      assert_false root[0].split
   end

   # Test paragraphs.
   def test_paragraph
      root  = CommandNode.new(nil, nil)
      style = ParagraphStyle.new

      assert_not_nil root.paragraph(style)
      assert_equal 1, root.size
      assert_equal ParagraphNode, root[0].class
      assert_equal '\pard\ql', root[0].prefix
      assert_equal '\par', root[0].suffix
      assert_true  root.split

      style.justification = ParagraphStyle::RIGHT_JUSTIFY
      assert_equal '\pard\qr', root.paragraph(style).prefix

      style.justification = ParagraphStyle::CENTRE_JUSTIFY
      assert_equal '\pard\qc', root.paragraph(style).prefix

      style.justification = ParagraphStyle::FULL_JUSTIFY
      assert_equal '\pard\qj', root.paragraph(style).prefix

      style.justification = ParagraphStyle::LEFT_JUSTIFY
      style.space_before = 100
      root.paragraph(style)
      assert_equal '\pard\ql\sb100', root[-1].prefix

      style.space_before = nil
      style.space_after  = 1234
      root.paragraph(style)
      assert_equal '\pard\ql\sa1234', root[-1].prefix

      style.space_before = nil
      style.space_after  = nil
      style.left_indent  = 10
      root.paragraph(style)
      assert_equal '\pard\ql\li10', root[-1].prefix

      style.space_before = nil
      style.space_after  = nil
      style.left_indent  = nil
      style.right_indent = 234
      root.paragraph(style)
      assert_equal '\pard\ql\ri234', root[-1].prefix

      style.space_before      = nil
      style.space_after       = nil
      style.left_indent       = nil
      style.right_indent      = nil
      style.first_line_indent = 765
      root.paragraph(style)
      assert_equal '\pard\ql\fi765', root[-1].prefix

      style.space_before      = 12
      style.space_after       = 23
      style.left_indent       = 34
      style.right_indent      = 45
      style.first_line_indent = 56
      root.paragraph(style)
      assert_equal '\pard\ql\li34\ri45\fi56\sb12\sa23', root[-1].prefix

      node = nil
      root.paragraph(style) {|n| node = n}
      assert_equal root[-1], node
   end

   # Test applications of styles.
   def test_style
      root  = Document.new(Font.new(Font::ROMAN, 'Arial'))
      style = CharacterStyle.new
      style.bold = true

      assert_not_nil root.apply(style)
      assert_equal 1, root.size
      assert_equal CommandNode, root[0].class
      assert_equal '\b', root[0].prefix
      assert_nil   root[0].suffix
      assert_true  root[0].split

      style.underline = true
      assert_equal '\b\ul', root.apply(style).prefix

      style.bold        = false
      style.superscript = true
      assert_equal '\ul\super', root.apply(style).prefix

      style.underline = false
      style.italic    = true
      assert_equal '\i\super', root.apply(style).prefix

      style.italic = false
      style.bold   = true
      assert_equal '\b\super', root.apply(style).prefix

      style.bold        = false
      style.superscript = false
      style.italic      = true
      style.font_size   = 20
      assert_equal '\i\fs20', root.apply(style).prefix

      node = nil
      root.apply(style) {|n| node = n}
      assert_equal root[-1], node

      # Test style short cuts.
      node = root.bold
      assert_equal '\b', node.prefix
      assert_nil node.suffix
      assert_equal root[-1], node

      node = root.italic
      assert_equal '\i', node.prefix
      assert_nil node.suffix
      assert_equal root[-1], node

      node = root.underline
      assert_equal '\ul', node.prefix
      assert_nil node.suffix
      assert_equal root[-1], node

      node = root.superscript
      assert_equal '\super', node.prefix
      assert_nil node.suffix
      assert_equal root[-1], node

      node = root.subscript
      assert_equal '\sub', node.prefix
      assert_nil node.suffix
      assert_equal root[-1], node

      node = root.strike
      assert_equal '\strike', node.prefix
      assert_nil node.suffix
      assert_equal root[-1], node
   end

   # Test text node addition.
   def test_text
      root = CommandNode.new(nil, nil)

      root << 'A block of text.'
      assert_equal 1, root.size
      assert_equal TextNode, root[0].class
      assert_equal 'A block of text.', root[0].text

      root << " More text."
      assert_equal 1, root.size
      assert_equal TextNode, root[0].class
      assert_equal 'A block of text. More text.', root[0].text

      root.paragraph
      root << "A new node."
      assert_equal 3, root.size
      assert_equal TextNode, root[0].class
      assert_equal TextNode, root[-1].class
      assert_equal 'A block of text. More text.', root[0].text
      assert_equal 'A new node.', root[-1].text
   end

   # Test table addition.
   def test_table
      root  = CommandNode.new(nil, nil)

      table = root.table(3, 3, 100, 150, 200)
      assert_equal 1, root.size
      assert_equal TableNode, root[0].class
      assert_equal table, root[0]
      assert_equal 3, table.rows
      assert_equal 3, table.columns

      assert_equal 100, table[0][0].width
      assert_equal 150, table[0][1].width
      assert_equal 200, table[0][2].width
   end

   # List object model test
   def test_list
      root = Document.new(Font.new(Font::ROMAN, 'Arial'))
      root.list do |l1|
        assert_equal ListLevelNode, l1.class
        assert_equal 1, l1.level

        l1.item do |li|
          assert_equal ListTextNode, li.class
          text = li << 'text'
          assert_equal TextNode, text.class
          assert_equal 'text', text.text
        end

        l1.list do |l2|
          assert_equal ListLevelNode, l2.class
          assert_equal 2, l2.level
          l2.item do |li|
            text = li << 'text'
            assert_equal TextNode, text.class
            assert_equal 'text', text.text
          end
        end
      end
   end

   # This test checks the previous_node and next_node methods that could not be
   # fully and properly checked in the NodeTest.rb file.
   def test_peers
      root  = Document.new(Font.new(Font::ROMAN, 'Arial'))
      nodes = []
      nodes.push(root.paragraph)
      nodes.push(root.bold)
      nodes.push(root.underline)

      assert_nil root.previous_node
      assert_nil root.next_node
      assert_equal nodes[0], nodes[1].previous_node
      assert_equal nodes[2], nodes[1].next_node
   end
end
