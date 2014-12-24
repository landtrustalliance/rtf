require 'test_helper'

# Colour class unit test class.
class ColourTest < Test::Unit::TestCase
  def test_01
    colours = []
    colours.push(Colour.new(255, 255, 255))
    colours.push(Colour.new(200, 0, 0))
    colours.push(Colour.new(0, 150, 0))
    colours.push(Colour.new(0, 0, 100))
    colours.push(Colour.new(0, 0, 0))

    assert_equal colours[0], colours[0]
    refute_equal colours[1], colours[2]
    assert_equal Colour.new(0, 0, 100), colours[3]
    refute_equal 12345, colours[4]

    assert_equal 255, colours[0].red
    assert_equal 255, colours[0].green
    assert_equal 255, colours[0].blue

    assert_equal 200, colours[1].red
    assert_equal 0,   colours[1].green
    assert_equal 0,   colours[1].blue

    assert_equal 0,   colours[2].red
    assert_equal 150, colours[2].green
    assert_equal 0,   colours[2].blue

    assert_equal 0,   colours[3].red
    assert_equal 0,   colours[3].green
    assert_equal 100, colours[3].blue

    assert_equal 0,   colours[4].red
    assert_equal 0,   colours[4].green
    assert_equal 0,   colours[4].blue

    assert_equal '   Colour (255/255/255)', colours[0].to_s(3)
    assert_equal '      Colour (200/0/0)', colours[1].to_s(6)
    assert_equal 'Colour (0/150/0)', colours[2].to_s(-20)
    assert_equal 'Colour (0/0/100)', colours[3].to_s
    assert_equal 'Colour (0/0/0)', colours[4].to_s

    assert_equal '  \red255\green255\blue255;', colours[0].to_rtf(2)
    assert_equal '    \red200\green0\blue0;', colours[1].to_rtf(4)
    assert_equal '\red0\green150\blue0;', colours[2].to_rtf(-6)
    assert_equal '\red0\green0\blue100;', colours[3].to_rtf
    assert_equal '\red0\green0\blue0;', colours[4].to_rtf
  end

  def test_red_out_of_range_raises_exception
    assert_raise RTFError do
      Colour.new(256, 0, 0)
    end
  end

  def test_green_out_of_range_raises_exception
    assert_raise RTFError do
      Colour.new(0, 1000, 0)
    end
  end

  def test_blue_out_of_range_raises_exception
    assert_raise RTFError do
      Colour.new(0, 0, -300)
    end
  end

  def test_red_invalid_type_raises_exception
    assert_raise RTFError do
      Colour.new('La la la', 0, 0)
    end
  end

  def test_green_invalid_type_raises_exception
    assert_raise RTFError do
      Colour.new(0, {}, 0)
    end
  end

  def test_blue_invalid_type_raises_exception
    assert_raise RTFError do
      Colour.new(0, 0, [])
    end
  end
end
