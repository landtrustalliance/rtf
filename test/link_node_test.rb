require 'test_helper'

class LinkNodeTest < Test::Unit::TestCase
  def test_basics
    root = CommandNode.new(nil, nil)
    assert_not_nil root.link('www.google.com')
    assert_equal LinkNode, root[0].class
    assert_equal "\\field{\\*\\fldinst HYPERLINK \"www.google.com\"}{\\fldrslt ", root[0].prefix
    assert_equal "}", root[0].suffix
  end
end