require 'test_helper'

# Font class unit test class.
class FontTest < Test::Unit::TestCase
  def test_01
    fonts = []
    fonts.push(Font.new(Font::MODERN, "Courier New"))
    fonts.push(Font.new(Font::ROMAN, "Arial"))
    fonts.push(Font.new(Font::SWISS, "Tahoma"))
    fonts.push(Font.new(Font::NIL, "La La La"))

    assert_equal fonts[0], fonts[0]
    refute_equal fonts[1], fonts[0]
    refute_equal 'a string of text', fonts[1]
    assert_equal Font.new(Font::SWISS, "Tahoma"), fonts[2]

    assert_equal Font::MODERN, fonts[0].family
    assert_equal Font::ROMAN, fonts[1].family
    assert_equal Font::SWISS, fonts[2].family
    assert_equal Font::NIL, fonts[3].family

    assert_equal 'Courier New', fonts[0].name
    assert_equal 'Arial', fonts[1].name
    assert_equal 'Tahoma', fonts[2].name
    assert_equal 'La La La', fonts[3].name

    assert_equal 'Family: modern, Name: Courier New', fonts[0].to_s
    assert_equal '   Family: roman, Name: Arial', fonts[1].to_s(3)
    assert_equal '      Family: swiss, Name: Tahoma', fonts[2].to_s(6)
    assert_equal 'Family: nil, Name: La La La', fonts[3].to_s(-1)

    assert_equal '\fmodern Courier New;', fonts[0].to_rtf
    assert_equal '  \froman Arial;', fonts[1].to_rtf(2)
    assert_equal '    \fswiss Tahoma;', fonts[2].to_rtf(4)
    assert_equal '\fnil La La La;', fonts[3].to_rtf(-6)
  end

  def test_invalid_font_family_raises_exception
    assert_raise RTFError do
      Font.new(12345, "Ningy")
    end
  end
end
