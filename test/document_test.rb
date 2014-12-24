require 'test_helper'

# Information class unit test class.
class DocumentTest < Test::Unit::TestCase
   def setup
      @fonts = FontTable.new

      @fonts << Font.new(Font::ROMAN, 'Arial')
      @fonts << Font.new(Font::MODERN, 'Courier')
   end

   def test_basics
      documents = []
      style     = DocumentStyle.new

      documents << Document.new(@fonts[0])
      documents << Document.new(@fonts[1], style)
      documents << Document.new(@fonts[0], nil, Document::CS_MAC)
      documents << Document.new(@fonts[1], style, Document::CS_PC,
                                Document::LC_ENGLISH_US)

      lr_margin = DocumentStyle::DEFAULT_LEFT_MARGIN +
                  DocumentStyle::DEFAULT_RIGHT_MARGIN
      tb_margin = DocumentStyle::DEFAULT_TOP_MARGIN +
                  DocumentStyle::DEFAULT_BOTTOM_MARGIN

      fonts     = []
      fonts << FontTable.new(@fonts[0])
      fonts << FontTable.new(@fonts[1])

      assert_equal Document::CS_ANSI, documents[0].character_set
      assert_equal Document::CS_ANSI, documents[1].character_set
      assert_equal Document::CS_MAC, documents[2].character_set
      assert_equal Document::CS_PC, documents[3].character_set

      assert_equal 1, documents[0].fonts.size
      assert_equal 1, documents[1].fonts.size
      assert_equal 1, documents[2].fonts.size
      assert_equal 1, documents[3].fonts.size

      assert_equal @fonts[0], documents[0].fonts[0]
      assert_equal @fonts[1], documents[1].fonts[0]
      assert_equal @fonts[0], documents[2].fonts[0]
      assert_equal @fonts[1], documents[3].fonts[0]

      assert_equal 0, documents[0].colours.size
      assert_equal 0, documents[1].colours.size
      assert_equal 0, documents[2].colours.size
      assert_equal 0, documents[3].colours.size

      assert_equal Document::LC_ENGLISH_UK, documents[0].language
      assert_equal Document::LC_ENGLISH_UK, documents[1].language
      assert_equal Document::LC_ENGLISH_UK, documents[2].language
      assert_equal Document::LC_ENGLISH_US, documents[3].language

      assert_not_nil documents[0].style
      assert_equal   style, documents[1].style
      assert_not_nil documents[2].style
      assert_equal   style, documents[3].style

      assert_equal Paper::A4.width - lr_margin, documents[0].body_width
      assert_equal Paper::A4.height - tb_margin, documents[0].body_height
      assert_equal @fonts[0], documents[0].default_font
      assert_equal Paper::A4, documents[0].paper
      assert_nil   documents[0].header
      assert_nil   documents[0].header(HeaderNode::UNIVERSAL)
      assert_nil   documents[0].header(HeaderNode::LEFT_PAGE)
      assert_nil   documents[0].header(HeaderNode::RIGHT_PAGE)
      assert_nil   documents[0].header(HeaderNode::FIRST_PAGE)
      assert_nil   documents[0].footer
      assert_nil   documents[0].footer(FooterNode::UNIVERSAL)
      assert_nil   documents[0].footer(FooterNode::LEFT_PAGE)
      assert_nil   documents[0].footer(FooterNode::RIGHT_PAGE)
      assert_nil   documents[0].footer(FooterNode::FIRST_PAGE)
   end

   def test_mutators
      document = Document.new(@fonts[0])

      document.default_font = @fonts[1]
      assert_equal @fonts[1], document.default_font

      document.character_set = Document::CS_PCA
      assert_equal Document::CS_PCA, document.character_set

      document.language = Document::LC_CZECH
      assert_equal Document::LC_CZECH, document.language
   end

   def test_page_break
      document = Document.new(@fonts[0])

      assert_nil   document.page_break
      assert_equal 1, document.size
      assert_equal '\page', document[0].prefix
   end

   def test_changing_document_parent_raises_exception
      document = Document.new(@fonts[0])
      assert_raise RTFError do
         document.parent = document
      end
   end
end
