module RTF
  # This class represents a RTF command element within a document. This class
  # is concrete enough to be used on its own but will also be used as the
  # base class for some specific command node types.
  class CommandNode < ContainerNode
    # String containing the prefix text for the command
    attr_accessor :prefix
    # String containing the suffix text for the command
    attr_accessor :suffix
    # A boolean to indicate whether the prefix and suffix should
    # be written to separate lines whether the node is converted
    # to RTF. Defaults to true
    attr_accessor :split
    # A boolean to indicate whether the prefix and suffix should
    # be wrapped in curly braces. Defaults to true.
    attr_accessor :wrap

    # This is the constructor for the CommandNode class.
    #
    # ==== Parameters
    # parent::  A reference to the node that owns the new node.
    # prefix::  A String containing the prefix text for the command.
    # suffix::  A String containing the suffix text for the command. Defaults
    #           to nil.
    # split::   A boolean to indicate whether the prefix and suffix should
    #           be written to separate lines whether the node is converted
    #           to RTF. Defaults to true.
    # wrap::    A boolean to indicate whether the prefix and suffix should
    #           be wrapped in curly braces. Defaults to true.
    def initialize(parent, prefix, suffix=nil, split=true, wrap=true)
      super(parent)
      @prefix = prefix
      @suffix = suffix
      @split  = split
      @wrap   = wrap
    end

    # This method adds text to a command node. If the last child node of the
    # target node is a TextNode then the text is appended to that. Otherwise
    # a new TextNode is created and append to the node.
    #
    # ==== Parameters
    # text::  The String of text to be written to the node.
    def <<(text)
      if !last.nil? and last.respond_to?(:text=)
        last.append(text)
      else
        self.store(TextNode.new(self, text))
      end
    end

    # This method generates the RTF text for a CommandNode object.
    def to_rtf
      text = StringIO.new

      text << '{'       if wrap?
      text << @prefix   if @prefix

      self.each do |entry|
        text << "\n" if split?
        text << entry.to_rtf
      end

      text << "\n"    if split?
      text << @suffix if @suffix
      text << '}'     if wrap?

      text.string
    end

    # This method provides a short cut means of creating a paragraph command
    # node. The method accepts a block that will be passed a single parameter
    # which will be a reference to the paragraph node created. After the
    # block is complete the paragraph node is appended to the end of the child
    # nodes on the object that the method is called against.
    #
    # ==== Parameters
    # style::  A reference to a ParagraphStyle object that defines the style
    #          for the new paragraph. Defaults to nil to indicate that the
    #          currently applied paragraph styling should be used.
    def paragraph(style=nil)
      node = ParagraphNode.new(self, style)
      yield node if block_given?
      self.store(node)
    end

    # This method provides a short cut means of creating a new ordered or
    # unordered list. The method requires a block that will be passed a
    # single parameter that'll be a reference to the first level of the
    # list. See the +ListLevelNode+ doc for more information.
    #
    # Example usage:
    #
    #   rtf.list do |level1|
    #     level1.item do |li|
    #       li << 'some text'
    #       li.apply(some_style) {|x| x << 'some styled text'}
    #     end
    #
    #     level1.list(:decimal) do |level2|
    #       level2.item {|li| li << 'some other text in a decimal list'}
    #       level2.item {|li| li << 'and here we go'}
    #     end
    #   end
    #
    def list(kind=:bullets)
      node = ListNode.new(self)
      yield node.list(kind)
      self.store(node)
    end

    def link(url, text=nil)
      node = LinkNode.new(self, url)
      node << text if text
      yield node   if block_given?
      self.store(node)
    end

    # This method provides a short cut means of creating a line break command
    # node. This command node does not take a block and may possess no other
    # content.
    def line_break
      self.store(CommandNode.new(self, '\line', nil, false))
      nil
    end

    # This method inserts a footnote at the current position in a node.
    #
    # ==== Parameters
    # text::  A string containing the text for the footnote.
    def footnote(text)
      if !text.nil? and text != ''
        mark = CommandNode.new(self, '\fs16\up6\chftn', nil, false)
        note = CommandNode.new(self, '\footnote {\fs16\up6\chftn}', nil, false)
        note.paragraph << text
        self.store(mark)
        self.store(note)
      end
    end

    # This method inserts a new image at the current position in a node.
    #
    # ==== Parameters
    # source::  Either a string containing the path and name of a file or a
    #           File object for the image file to be inserted.
    #
    # ==== Exceptions
    # RTFError::  Generated whenever an invalid or inaccessible file is
    #             specified or the image file type is not supported.
    def image(source)
      self.store(ImageNode.new(self, source, root.get_id))
    end

    # This method provides a short cut means for applying multiple styles via
    # single command node. The method accepts a block that will be passed a
    # reference to the node created. Once the block is complete the new node
    # will be append as the last child of the CommandNode the method is called
    # on.
    #
    # ==== Parameters
    # style::  A reference to a CharacterStyle object that contains the style
    #          settings to be applied.
    #
    # ==== Exceptions
    # RTFError::  Generated whenever a non-character style is specified to
    #             the method.
    def apply(style)
      # Check the input style.
      if !style.is_character_style?
        RTFError.fire("Non-character style specified to the "\
                  "CommandNode#apply() method.")
      end

      # Store fonts and colours.
      root.colours << style.foreground unless style.foreground.nil?
      root.colours << style.background unless style.background.nil?
      root.fonts << style.font unless style.font.nil?

      # Generate the command node.
      node = CommandNode.new(self, style.prefix(root.fonts, root.colours))
      yield node if block_given?
      self.store(node)
    end

    # This method provides a short cut means of creating a bold command node.
    # The method accepts a block that will be passed a single parameter which
    # will be a reference to the bold node created. After the block is
    # complete the bold node is appended to the end of the child nodes on
    # the object that the method is call against.
    def bold
      style      = CharacterStyle.new
      style.bold = true
      if block_given?
        apply(style) {|node| yield node}
      else
        apply(style)
      end
    end

    # This method provides a short cut means of creating an italic command
    # node. The method accepts a block that will be passed a single parameter
    # which will be a reference to the italic node created. After the block is
    # complete the italic node is appended to the end of the child nodes on
    # the object that the method is call against.
    def italic
      style        = CharacterStyle.new
      style.italic = true
      if block_given?
        apply(style) {|node| yield node}
      else
        apply(style)
      end
    end

    # This method provides a short cut means of creating an underline command
    # node. The method accepts a block that will be passed a single parameter
    # which will be a reference to the underline node created. After the block
    # is complete the underline node is appended to the end of the child nodes
    # on the object that the method is call against.
    def underline
      style           = CharacterStyle.new
      style.underline = true
      if block_given?
        apply(style) {|node| yield node}
      else
        apply(style)
      end
    end

    # This method provides a short cut means of creating a subscript command
    # node. The method accepts a block that will be passed a single parameter
    # which will be a reference to the subscript node created. After the
    # block is complete the subscript node is appended to the end of the
    # child nodes on the object that the method is call against.
    def subscript
      style           = CharacterStyle.new
      style.subscript = true
      if block_given?
        apply(style) {|node| yield node}
      else
        apply(style)
      end
    end

    # This method provides a short cut means of creating a superscript command
    # node. The method accepts a block that will be passed a single parameter
    # which will be a reference to the superscript node created. After the
    # block is complete the superscript node is appended to the end of the
    # child nodes on the object that the method is call against.
    def superscript
      style             = CharacterStyle.new
      style.superscript = true
      if block_given?
        apply(style) {|node| yield node}
      else
        apply(style)
      end
    end

    # This method provides a short cut means of creating a strike command
    # node. The method accepts a block that will be passed a single parameter
    # which will be a reference to the strike node created. After the
    # block is complete the strike node is appended to the end of the
    # child nodes on the object that the method is call against.
    def strike
      style        = CharacterStyle.new
      style.strike = true
      if block_given?
        apply(style) {|node| yield node}
      else
        apply(style)
      end
    end

    # This method provides a short cut means of creating a font command node.
    # The method accepts a block that will be passed a single parameter which
    # will be a reference to the font node created. After the block is
    # complete the font node is appended to the end of the child nodes on the
    # object that the method is called against.
    #
    # ==== Parameters
    # font::  A reference to font object that represents the font to be used
    #         within the node.
    # size::  An integer size setting for the font. Defaults to nil to
    #         indicate that the current font size should be used.
    def font(font, size=nil)
      style           = CharacterStyle.new
      style.font      = font
      style.font_size = size
      root.fonts << font
      if block_given?
        apply(style) {|node| yield node}
      else
        apply(style)
      end
    end

    # This method provides a short cut means of creating a foreground colour
    # command node. The method accepts a block that will be passed a single
    # parameter which will be a reference to the foreground colour node
    # created. After the block is complete the foreground colour node is
    # appended to the end of the child nodes on the object that the method
    # is called against.
    #
    # ==== Parameters
    # colour::  The foreground colour to be applied by the command.
    def foreground(colour)
      style            = CharacterStyle.new
      style.foreground = colour
      root.colours << colour
      if block_given?
        apply(style) {|node| yield node}
      else
        apply(style)
      end
    end

    # This method provides a short cut means of creating a background colour
    # command node. The method accepts a block that will be passed a single
    # parameter which will be a reference to the background colour node
    # created. After the block is complete the background colour node is
    # appended to the end of the child nodes on the object that the method
    # is called against.
    #
    # ==== Parameters
    # colour::  The background colour to be applied by the command.
    def background(colour)
      style            = CharacterStyle.new
      style.background = colour
      root.colours << colour
      if block_given?
        apply(style) {|node| yield node}
      else
        apply(style)
      end
    end

    # This method provides a short cut menas of creating a colour node that
    # deals with foreground and background colours. The method accepts a
    # block that will be passed a single parameter which will be a reference
    # to the colour node created. After the block is complete the colour node
    # is append to the end of the child nodes on the object that the method
    # is called against.
    #
    # ==== Parameters
    # fore::  The foreground colour to be applied by the command.
    # back::  The background colour to be applied by the command.
    def colour(fore, back)
      style            = CharacterStyle.new
      style.foreground = fore
      style.background = back
      root.colours << fore
      root.colours << back
      if block_given?
        apply(style) {|node| yield node}
      else
        apply(style)
      end
    end

    # This method creates a new table node and returns it. The method accepts
    # a block that will be passed the table as a parameter. The node is added
    # to the node the method is called upon after the block is complete.
    #
    # ==== Parameters
    # rows::     The number of rows that the table contains.
    # columns::  The number of columns that the table contains.
    # *widths::  One or more integers representing the widths for the table
    #            columns.
    def table(rows, columns, *widths)
      node = TableNode.new(self, rows, columns, *widths)
      yield node if block_given?
      store(node)
      node
    end

    alias :write  :<<
    alias :color  :colour
    alias :split? :split
    alias :wrap?  :wrap
  end
end