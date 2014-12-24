require 'test_helper'

# FontTable class unit test class.
class FontTableTest < Test::Unit::TestCase
  def setup
    @fonts = []
    @fonts.push(Font.new(Font::MODERN, "Courier New"))
    @fonts.push(Font.new(Font::ROMAN, "Arial"))
    @fonts.push(Font.new(Font::SWISS, "Tahoma"))
    @fonts.push(Font.new(Font::NIL, "La La La"))
  end

  def test_01
    tables = []
    tables.push(FontTable.new)
    tables.push(FontTable.new(@fonts[0], @fonts[2]))
    tables.push(FontTable.new(*@fonts))
    tables.push(FontTable.new(@fonts[0], @fonts[2], @fonts[0]))

    assert_equal 0, tables[0].size
    assert_equal 2, tables[1].size
    assert_equal 4, tables[2].size
    assert_equal 2, tables[3].size

    assert_nil   tables[0][2]
    assert_equal @fonts[2], tables[1][1]
    assert_equal @fonts[3], tables[2][3]
    assert_nil   tables[3][2]

    assert_nil   tables[0].index(@fonts[0])
    assert_equal 1, tables[1].index(@fonts[2])
    assert_equal 2, tables[2].index(@fonts[2])
    assert_nil   tables[3].index(@fonts[1])

    tables[0].add(@fonts[0])
    assert_equal 1, tables[0].size
    assert_equal 0, tables[0].index(@fonts[0])

    tables[0] << @fonts[1]
    assert_equal 2, tables[0].size
    assert_equal 1, tables[0].index(@fonts[1])

    tables[0].add(@fonts[0])
    assert_equal 2, tables[0].size
    assert_equal [@fonts[0], @fonts[1]], [tables[0][0], tables[0][1]]

    tables[0] << @fonts[1]
    assert_equal 2, tables[0].size
    assert_equal [@fonts[0], @fonts[1]], [tables[0][0], tables[0][1]]

    flags = [false, false, false, false]
    tables[2].each do |font|
      flags[@fonts.index(font)] = true if @fonts.index(font) != nil
    end
    assert_nil flags.index(false)

    assert_equal "Font Table (2 fonts)\n"\
                 "   Family: modern, Name: Courier New\n"\
                 "   Family: roman, Name: Arial",
                 tables[0].to_s

    assert_equal "      Font Table (2 fonts)\n"\
                 "         Family: modern, Name: Courier New\n"\
                 "         Family: swiss, Name: Tahoma",
                 tables[1].to_s(6)

    assert_equal "   Font Table (4 fonts)\n"\
                 "      Family: modern, Name: Courier New\n"\
                 "      Family: roman, Name: Arial\n"\
                 "      Family: swiss, Name: Tahoma\n"\
                 "      Family: nil, Name: La La La",
                 tables[2].to_s(3)

    assert_equal "Font Table (2 fonts)\n"\
                 "   Family: modern, Name: Courier New\n"\
                 "   Family: swiss, Name: Tahoma",
                 tables[3].to_s(-10)

    assert_equal "{\\fonttbl\n"\
                 "{\\f0\\fmodern Courier New;}\n"\
                 "{\\f1\\froman Arial;}\n"\
                 "}",
                 tables[0].to_rtf
                 
    assert_equal "    {\\fonttbl\n"\
                 "    {\\f0\\fmodern Courier New;}\n"\
                 "    {\\f1\\fswiss Tahoma;}\n"\
                 "    }",
                 tables[1].to_rtf(4)

    assert_equal "  {\\fonttbl\n"\
                 "  {\\f0\\fmodern Courier New;}\n"\
                 "  {\\f1\\froman Arial;}\n"\
                 "  {\\f2\\fswiss Tahoma;}\n"\
                 "  {\\f3\\fnil La La La;}\n"\
                 "  }",
                 tables[2].to_rtf(2)

    assert_equal "{\\fonttbl\n"\
                 "{\\f0\\fmodern Courier New;}\n"\
                 "{\\f1\\fswiss Tahoma;}\n"\
                 "}",
                 tables[3].to_rtf(-6)
  end
end
