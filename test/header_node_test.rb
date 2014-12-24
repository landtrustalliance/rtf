require 'test_helper'

# Information class unit test class.
class HeaderNodeTest < Test::Unit::TestCase
  def setup
    @document = Document.new(Font.new(Font::ROMAN, 'Arial'))
  end

  def test_basics
    headers = []

    headers << HeaderNode.new(@document)
    headers << HeaderNode.new(@document, HeaderNode::LEFT_PAGE)

    assert_equal @document, headers[0].parent
    assert_equal @document, headers[1].parent

    assert_equal HeaderNode::UNIVERSAL, headers[0].type
    assert_equal HeaderNode::LEFT_PAGE, headers[1].type
  end

  def test_adding_footnote_to_header_raises_exception
    headers = HeaderNode.new(@document)
    assert_raise RTFError do
      headers.footnote("La la la.")
    end
  end
end
