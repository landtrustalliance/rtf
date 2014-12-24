require 'test_helper'

# Information class unit test class.
class FooterNodeTest < Test::Unit::TestCase
  def setup
    @document = Document.new(Font.new(Font::ROMAN, 'Arial'))
  end

  def test_basics
    footers = []

    footers << FooterNode.new(@document)
    footers << FooterNode.new(@document, FooterNode::LEFT_PAGE)

    assert_equal @document, footers[0].parent
    assert_equal @document, footers[1].parent

    assert_equal FooterNode::UNIVERSAL, footers[0].type
    assert_equal FooterNode::LEFT_PAGE, footers[1].type
  end

  def test_adding_footnote_to_footer_raises_exception
    footer = FooterNode.new(@document)
    assert_raise RTFError do
      footer.footnote("La la la.")
    end
  end
end
