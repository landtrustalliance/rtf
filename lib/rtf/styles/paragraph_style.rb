require 'stringio'

module RTF
  # This class represents a styling for a paragraph within an RTF document.
  class ParagraphStyle < Style
    # A definition for a paragraph justification setting.
    LEFT_JUSTIFY = :ql

    # A definition for a paragraph justification setting.
    RIGHT_JUSTIFY = :qr

    # A definition for a paragraph justification setting.
    CENTER_JUSTIFY = :qc

    # A definition for a paragraph justification setting.
    CENTRE_JUSTIFY = :qc

    # A definition for a paragraph justification setting.
    FULL_JUSTIFY = :qj

    # Attribute accessor.
    attr_reader :justification, :left_indent, :right_indent,
                :first_line_indent, :space_before, :space_after,
                :line_spacing, :flow

    # Attribute mutator.
    attr_writer :justification, :left_indent, :right_indent,
                :first_line_indent, :space_before, :space_after,
                :line_spacing, :flow

    # This is a constructor for the ParagraphStyle class.
    #
    # ==== Parameters
    # base::  A reference to base object that the new style will inherit its
    #         initial properties from. Defaults to nil.
    def initialize(base=nil)
      @justification     = base.nil? ? LEFT_JUSTIFY : base.justification
      @left_indent       = base.nil? ? nil : base.left_indent
      @right_indent      = base.nil? ? nil : base.right_indent
      @first_line_indent = base.nil? ? nil : base.first_line_indent
      @space_before      = base.nil? ? nil : base.space_before
      @space_after       = base.nil? ? nil : base.space_after
      @line_spacing      = base.nil? ? nil : base.line_spacing
      @flow              = base.nil? ? LEFT_TO_RIGHT : base.flow
    end

    # This method overrides the is_paragraph_style? method inherited from the
    # Style class to always return true.
    def is_paragraph_style?
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

      text << "\\#{@justification.id2name}"
      text << "\\li#{@left_indent}"        unless @left_indent.nil?
      text << "\\ri#{@right_indent}"       unless @right_indent.nil?
      text << "\\fi#{@first_line_indent}"  unless @first_line_indent.nil?
      text << "\\sb#{@space_before}"       unless @space_before.nil?
      text << "\\sa#{@space_after}"        unless @space_after.nil?
      text << "\\sl#{@line_spacing}"       unless @line_spacing.nil?
      text << '\rtlpar' if @flow == RIGHT_TO_LEFT

      text.string.length > 0 ? text.string : nil
    end
  end
end