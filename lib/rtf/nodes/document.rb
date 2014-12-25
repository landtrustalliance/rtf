module RTF
  # This class represents an RTF document. In actuality it is just a
  # specialised Node type that cannot be assigned a parent and that holds
  # document font, colour and information tables.
  class Document < CommandNode
    # A definition for a document character set setting.
    CS_ANSI                          = :ansi

    # A definition for a document character set setting.
    CS_MAC                           = :mac

    # A definition for a document character set setting.
    CS_PC                            = :pc

    # A definition for a document character set setting.
    CS_PCA                           = :pca

    # A definition for a document language setting.
    LC_AFRIKAANS                     = 1078

    # A definition for a document language setting.
    LC_ARABIC                        = 1025

    # A definition for a document language setting.
    LC_CATALAN                       = 1027

    # A definition for a document language setting.
    LC_CHINESE_TRADITIONAL           = 1028

    # A definition for a document language setting.
    LC_CHINESE_SIMPLIFIED            = 2052

    # A definition for a document language setting.
    LC_CZECH                         = 1029

    # A definition for a document language setting.
    LC_DANISH                        = 1030

    # A definition for a document language setting.
    LC_DUTCH                         = 1043

    # A definition for a document language setting.
    LC_DUTCH_BELGIAN                 = 2067

    # A definition for a document language setting.
    LC_ENGLISH_UK                    = 2057

    # A definition for a document language setting.
    LC_ENGLISH_US                    = 1033

    # A definition for a document language setting.
    LC_FINNISH                       = 1035

    # A definition for a document language setting.
    LC_FRENCH                        = 1036

    # A definition for a document language setting.
    LC_FRENCH_BELGIAN                = 2060

    # A definition for a document language setting.
    LC_FRENCH_CANADIAN               = 3084

    # A definition for a document language setting.
    LC_FRENCH_SWISS                  = 4108

    # A definition for a document language setting.
    LC_GERMAN                        = 1031

    # A definition for a document language setting.
    LC_GERMAN_SWISS                  = 2055

    # A definition for a document language setting.
    LC_GREEK                         = 1032

    # A definition for a document language setting.
    LC_HEBREW                        = 1037

    # A definition for a document language setting.
    LC_HUNGARIAN                     = 1038

    # A definition for a document language setting.
    LC_ICELANDIC                     = 1039

    # A definition for a document language setting.
    LC_INDONESIAN                    = 1057

    # A definition for a document language setting.
    LC_ITALIAN                       = 1040

    # A definition for a document language setting.
    LC_JAPANESE                      = 1041

    # A definition for a document language setting.
    LC_KOREAN                        = 1042

    # A definition for a document language setting.
    LC_NORWEGIAN_BOKMAL              = 1044

    # A definition for a document language setting.
    LC_NORWEGIAN_NYNORSK             = 2068

    # A definition for a document language setting.
    LC_POLISH                        = 1045

    # A definition for a document language setting.
    LC_PORTUGUESE                    = 2070

    # A definition for a document language setting.
    LC_POTUGUESE_BRAZILIAN           = 1046

    # A definition for a document language setting.
    LC_ROMANIAN                      = 1048

    # A definition for a document language setting.
    LC_RUSSIAN                       = 1049

    # A definition for a document language setting.
    LC_SERBO_CROATIAN_CYRILLIC       = 2074

    # A definition for a document language setting.
    LC_SERBO_CROATIAN_LATIN          = 1050

    # A definition for a document language setting.
    LC_SLOVAK                        = 1051

    # A definition for a document language setting.
    LC_SPANISH_CASTILLIAN            = 1034

    # A definition for a document language setting.
    LC_SPANISH_MEXICAN               = 2058

    # A definition for a document language setting.
    LC_SWAHILI                       = 1089

    # A definition for a document language setting.
    LC_SWEDISH                       = 1053

    # A definition for a document language setting.
    LC_THAI                          = 1054

    # A definition for a document language setting.
    LC_TURKISH                       = 1055

    # A definition for a document language setting.
    LC_UNKNOWN                       = 1024

    # A definition for a document language setting.
    LC_VIETNAMESE                    = 1066

    # Attribute accessor.
    attr_reader :fonts, :lists, :colours, :information, :character_set,
            :language, :style

    # Attribute mutator.
    attr_writer :character_set, :language


    # This is a constructor for the Document class.
    #
    # ==== Parameters
    # font::       The default font to be used by the document.
    # style::      The style settings to be applied to the document. This
    #              defaults to nil.
    # character::  The character set to be applied to the document. This
    #              defaults to Document::CS_ANSI.
    # language::   The language setting to be applied to document. This
    #              defaults to Document::LC_ENGLISH_UK.
    def initialize(font, style=nil, character=CS_ANSI, language=LC_ENGLISH_UK)
      super(nil, '\rtf1')
      @fonts         = FontTable.new(font)
      @lists         = ListTable.new
      @default_font  = 0
      @colours       = ColourTable.new
      @information   = Information.new
      @character_set = character
      @language      = language
      @style         = style == nil ? DocumentStyle.new : style
      @headers       = [nil, nil, nil, nil]
      @footers       = [nil, nil, nil, nil]
      @id            = 0
    end

    # This method provides a method that can be called to generate an
    # identifier that is unique within the document.
    def get_id
      @id += 1
      Time.now().strftime('%d%m%y') + @id.to_s
    end

    # Attribute accessor.
    def default_font
      @fonts[@default_font]
    end

    # This method assigns a new header to a document. A Document object can
    # have up to four header - a default header, a header for left pages, a
    # header for right pages and a header for the first page. The method
    # checks the header type and stores it appropriately.
    #
    # ==== Parameters
    # header::  A reference to the header object to be stored. Existing header
    #           objects are overwritten.
    def header=(header)
      if header.type == HeaderNode::UNIVERSAL
        @headers[0] = header
      elsif header.type == HeaderNode::LEFT_PAGE
        @headers[1] = header
      elsif header.type == HeaderNode::RIGHT_PAGE
        @headers[2] = header
      elsif header.type == HeaderNode::FIRST_PAGE
        @headers[3] = header
      end
    end

    # This method assigns a new footer to a document. A Document object can
    # have up to four footers - a default footer, a footer for left pages, a
    # footer for right pages and a footer for the first page. The method
    # checks the footer type and stores it appropriately.
    #
    # ==== Parameters
    # footer::  A reference to the footer object to be stored. Existing footer
    #           objects are overwritten.
    def footer=(footer)
      if footer.type == FooterNode::UNIVERSAL
        @footers[0] = footer
      elsif footer.type == FooterNode::LEFT_PAGE
        @footers[1] = footer
      elsif footer.type == FooterNode::RIGHT_PAGE
        @footers[2] = footer
      elsif footer.type == FooterNode::FIRST_PAGE
        @footers[3] = footer
      end
    end

    # This method fetches a header from a Document object.
    #
    # ==== Parameters
    # type::  One of the header types defined in the header class. Defaults to
    #         HeaderNode::UNIVERSAL.
    def header(type=HeaderNode::UNIVERSAL)
      index = 0
      if type == HeaderNode::LEFT_PAGE
        index = 1
      elsif type == HeaderNode::RIGHT_PAGE
        index = 2
      elsif type == HeaderNode::FIRST_PAGE
        index = 3
      end
      @headers[index]
    end

    # This method fetches a footer from a Document object.
    #
    # ==== Parameters
    # type::  One of the footer types defined in the footer class. Defaults to
    #         FooterNode::UNIVERSAL.
    def footer(type=FooterNode::UNIVERSAL)
      index = 0
      if type == FooterNode::LEFT_PAGE
        index = 1
      elsif type == FooterNode::RIGHT_PAGE
        index = 2
      elsif type == FooterNode::FIRST_PAGE
        index = 3
      end
      @footers[index]
    end

    # Attribute mutator.
    #
    # ==== Parameters
    # font::  The new default font for the Document object.
    def default_font=(font)
      @fonts << font
      @default_font = @fonts.index(font)
    end

    # This method provides a short cut for obtaining the Paper object
    # associated with a Document object.
    def paper
      @style.paper
    end

    # This method overrides the parent=() method inherited from the
    # CommandNode class to disallow setting a parent on a Document object.
    #
    # ==== Parameters
    # parent::  A reference to the new parent node for the Document object.
    #
    # ==== Exceptions
    # RTFError::  Generated whenever this method is called.
    def parent=(parent)
      RTFError.fire("Document objects may not have a parent.")
    end

    # This method inserts a page break into a document.
    def page_break
      self.store(CommandNode.new(self, '\page', nil, false))
      nil
    end

    # This method fetches the width of the available work area space for a
    # typical Document object page.
    def body_width
      @style.body_width
    end

    # This method fetches the height of the available work area space for a
    # a typical Document object page.
    def body_height
      @style.body_height
    end

    # This method generates the RTF text for a Document object.
    def to_rtf
      text = StringIO.new

      text << "{#{prefix}\\#{@character_set.id2name}"
      text << "\\deff#{@default_font}"
      text << "\\deflang#{@language}" if !@language.nil?
      text << "\\plain\\fs24\\fet1"
      text << "\n#{@fonts.to_rtf}"
      text << "\n#{@colours.to_rtf}" if @colours.size > 0
      text << "\n#{@information.to_rtf}"
      text << "\n#{@lists.to_rtf}"
      if @headers.compact != []
        text << "\n#{@headers[3].to_rtf}" if !@headers[3].nil?
        text << "\n#{@headers[2].to_rtf}" if !@headers[2].nil?
        text << "\n#{@headers[1].to_rtf}" if !@headers[1].nil?
        if @headers[1].nil? or @headers[2].nil?
          text << "\n#{@headers[0].to_rtf}"
        end
      end
      if @footers.compact != []
        text << "\n#{@footers[3].to_rtf}" if !@footers[3].nil?
        text << "\n#{@footers[2].to_rtf}" if !@footers[2].nil?
        text << "\n#{@footers[1].to_rtf}" if !@footers[1].nil?
        if @footers[1].nil? or @footers[2].nil?
          text << "\n#{@footers[0].to_rtf}"
        end
      end
      text << "\n#{@style.prefix(self)}" if !@style.nil?
      self.each {|entry| text << "\n#{entry.to_rtf}"}
      text << "\n}"

      text.string
    end
  end
end