module RTF
  class ListLevel
    ValidLevels = (1..9)

    LevelTabs = [
      220,  720,  1133, 1700, 2267,
      2834, 3401, 3968, 4535, 5102,
      5669, 6236, 6803
    ].freeze

    ResetTabs = [560].concat(LevelTabs[2..-1]).freeze

    attr_reader :level, :marker

    def initialize(template, marker, level)
      unless marker.kind_of? ListMarker
        RTFError.fire("Invalid marker #{marker.inspect}")
      end

      unless ValidLevels.include? level
        RTFError.fire("Invalid list level: #{level}")
      end

      @template = template 
      @level    = level
      @marker   = marker
    end

    def type
      @marker.type
    end

    def reset_tabs
      ResetTabs
    end

    def tabs
      @tabs ||= begin
        tabs = LevelTabs.dup # Kernel#tap would be prettier here

        (@level - 1).times do
          # Reverse-engineered while looking at Textedit.app
          # generated output: they already made sure that it
          # would look good on every RTF editor :-p
          #
          a,  = tabs.shift(3)
          a,b = a + 720, a + 1220 
          tabs.shift while tabs.first < b
          tabs.unshift a, b
        end

        tabs
      end
    end

    def id
      @id ||= @template.id * 10 + level
    end

    def indent
      @indent ||= level * 720
    end

    def to_rtf(indent=0)
      prefix = indent > 0 ? ' ' * indent : ''

      text  = "#{prefix}{\\listlevel\\levelstartat1"
      
      # Marker type. The first declaration is for Backward Compatibility (BC).
      nfc  = @marker.number_type
      text << "\\levelnfc#{nfc}\\levelnfcn#{nfc}"

      # Justification, currently only left justified (0). First decl for BC.
      text << '\leveljc0\leveljcn0'

      # Character that follows the level text, currently only TAB.
      text << '\levelfollow0'

      # BC: Minimum distance from the left & right edges.
      text << '\levelindent0\levelspace360'

      # Marker name
      text << "{\\*\\levelmarker #{@marker.name}}"

      # Marker text format
      text << "{\\leveltext\\leveltemplateid#{id}#{@marker.template_format};}"
      text << '{\levelnumbers;}'

      # The actual spacing
      text << "\\fi-360\\li#{self.indent}\\lin#{self.indent}}\n"
    end
  end
end