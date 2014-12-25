module RTF
  # This class represents a Node that can contain other Node objects. Its a
  # base class for more specific Node types.
  class ContainerNode < Node
    include Enumerable
    extend Forwardable

    # Children elements of the node
    attr_accessor :children
    def_delegators :@children, :first, :last, :each, :size, :[]

    # This is the constructor for the ContainerNode class.
    #
    # ==== Parameters
    # parent::     A reference to the parent node that owners the new
    #              ContainerNode object.
    def initialize(parent)
      super(parent)
      @children = []
      @children.concat(yield) if block_given?
    end

    # This method adds a new node element to the end of the list of nodes
    # maintained by a ContainerNode object. Nil objects are ignored.
    #
    # ==== Parameters
    # node::  A reference to the Node object to be added.
    def store(node)
      return if node.nil?
      
      @children.push(node).uniq
      node.parent = self
      node
    end

    # This method generates the RTF text for a ContainerNode object.
    def to_rtf
      RTFError.fire("#{self.class.name}.to_rtf method not yet implemented.")
    end
  end
end