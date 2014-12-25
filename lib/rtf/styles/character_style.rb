require 'stringio'

module RTF
  # This class represents a character style for an RTF document.
  class CharacterStyle < Style
    # Attribute accessor.
    attr_reader :bold, :italic, :underline, :superscript, :capitalise,
                :strike, :subscript, :hidden, :foreground, :background,
                :flow, :font, :font_size

    # Attribute mutator.
    attr_writer :bold, :italic, :underline, :superscript, :capitalise,
                :strike, :subscript, :hidden, :foreground, :background,
                :flow, :font, :font_size

    # This is the constructor for the CharacterStyle class.
    #
    # ==== Exceptions
    # RTFError::  Generate if the parent style specified is not an instance
    #             of the CharacterStyle class.
    def initialize
      @bold        = false
      @italic      = false
      @underline   = false
      @superscript = false
      @capitalise  = false
      @strike      = false
      @subscript   = false
      @hidden      = false
      @foreground  = nil
      @background  = nil
      @font        = nil
      @font_size   = nil
      @flow        = LEFT_TO_RIGHT
    end

    # This method overrides the is_character_style? method inherited from the
    # Style class to always return true.
    def is_character_style?
      true
    end

    # This method generates a string containing the prefix associated with a
    # style object.
    #
    # ==== Parameters
    # fonts::    A reference to a FontTable containing any fonts used by the
    #            style (may be nil if no fonts used).
    # colours::  A reference to a ColourTable containing any colours used by
    #            the style (may be nil if no colours used).
    def prefix(fonts, colours)
      text = StringIO.new

      text << '\b' if @bold
      text << '\i' if @italic
      text << '\ul' if @underline
      text << '\super' if @superscript
      text << '\caps' if @capitalise
      text << '\strike' if @strike
      text << '\sub' if @subscript
      text << '\v' if @hidden
      text << "\\cf#{colours.index(@foreground)}" if @foreground != nil
      text << "\\cb#{colours.index(@background)}" if @background != nil
      text << "\\f#{fonts.index(@font)}" if @font != nil
      text << "\\fs#{@font_size.to_i}" if @font_size != nil
      text << '\rtlch' if @flow == RIGHT_TO_LEFT

      text.string.length > 0 ? text.string : nil
    end

    alias :capitalize :capitalise
    alias :capitalize= :capitalise=
  end
end