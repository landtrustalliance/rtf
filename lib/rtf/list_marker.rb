module RTF
  class ListMarker
    def initialize(name, codepoint=nil)
      @name      = name
      @codepoint = codepoint
    end

    def bullet?
      !@codepoint.nil?
    end

    def type
      bullet? ? :bullet : :decimal
    end

    def number_type
      # 23: bullet, 0: arabic
      # applies to the \levelnfcN macro
      #
      bullet? ? 23 : 0
    end

    def name
      name  = "\\{#@name\\}"
      name << '.' unless bullet?
      name
    end

    def template_format
      # The first char is the string size, the next ones are
      # either placeholders (\'0X) or actual characters to
      # include in the format. In the bullet case, \uc0 is
      # used to get rid of the multibyte translation: we want
      # an Unicode character.
      #
      # In the decimal case, we have a fixed format, with a
      # dot following the actual number.
      #
      if bullet?
        "\\'01\\uc0\\u#@codepoint"
      else
        "\\'02\\'00. "
      end
    end

    def text_format(n=nil)
      text = 
        if bullet?
          "\\uc0\\u#@codepoint"
        else
          "#{n}."
        end

      "\t#{text}\t"
    end
  end
end