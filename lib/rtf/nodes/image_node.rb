require 'stringio'

module RTF
  # This class represents an image within a RTF document. Currently only the
  # PNG, JPEG and Windows Bitmap formats are supported. Efforts are made to
  # identify the file type but these are not guaranteed to work.
  class ImageNode < Node
    # A definition for an image type constant.
    PNG = :pngblip

    # A definition for an image type constant.
    JPEG = :jpegblip

    # A definition for an image type constant.
    BITMAP = :dibitmap0

    # A definition for an architecture endian constant.
    LITTLE_ENDIAN = :little

    # A definition for an architecture endian constant.
    BIG_ENDIAN = :big

    # Offsets for reading dimension data by filetype
    DIMENSIONS_OFFSET = {
      JPEG   => 2,
      PNG    => 8,
      BITMAP => 8,
    }.freeze

    # Attribute accessor.
    attr_reader :x_scaling, :y_scaling, :top_crop, :right_crop, :bottom_crop,
            :left_crop, :width, :height, :displayed_width, :displayed_height

    # Attribute mutator.
    attr_writer :x_scaling, :y_scaling, :top_crop, :right_crop, :bottom_crop,
            :left_crop, :displayed_width, :displayed_height

    # This is the constructor for the ImageNode class.
    #
    # ==== Parameters
    # parent::  A reference to the node that owns the new image node.
    # source::  A reference to the image source. This must be a String or a
    #           File.
    # id::      The unique identifier for the image node.
    #
    # ==== Exceptions
    # RTFError::  Generated whenever the image specified is not recognised as
    #             a supported image type, something other than a String or
    #             File or IO is passed as the source parameter or if the
    #             specified source does not exist or cannot be accessed.
    def initialize(parent, source, id)
      super(parent)
      @source = nil
      @id     = id
      @type   = nil
      @x_scaling = @y_scaling = nil
      @top_crop = @right_crop = @bottom_crop = @left_crop = nil
      @width = @height = nil
      @displayed_width = @displayed_height = nil

      # store path to image
      @source = source if source.instance_of?(String) || source.instance_of?(Tempfile)
      @source = source.path if source.instance_of?(File)

      # Check the file's existence and accessibility.
      if !File.exist?(@source)
        RTFError.fire("Unable to find the #{File.basename(@source)} file.")
      end
      if !File.readable?(@source)
        RTFError.fire("Access to the #{File.basename(@source)} file denied.")
      end

      @type = get_file_type
      if @type == nil
        RTFError.fire("The #{File.basename(@source)} file contains an "\
                  "unknown or unsupported image type.")
      end

      @width, @height = get_dimensions
    end

    def open_file(&block)
      if block
       File.open(@source, 'rb', &block)
      else
       File.open(@source, 'rb')
      end
    end

    # This method attempts to determine the image type associated with a
    # file, returning nil if it fails to make the determination.
    def get_file_type
      type = nil
      read = []
      open_file do |file|

        # Check if the file is a JPEG.
        read_source(file, read, 2)
        if read[0,2] == [255, 216]
          type = JPEG
        else
          # Check if it's a PNG.
          read_source(file, read, 6)
          if read[0,8] == [137, 80, 78, 71, 13, 10, 26, 10]
            type = PNG
          else
            # Check if its a bitmap.
            if read[0,2] == [66, 77]
              size = to_integer(read[2,4])
              type = BITMAP if size == File.size(@source)
            end
          end
        end

      end

      type
    end

    # This method generates the RTF for an ImageNode object.
    def to_rtf
      text  = StringIO.new
      count = 0
  
      #text << '{\pard{\*\shppict{\pict'
      text << '{\*\shppict{\pict'
      text << "\\picscalex#{@x_scaling}" if @x_scaling != nil
      text << "\\picscaley#{@y_scaling}" if @y_scaling != nil
      text << "\\piccropl#{@left_crop}" if @left_crop != nil
      text << "\\piccropr#{@right_crop}" if @right_crop != nil
      text << "\\piccropt#{@top_crop}" if @top_crop != nil
      text << "\\piccropb#{@bottom_crop}" if @bottom_crop != nil
      text << "\\picwgoal#{@displayed_width}" if @displayed_width != nil
      text << "\\pichgoal#{@displayed_height}" if @displayed_height != nil        
      text << "\\picw#{@width}\\pich#{@height}\\bliptag#{@id}"
      text << "\\#{@type.id2name}\n"
  
      open_file do |file|
       file.each_byte do |byte|
        hex_str = byte.to_s(16)
        hex_str.insert(0,'0') if hex_str.length == 1
        text << hex_str    
        count += 1
        if count == 40
          text << "\n"
          count = 0
        end
       end
      end
      #text << "\n}}\\par}"
      text << "\n}}"

      text.string
    end

    # This method is used to determine the underlying endianness of a
    # platform.
    def get_endian
      [0, 125].pack('c2').unpack('s') == [125] ? BIG_ENDIAN : LITTLE_ENDIAN
    end

    # This method converts an array to an integer. The array must be either
    # two or four bytes in length.
    #
    # ==== Parameters
    # array::    A reference to the array containing the data to be converted.
    # signed::   A boolean to indicate whether the value is signed. Defaults
    #            to false.
    def to_integer(array, signed=false)
      from = nil
      to   = nil
      data = []

      if array.size == 2
        data.concat(get_endian == BIG_ENDIAN ? array.reverse : array)
        from = 'C2'
        to   = signed ? 's' : 'S'
      else
        data.concat(get_endian == BIG_ENDIAN ? array[0,4].reverse : array)
        from = 'C4'
        to   = signed ? 'l' : 'L'
      end
      data.pack(from).unpack(to)[0]
    end

    # This method loads the data for an image from its source. The method
    # accepts two call approaches. If called without a block then the method
    # considers the size parameter it is passed. If called with a block the
    # method executes until the block returns true.
    #
    # ==== Parameters
    # size::  The maximum number of bytes to be read from the file. Defaults
    #         to nil to indicate that the remainder of the file should be read
    #         in.
    def read_source(file, read, size=nil)
      if block_given?
        done = false

        while !done and !file.eof?
          read << file.getbyte
          done = yield read[-1]
        end
      else
        if size != nil
          if size > 0
            total = 0
            while !file.eof? and total < size
              read << file.getbyte
              total += 1
            end
          end
        else
          file.each_byte {|byte| read << byte}
        end
      end
    end

    # This method fetches details of the dimensions associated with an image.
    def get_dimensions
      dimensions = nil

      open_file do |file|
        file.pos = DIMENSIONS_OFFSET[@type]
        read = []

        # Check the image type.
        if @type == JPEG
          # Read until we can't anymore or we've found what we're looking for.
          done = false
          while !file.eof? and !done
            # Read to the next marker.
            read_source(file,read) {|c| c == 0xff} # Read to the marker.
            read_source(file,read) {|c| c != 0xff} # Skip any padding.

            if read[-1] >= 0xc0 && read[-1] <= 0xc3
              # Read in the width and height details.
              read_source(file, read, 7)
              dimensions = read[-4,4].pack('C4').unpack('nn').reverse
              done       = true
            else
              # Skip the marker block.
              read_source(file, read, 2)
              read_source(file, read, read[-2,2].pack('C2').unpack('n')[0] - 2)
            end
          end
        elsif @type == PNG
          # Read in the data to contain the width and height.
          read_source(file, read, 16)
          dimensions = read[-8,8].pack('C8').unpack('N2')
        elsif @type == BITMAP
          # Read in the data to contain the width and height.
          read_source(file, read, 18)
          dimensions = [to_integer(read[-8,4]), to_integer(read[-4,4])]
        end
      end

      dimensions
    end

    private :get_file_type, :to_integer, :get_endian, :get_dimensions, :open_file
  end
end