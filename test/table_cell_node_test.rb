require 'test_helper'

# Information class unit test class.
class TableCellNodeTest < Test::Unit::TestCase
   def setup
      @table = TableNode.new(nil, 3, 3, 100, 100, 100)
      @row   = TableRowNode.new(@table, 3, 100)
   end

   def test_basics
      cells = []
      cells.push(TableCellNode.new(@row))
      cells.push(TableCellNode.new(@row, 1000))
      cells.push(TableCellNode.new(@row, 250, nil, 5, 10, 15, 20))

      assert_equal @row, cells[0].parent
      assert_equal TableCellNode::DEFAULT_WIDTH, cells[0].width
      assert_equal 0, cells[0].top_border_width
      assert_equal 0, cells[0].right_border_width
      assert_equal 0, cells[0].bottom_border_width
      assert_equal 0, cells[0].left_border_width

      assert_equal @row, cells[1].parent
      assert_equal 1000, cells[1].width
      assert_equal 0, cells[1].top_border_width
      assert_equal 0, cells[1].right_border_width
      assert_equal 0, cells[1].bottom_border_width
      assert_equal 0, cells[1].left_border_width

      assert_equal @row, cells[2].parent
      assert_equal 250, cells[2].width
      assert_equal 5, cells[2].top_border_width
      assert_equal 10, cells[2].right_border_width
      assert_equal 15, cells[2].bottom_border_width
      assert_equal 20, cells[2].left_border_width

      cells[0].top_border_width    = 25
      cells[0].bottom_border_width = 1
      cells[0].left_border_width   = 89
      cells[0].right_border_width  = 57

      assert_equal 25, cells[0].top_border_width
      assert_equal 57, cells[0].right_border_width
      assert_equal 1, cells[0].bottom_border_width
      assert_equal 89, cells[0].left_border_width

      cells[0].top_border_width    = 0
      cells[0].bottom_border_width = nil
      cells[0].left_border_width   = -5
      cells[0].right_border_width  = -1000

      assert_equal 0, cells[0].top_border_width
      assert_equal 0, cells[0].right_border_width
      assert_equal 0, cells[0].bottom_border_width
      assert_equal 0, cells[0].left_border_width

      assert_equal [5, 10, 15, 20], cells[2].border_widths
   end

   def test_calling_paragraph_on_table_cell_node_raises_exception
      assert_raise RTFError do
         @row[0].paragraph
      end
   end

   def test_calling_parent_on_table_cell_node_raises_exception
      assert_raise RTFError do
         @row[0].parent = nil
      end
   end

   def test_calling_table_on_table_cell_node_raises_exception
      assert_raise RTFError do
         @row[0].table(nil, nil)
      end
   end

   def test_rtf_generation
      cells = []
      cells.push(TableCellNode.new(@row))
      cells.push(TableCellNode.new(@row))
      cells[1] << "Added text."

      assert_equal "\\pard\\intbl\n\n\\cell", cells[0].to_rtf
      assert_equal "\\pard\\intbl\nAdded text.\n\\cell", cells[1].to_rtf
   end
end
