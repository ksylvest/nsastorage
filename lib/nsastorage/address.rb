# frozen_string_literal: true

module NSAStorage
  # The address (street + city + state + zip) of a facility.
  class Address
    ADDRESS_SELECTOR = '.item-des-box .text-box i'
    ADDRESS_REGEX = /(?<street>.+),\s+(?<city>.+),\s+(?<state>.+)\s+(?<zip>\d{5})/
    # @attribute [rw] street
    #   @return [String]
    attr_accessor :street

    # @attribute [rw] city
    #   @return [String]
    attr_accessor :city

    # @attribute [rw] state
    #   @return [String]
    attr_accessor :state

    # @attribute [rw] zip
    #   @return [String]
    attr_accessor :zip

    # @param street [String]
    # @param city [String]
    # @param state [String]
    # @param zip [String]
    def initialize(street:, city:, state:, zip:)
      @street = street
      @city = city
      @state = state
      @zip = zip
    end

    # @return [String]
    def inspect
      props = [
        "street=#{@street.inspect}",
        "city=#{@city.inspect}",
        "state=#{@state.inspect}",
        "zip=#{@zip.inspect}"
      ]
      "#<#{self.class.name} #{props.join(' ')}>"
    end

    # @return [String]
    def text
      "#{street}, #{city}, #{state} #{zip}"
    end

    # @param document [Nokogiri::HTML::Document]
    #
    # @return [Address]
    def self.parse(document:)
      element = document.at_css(ADDRESS_SELECTOR)
      match = element.text.match(ADDRESS_REGEX)
      new(
        street: match[:street],
        city: match[:city],
        state: match[:state],
        zip: match[:zip]
      )
    end
  end
end
