require 'test_helper'

# Information class unit test class.
class ParagraphStyleTest < Test::Unit::TestCase
   def test_basics
      style = ParagraphStyle.new

      assert_false style.is_character_style?
      assert_false style.is_document_style?
      assert_true  style.is_paragraph_style?
      assert_false style.is_table_style?

      assert_equal '\ql', style.prefix(nil, nil)
      assert_nil   style.suffix(nil, nil)

      assert_nil   style.first_line_indent
      assert_equal ParagraphStyle::LEFT_TO_RIGHT, style.flow
      assert_equal ParagraphStyle::LEFT_JUSTIFY, style.justification
      assert_nil   style.left_indent
      assert_nil   style.right_indent
      assert_nil   style.line_spacing
      assert_nil   style.space_after
      assert_nil   style.space_before
   end

  def test_mutators
     style = ParagraphStyle.new

     style.first_line_indent = 100
     assert_equal 100, style.first_line_indent

     style.flow = ParagraphStyle::RIGHT_TO_LEFT
     assert_equal ParagraphStyle::RIGHT_TO_LEFT, style.flow

     style.justification = ParagraphStyle::RIGHT_JUSTIFY
     assert_equal ParagraphStyle::RIGHT_JUSTIFY, style.justification

     style.left_indent = 234
     assert_equal 234, style.left_indent

     style.right_indent = 1020
     assert_equal 1020, style.right_indent

     style.line_spacing = 645
     assert_equal 645, style.line_spacing

     style.space_after = 25
     assert_equal 25, style.space_after

     style.space_before = 918
     assert_equal 918, style.space_before
  end

  def test_prefix
     style   = ParagraphStyle.new

     style.first_line_indent = 100
     assert_equal '\ql\fi100', style.prefix(nil, nil)

     style.flow = ParagraphStyle::RIGHT_TO_LEFT
     assert_equal '\ql\fi100\rtlpar', style.prefix(nil, nil)

     style.justification = ParagraphStyle::RIGHT_JUSTIFY
     assert_equal '\qr\fi100\rtlpar', style.prefix(nil, nil)

     style.left_indent = 234
     assert_equal '\qr\li234\fi100\rtlpar', style.prefix(nil, nil)

     style.right_indent = 1020
     assert_equal '\qr\li234\ri1020\fi100\rtlpar', style.prefix(nil, nil)

     style.line_spacing = 645
     assert_equal '\qr\li234\ri1020\fi100\sl645\rtlpar', style.prefix(nil, nil)

     style.space_after = 25
     assert_equal '\qr\li234\ri1020\fi100\sa25\sl645\rtlpar', style.prefix(nil, nil)

     style.space_before = 918
     assert_equal '\qr\li234\ri1020\fi100\sb918\sa25\sl645\rtlpar', style.prefix(nil, nil)
  end
end
