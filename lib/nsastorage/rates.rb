# frozen_string_literal: true

module NSAStorage
  # The rates (street + web) for a facility
  class Rates
    STREET_SELECTOR = '.part_item_old_price'
    WEB_SELECTOR = '.part_item_price'
    VALUE_REGEX = /(?<value>[\d\.]+)/

    # @attribute [rw] street
    #   @return [Integer]
    attr_accessor :street

    # @attribute [rw] web
    #   @return [Integer]
    attr_accessor :web

    # @param element [Nokogiri::XML::Element]
    #
    # @return [Rates]
    def self.parse(element:)
      street = parse_value(element: element.at_css(STREET_SELECTOR))
      web = parse_value(element: element.at_css(WEB_SELECTOR))

      new(street: street || web, web: web || street)
    end

    # @param element [Nokogiri::XML::Element]
    #
    # @return [Float, nil]
    def self.parse_value(element:)
      return if element.nil?

      match = VALUE_REGEX.match(element.text)
      Float(match[:value]) if match
    end

    # @param street [Integer]
    # @param web [Integer]
    def initialize(street:, web:)
      @street = street
      @web = web
    end

    # @return [String]
    def inspect
      props = [
        "street=#{@street.inspect}",
        "web=#{@web.inspect}"
      ]
      "#<#{self.class.name} #{props.join(' ')}>"
    end

    # @return [String] e.g. "$80 (street) | $60 (web)"
    def text
      "$#{@street} (street) | $#{@web} (web)"
    end
  end
end
