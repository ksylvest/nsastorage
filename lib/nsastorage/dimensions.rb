# frozen_string_literal: true

module NSAStorage
  # The dimensions (width + depth + sqft) of a price.
  class Dimensions
    DEFAULT_WIDTH = 5.0 # feet
    DEFAULT_DEPTH = 5.0 # feet
    DEFAULT_HEIGHT = 8.0 # feet

    DIMENSIONS_REGEX = /(?<width>[\d\.]+) x (?<depth>[\d\.]+)/

    # @attribute [rw] depth
    #   @return [Float]
    attr_accessor :depth

    # @attribute [rw] width
    #  @return [Float]
    attr_accessor :width

    # @attribute [rw] height
    #   @return [Float]
    attr_accessor :height

    # @param depth [Float]
    # @param width [Float]
    # @param height [Float]
    def initialize(depth:, width:, height: DEFAULT_HEIGHT)
      @depth = depth
      @width = width
      @height = height
    end

    # @return [String]
    def inspect
      props = [
        "depth=#{@depth.inspect}",
        "width=#{@width.inspect}",
        "height=#{@height.inspect}"
      ]
      "#<#{self.class.name} #{props.join(' ')}>"
    end

    # @return [String] e.g. "5×5"
    def id
      "#{format('%g', @width)}×#{format('%g', @depth)}"
    end

    # @return [Integer]
    def sqft
      Integer(@width * @depth)
    end

    # @return [Integer]
    def cuft
      Integer(@width * @depth * @height)
    end

    # @return [String] e.g. "10' × 10' (100 sqft)"
    def text
      "#{format('%g', @width)}' × #{format('%g', @depth)}' (#{sqft} sqft)"
    end

    # @param element [Nokogiri::XML::Element]
    #
    # @return [Dimensions]
    def self.parse(element:)
      text = element.at_css('.unit-select-item-detail').text
      match = DIMENSIONS_REGEX.match(text)

      width = match ? Float(match[:width]) : DEFAULT_WIDTH
      depth = match ? Float(match[:depth]) : DEFAULT_DEPTH
      new(depth:, width:, height: DEFAULT_HEIGHT)
    end
  end
end
