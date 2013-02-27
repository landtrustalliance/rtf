require 'nokogiri'
require 'tidy'
require 'pry'

module RTF::Converters
  class HTML

    def initialize(html, options = {})
      html  = options[:noclean] ? html : clean(html, options[:tidy_options] || {})
      @html = Nokogiri::HTML::Document.parse(html)
    end

    def to_rtf(options = {})
      to_rtf_document(options).to_rtf
    end

    def to_rtf_document(options = {})
      font  = Helpers.font(options[:font] || :default)
      nodes = NodeSet.new @html.css('body').children

      RTF::Document.new(font).tap do |rtf|
        nodes.to_rtf(rtf)
      end
    end

    protected
      def clean(html, options = {})
        defaults = {
          :doctype          => 'omit',
          :bare             => true,
          :clean            => true,
          :drop_empty_paras => true,
          :logical_emphasis => true,
          :lower_literals   => true,
          :merge_spans      => 1,
          :merge_divs       => 1,
          :output_html      => true,
          :indent           => 0,
          :wrap             => 0,
          :char_encoding    => 'utf8'
        }

        tidy = Tidy.new defaults.merge(options)
        tidy.clean(html)
      end

    module Helpers
      extend self

      def font(key)
        RTF::Font.new(*case key
          when :default   then [RTF::Font::ROMAN,  'Times New Roman']
          when :monospace then [RTF::Font::MODERN, 'Courier New'    ]
        end)
      end

      def style(key)
        RTF::CharacterStyle.new.tap do |style|
          case key.to_sym
          when :h1
            style.font_size = 44
            style.bold = true
          when :h2
            style.font_size = 36
            style.bold = true
          when :h3
            style.font_size = 28
            style.bold = true
          when :h4
            style.font_size = 22
            style.bold = true
          end
        end
      end
    end

    class NodeSet
      def initialize(nodeset)
        @nodeset = nodeset
      end

      def to_rtf(rtf)
        @nodeset.each do |node|
          Node.new(node).to_rtf(rtf)
        end
      end
    end

    class Node # :nodoc:
      def initialize(node)
        @node = node
      end

      def to_rtf(rtf)
        return if @node.name != 'td' && rtf.class == RTF::TableRowNode
        case @node.name
        when 'text'                   then rtf << @node.text.gsub(/\n+/, ' ').strip
        when 'br'                     then rtf.line_break
        when 'b', 'strong'            then rtf.bold                &recurse
        when 'i', 'em', 'cite'        then rtf.italic              &recurse
        when 'u'                      then rtf.underline           &recurse
        when 'blockquote', 'p', 'div' then rtf.paragraph           &recurse
        when 'span'                   then recurse.call(rtf)
        when 'sup'                    then rtf.subscript           &recurse
        when 'sub'                    then rtf.superscript         &recurse
        when 'ul'                     then rtf.list :bullets,      &recurse
        when 'ol'                     then rtf.list :decimal,      &recurse
        when 'li'                     then rtf.item &recurse
        when 'a'                      then rtf.link @node[:href],  &recurse
        when 'h1', 'h2', 'h3', 'h4'   then rtf.apply(Helpers.style(@node.name), &recurse); rtf.line_break
        when 'code'                   then rtf.font Helpers.font(:monospace), &recurse
        when 'table'                  then generate_table(rtf, @node)
        when 'thead', 'tbody'         then recurse.call(rtf)
        when 'tr'                     then rtf.tr &recurse
        when 'td','th'                then rtf.td &recurse
        when 'img'                    then rtf.image @node.attributes.fetch("src").value, &recurse
        else
          #puts "Ignoring #{@node.to_html}"
        end

        return rtf
      end

      def generate_table(rtf, node)
        rtf.table count_rows(node), count_cells(node), &recurse
      end

      def count_rows(node)
        return 0 if node.children.nil?
        if node.children.map(&:name) == ['thead', 'tbody']
          return node.children.map { |el| el.children.count }.inject(:+)
        else
          return node.children.count if node.children.first.name == 'tr'
        end
        count_rows(node.children.first)
      end

      def count_cells(node)
        return 0 if node.children.nil?
        if node.children.first.name.match(/^td$|^th$/)
          node.children.select { |elem| elem.name.match(/^td$|^th$/) }.count
        else
          count_cells(node.children.first)
        end
      end

      def recurse
        lambda {|rtf| NodeSet.new(@node.children).to_rtf(rtf)}
      end
    end

  end
end
