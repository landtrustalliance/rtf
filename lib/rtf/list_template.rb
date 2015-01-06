module RTF
  class ListTemplate
    attr_reader :id

    Markers = {
      :disc    => ListMarker.new('disc',    0x2022),
      :hyphen  => ListMarker.new('hyphen',  0x2043),
      :decimal => ListMarker.new('decimal'        )
    }

    def initialize(id)
      @levels = []
      @id     = id
    end

    def level_for(level, kind = :bullets)
      @levels[level-1] ||= begin
        # Only disc for now: we'll add support
        # for more customization options later
        marker = Markers[kind == :bullets ? :disc : :decimal]
        ListLevel.new(self, marker, level)
      end
    end

    def to_rtf(indent=0)
      prefix = indent > 0 ? ' ' * indent : ''

      text = "#{prefix}{\\list\\listtemplate#{id}\\listhybrid"
      @levels.each {|lvl| text << lvl.to_rtf}
      text << "{\\listname;}\\listid#{id}}\n"

      text
    end
  end
end