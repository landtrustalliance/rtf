require 'test_helper'

# Information class unit test class.
class TableRowNodeTest < Test::Unit::TestCase
   def setup
      @table = TableNode.new(nil, 3, 3, 100, 100, 100)
   end

   def test_basics
      rows = []
      rows.push(TableRowNode.new(@table, 10))
      rows.push(TableRowNode.new(@table, 3, 100, 200, 300))

      assert_equal 10, rows[0].size
      assert_equal 3, rows[1].size

      assert_equal TableCellNode::DEFAULT_WIDTH, rows[0][0].width
      assert_equal TableCellNode::DEFAULT_WIDTH, rows[0][1].width
      assert_equal TableCellNode::DEFAULT_WIDTH, rows[0][2].width
      assert_equal TableCellNode::DEFAULT_WIDTH, rows[0][3].width
      assert_equal TableCellNode::DEFAULT_WIDTH, rows[0][4].width
      assert_equal TableCellNode::DEFAULT_WIDTH, rows[0][5].width
      assert_equal TableCellNode::DEFAULT_WIDTH, rows[0][6].width
      assert_equal TableCellNode::DEFAULT_WIDTH, rows[0][7].width
      assert_equal TableCellNode::DEFAULT_WIDTH, rows[0][8].width
      assert_equal TableCellNode::DEFAULT_WIDTH, rows[0][9].width
      assert_equal 100, rows[1][0].width
      assert_equal 200, rows[1][1].width
      assert_equal 300, rows[1][2].width

      assert_equal [0, 0, 0, 0], rows[0][1].border_widths
      rows[0].border_width = 10
      assert_equal [10, 10, 10, 10], rows[0][1].border_widths
   end

   def test_calling_parent_on_table_row_node_raises_exception
      row = TableRowNode.new(@table, 1)
      assert_raise RTFError do
         row.parent = nil
      end
   end

   def test_rtf_generation
      rows = []
      rows.push(TableRowNode.new(@table, 3, 50, 50, 50))
      rows.push(TableRowNode.new(@table, 1, 134))
      rows[1].border_width = 5
      assert_equal "\\trowd\\tgraph100\n\\cellx50\n\\cellx100\n"\
                   "\\cellx150\n\\pard\\intbl\n\n\\cell\n"\
                   "\\pard\\intbl\n\n\\cell\n"\
                   "\\pard\\intbl\n\n\\cell\n\\row",
                   rows[0].to_rtf
      assert_equal "\\trowd\\tgraph100\n"\
                 "\\clbrdrt\\brdrw5\\brdrs\\clbrdrl\\brdrw5\\brdrs"\
                 "\\clbrdrb\\brdrw5\\brdrs\\clbrdrr\\brdrw5\\brdrs"\
                 "\\cellx134\n\\pard\\intbl\n\n\\cell\n\\row",
                 rows[1].to_rtf
   end
end
