require 'test_helper'

# Information class unit test class.
class DocumentStyleTest < Test::Unit::TestCase
  def test_basics
    style = DocumentStyle.new

    assert_false style.is_character_style?
    assert_true  style.is_document_style?
    assert_false style.is_paragraph_style?
    assert_false style.is_table_style?

    assert_equal '\paperw11907\paperh16840\margl1800'\
                 '\margr1800\margt1440\margb1440',
                 style.prefix(nil, nil)
    assert_nil style.suffix(nil, nil)

    assert_equal DocumentStyle::DEFAULT_BOTTOM_MARGIN, style.bottom_margin
    assert_nil   style.gutter
    assert_equal DocumentStyle::DEFAULT_LEFT_MARGIN, style.left_margin
    assert_equal DocumentStyle::PORTRAIT, style.orientation
    assert_equal Paper::A4, style.paper
    assert_equal DocumentStyle::DEFAULT_RIGHT_MARGIN, style.right_margin
    assert_equal DocumentStyle::DEFAULT_TOP_MARGIN, style.top_margin
  end

  def test_mutators
    style = DocumentStyle.new

    style.bottom_margin = 200
    assert_equal 200, style.bottom_margin

    style.gutter = 1000
    assert_equal 1000, style.gutter

    style.left_margin = 34
    assert_equal 34, style.left_margin

    style.orientation = DocumentStyle::LANDSCAPE
    assert_equal DocumentStyle::LANDSCAPE, style.orientation

    style.paper = Paper::LETTER
    assert_equal Paper::LETTER, style.paper

    style.right_margin = 345
    assert_equal 345, style.right_margin

    style.top_margin = 819
    assert_equal 819, style.top_margin
  end

  def test_prefix
    style = DocumentStyle.new

    style.left_margin = style.right_margin = 200
    style.top_margin  = style.bottom_margin = 100
    style.gutter      = 300
    style.orientation = DocumentStyle::LANDSCAPE
    style.paper       = Paper::A5

    assert_equal '\paperw11907\paperh8392\margl200'\
                 '\margr200\margt100\margb100\gutter300'\
                 '\sectd\lndscpsxn',
                 style.prefix(nil, nil)
  end

  def test_body_method
    style = DocumentStyle.new

    lr_margin = style.left_margin + style.right_margin
    tb_margin = style.top_margin + style.bottom_margin

    assert_equal Paper::A4.width - lr_margin, style.body_width
    assert_equal Paper::A4.height - tb_margin, style.body_height

    style.orientation = DocumentStyle::LANDSCAPE

    assert_equal Paper::A4.height - lr_margin, style.body_width
    assert_equal Paper::A4.width - tb_margin, style.body_height
  end
end
