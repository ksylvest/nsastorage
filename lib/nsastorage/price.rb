# frozen_string_literal: true

module NSAStorage
  # The price (id + dimensions + rate) for a facility.
  class Price
    ID_REGEX = %r{(?<id>\d+)/(?:rent|reserve)/}
    PRICE_SELECTOR = '[data-unit-size="small"],[data-unit-size="medium"],[data-unit-size="large"]'

    # @attribute [rw] id
    #   @return [String]
    attr_accessor :id

    # @attribute [rw] dimensions
    #   @return [Dimensions]
    attr_accessor :dimensions

    # @attribute [rw] features
    #   @return [Features]
    attr_accessor :features

    # @attribute [rw] rates
    #   @return [Rates]
    attr_accessor :rates

    # @param facility_id [Integer]
    #
    # @return [Array<Price>]
    def self.fetch(facility_id:)
      url = "https://www.nsastorage.com/facility-units/#{facility_id}"
      html = Crawler.json(url:)['data']['html']['units']
      Nokogiri::HTML(html).css(PRICE_SELECTOR).map { |element| parse(element:) }
    end

    # @param id [String]
    # @param dimensions [Dimensions]
    # @param features [Features]
    # @param rates [Rates]
    def initialize(id:, dimensions:, features:, rates:)
      @id = id
      @dimensions = dimensions
      @features = features
      @rates = rates
    end

    # @return [String]
    def inspect
      props = [
        "id=#{@id.inspect}",
        "dimensions=#{@dimensions.inspect}",
        "features=#{@features.inspect}",
        "rates=#{@rates.inspect}"
      ]
      "#<#{self.class.name} #{props.join(' ')}>"
    end

    # @return [String] e.g. "123 | 5' × 5' (25 sqft) | $100 (street) / $90 (web)"
    def text
      "#{@id} | #{@dimensions.text} | #{@rates.text} | #{@features.text}"
    end

    # @param element [Nokogiri::XML::Element]
    #
    # @return [Price]
    def self.parse(element:)
      link = element.at_xpath("//a[contains(text(), 'Rent')]|//a[contains(text(), 'Reserve')]")
      new(
        id: ID_REGEX.match(link['href'])[:id],
        dimensions: Dimensions.parse(element:),
        features: Features.parse(element:),
        rates: Rates.parse(element:)
      )
    end
  end
end
