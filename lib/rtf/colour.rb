#!/usr/bin/env ruby

require 'stringio'

module RTF
  # This class represents a colour within a RTF document.
  class Colour
    # Attribute accessor.
    attr_reader :red, :green, :blue


    # This is the constructor for the Colour class.
    #
    # ==== Parameters
    # red::    The intensity setting for red in the colour. Must be an
    #          integer between 0 and 255.
    # green::  The intensity setting for green in the colour. Must be an
    #          integer between 0 and 255.
    # blue::   The intensity setting for blue in the colour. Must be an
    #          integer between 0 and 255.
    #
    # ==== Exceptions
    # RTFError::  Generated whenever an invalid intensity setting is
    #             specified for the red, green or blue values.
    def initialize(red, green, blue)
      if !red.kind_of?(Integer) || red < 0 || red > 255
        RTFError.fire("Invalid red intensity setting ('#{red}') specified "\
                  "for a Colour object.")
      end
      if !green.kind_of?(Integer) || green < 0 || green > 255
        RTFError.fire("Invalid green intensity setting ('#{green}') "\
                  "specified for a Colour object.")
      end
      if !blue.kind_of?(Integer) || blue < 0 || blue > 255
        RTFError.fire("Invalid blue intensity setting ('#{blue}') "\
                  "specified for a Colour object.")
      end

      @red   = red
      @green = green
      @blue  = blue
    end

    # This method overloads the comparison operator for the Colour class.
    #
    # ==== Parameters
    # object::  A reference to the object to be compared with.
    def ==(object)
      object.instance_of?(Colour) and
      object.red   == @red and
      object.green == @green and
      object.blue  == @blue
    end

    # This method returns a textual description for a Colour object.
    #
    # ==== Parameters
    # indent::  The number of spaces to prefix to the lines created by the
    #           method. Defaults to zero.
    def to_s(indent=0)
      prefix = indent > 0 ? ' ' * indent : ''
      "#{prefix}Colour (#{@red}/#{@green}/#{@blue})"
    end

    # This method generates the RTF text for a Colour object.
    #
    # ==== Parameters
    # indent::  The number of spaces to prefix to the lines created by the
    #           method. Defaults to zero.
    def to_rtf(indent=0)
      prefix = indent > 0 ? ' ' * indent : ''
      "#{prefix}\\red#{@red}\\green#{@green}\\blue#{@blue};"
    end
  end
end
