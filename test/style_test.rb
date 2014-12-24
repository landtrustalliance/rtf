require 'test_helper'

# Information class unit test class.
class StyleTest < Test::Unit::TestCase
   def test_basics
      style = Style.new

      assert_false style.is_character_style?
      assert_false style.is_document_style?
      assert_false style.is_paragraph_style?
      assert_false style.is_table_style?

      assert_nil style.prefix(nil, nil)
      assert_nil style.suffix(nil, nil)
   end
end
