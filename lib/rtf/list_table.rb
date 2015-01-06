module RTF
  class ListTable
    def initialize
      @templates = []
    end

    def new_template
      @templates.push ListTemplate.new(next_template_id)
      @templates.last
    end

    def to_rtf(indent=0)
      return '' if @templates.empty?

      prefix = indent > 0 ? ' ' * indent : ''

      # List table
      text = "#{prefix}{\\*\\listtable"
      @templates.each {|tpl| text << tpl.to_rtf}
      text << "}"

      # List override table, a Cargo Cult.
      text << "#{prefix}{\\*\\listoverridetable"
      @templates.each do |tpl|
        text << "{\\listoverride\\listid#{tpl.id}\\listoverridecount0\\ls#{tpl.id}}"
      end
      text << "}\n"
    end

    protected
    
    def next_template_id
      @templates.size + 1
    end
  end
end
