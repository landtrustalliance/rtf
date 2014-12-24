require 'test_helper'

# Information class unit test class.
class CharacterStyleTest < Test::Unit::TestCase
   def test_basics
      style = CharacterStyle.new

      assert_true  style.is_character_style?
      assert_false style.is_document_style?
      assert_false style.is_paragraph_style?
      assert_false style.is_table_style?

      assert_nil   style.prefix(nil, nil)
      assert_nil   style.suffix(nil, nil)

      assert_nil   style.background
      assert_false style.bold
      assert_false style.capitalise
      assert_equal CharacterStyle::LEFT_TO_RIGHT, style.flow
      assert_nil   style.font
      assert_nil   style.font_size
      assert_nil   style.foreground
      assert_false style.hidden
      assert_false style.italic
      assert_false style.strike
      assert_false style.subscript
      assert_false style.superscript
      assert_false style.underline
   end

  def test_mutators
     style = CharacterStyle.new

     style.background = Colour.new(100, 100, 100)
     assert_equal Colour.new(100, 100, 100), style.background

     style.bold = true
     assert_true style.bold

     style.capitalise = true
     assert_true style.capitalize

     style.flow = CharacterStyle::RIGHT_TO_LEFT
     assert_equal CharacterStyle::RIGHT_TO_LEFT, style.flow

     style.font = Font.new(Font::ROMAN, 'Arial')
     assert_equal Font.new(Font::ROMAN, 'Arial'), style.font

     style.font_size = 38
     assert_equal 38, style.font_size

     style.foreground = Colour.new(250, 200, 150)
     assert_equal Colour.new(250, 200, 150), style.foreground

     style.hidden = true
     assert_true style.hidden

     style.italic = true
     assert_true style.italic

     style.strike = true
     assert_true style.strike

     style.subscript = true
     assert_true style.subscript

     style.superscript = true
     assert_true style.superscript

     style.underline = true
     assert_true style.underline
  end

  def test_prefix
     fonts   = FontTable.new(Font.new(Font::ROMAN, 'Arial'))
     colours = ColourTable.new(Colour.new(100, 100, 100))
     style   = CharacterStyle.new

     style.background = colours[0]
     assert_equal '\cb1', style.prefix(fonts, colours)

     style.background = nil
     style.bold       = true
     assert_equal '\b', style.prefix(nil, nil)

     style.bold       = false
     style.capitalise = true
     assert_equal '\caps', style.prefix(nil, nil)

     style.capitalize = false
     style.flow       = CharacterStyle::RIGHT_TO_LEFT
     assert_equal '\rtlch', style.prefix(nil, nil)

     style.flow = nil
     style.font = fonts[0]
     assert_equal '\f0', style.prefix(fonts, colours)

     style.font      = nil
     style.font_size = 40
     assert_equal '\fs40', style.prefix(nil, nil)

     style.font_size  = nil
     style.foreground = colours[0]
     assert_equal '\cf1', style.prefix(fonts, colours)

     style.foreground = nil
     style.hidden     = true
     assert_equal '\v', style.prefix(nil, nil)

     style.hidden = false
     style.italic = true
     assert_equal '\i', style.prefix(nil, nil)

     style.italic = false
     style.strike = true
     assert_equal '\strike', style.prefix(nil, nil)

     style.strike    = false
     style.subscript = true
     assert_equal '\sub', style.prefix(nil, nil)

     style.subscript   = false
     style.superscript = true
     assert_equal '\super', style.prefix(fonts, colours)

     style.superscript = false
     style.underline   = true
     assert_equal '\ul', style.prefix(fonts, colours)

     style.flow       = CharacterStyle::RIGHT_TO_LEFT
     style.background = colours[0]
     style.font_size  = 18
     style.subscript  = true
     assert_equal '\ul\sub\cb1\fs18\rtlch', style.prefix(fonts, colours)
  end
end
