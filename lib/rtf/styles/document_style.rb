require 'stringio'

module RTF
  # This class represents styling attributes that are to be applied at the
  # document level.
  class DocumentStyle < Style
    # Definition for a document orientation setting.
    PORTRAIT                                   = :portrait

    # Definition for a document orientation setting.
    LANDSCAPE                                  = :landscape

    # Definition for a default margin setting.
    DEFAULT_LEFT_MARGIN                        = 1800

    # Definition for a default margin setting.
    DEFAULT_RIGHT_MARGIN                       = 1800

    # Definition for a default margin setting.
    DEFAULT_TOP_MARGIN                         = 1440

    # Definition for a default margin setting.
    DEFAULT_BOTTOM_MARGIN                      = 1440

    # Attribute accessor.
    attr_reader :paper, :left_margin, :right_margin, :top_margin,
            :bottom_margin, :gutter, :orientation

    # Attribute mutator.
    attr_writer :paper, :left_margin, :right_margin, :top_margin,
            :bottom_margin, :gutter, :orientation

    # This is a constructor for the DocumentStyle class. This creates a
    # document style with a default paper setting of A4 and portrait
    # orientation (all other attributes are nil).
    def initialize
      @paper         = Paper::A4
      @left_margin   = DEFAULT_LEFT_MARGIN
      @right_margin  = DEFAULT_RIGHT_MARGIN
      @top_margin    = DEFAULT_TOP_MARGIN
      @bottom_margin = DEFAULT_BOTTOM_MARGIN
      @gutter        = nil
      @orientation   = PORTRAIT
    end

    # This method overrides the is_document_style? method inherited from the
    # Style class to always return true.
    def is_document_style?
      true
    end

    # This method generates a string containing the prefix associated with a
    # style object.
    #
    # ==== Parameters
    # document::  A reference to the document using the style.
    def prefix(fonts=nil, colours=nil)
      text = StringIO.new

      if orientation == LANDSCAPE
        text << "\\paperw#{@paper.height}"  unless @paper.nil?
        text << "\\paperh#{@paper.width}"   unless @paper.nil?
      else
        text << "\\paperw#{@paper.width}"   unless @paper.nil?
        text << "\\paperh#{@paper.height}"  unless @paper.nil?
      end
      text << "\\margl#{@left_margin}"       unless @left_margin.nil?
      text << "\\margr#{@right_margin}"      unless @right_margin.nil?
      text << "\\margt#{@top_margin}"        unless @top_margin.nil?
      text << "\\margb#{@bottom_margin}"     unless @bottom_margin.nil?
      text << "\\gutter#{@gutter}"           unless @gutter.nil?
      text << '\sectd\lndscpsxn' if @orientation == LANDSCAPE

      text.string
    end

    # This method fetches the width of the available work area space for a
    # DocumentStyle object.
    def body_width
      if orientation == PORTRAIT
        @paper.width - (@left_margin + @right_margin)
      else
        @paper.height - (@left_margin + @right_margin)
      end
    end

    # This method fetches the height of the available work area space for a
    # DocumentStyle object.
    def body_height
      if orientation == PORTRAIT
        @paper.height - (@top_margin + @bottom_margin)
      else
        @paper.width - (@top_margin + @bottom_margin)
      end
    end
  end
end