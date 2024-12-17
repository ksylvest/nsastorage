# frozen_string_literal: true

module NSAStorage
  # A facility (address + geocode + prices) on nsastorage.com.
  #
  # e.g. https://www.nsastorage.com/storage/california/storage-units-paramount/7752-Jackson-St-876
  class Facility
    class ParseError < StandardError; end

    DEFAULT_EMAIL = 'customerservice@nsabrands.com'
    DEFAULT_PHONE = '+1-844-434-1150'

    SITEMAP_URL = 'https://www.nsastorage.com/sitemap.xml'

    # @attribute [rw] id
    #   @return [String]
    attr_accessor :id

    # @attribute [rw] url
    #   @return [String]
    attr_accessor :url

    # @attribute [rw] name
    #   @return [String]
    attr_accessor :name

    # @attribute [rw] phone
    #   @return [String]
    attr_accessor :phone

    # @attribute [rw] email
    #   @return [String]
    attr_accessor :email

    # @attribute [rw] address
    #   @return [Address]
    attr_accessor :address

    # @attribute [rw] geocode
    #   @return [Geocode, nil]
    attr_accessor :geocode

    # @attribute [rw] prices
    #   @return [Array<Price>]
    attr_accessor :prices

    # @return [Sitemap]
    def self.sitemap
      Sitemap.fetch(url: SITEMAP_URL)
    end

    # @param url [String]
    #
    # @return [Facility]
    def self.fetch(url:)
      document = Crawler.html(url:)
      parse(url:, document:)
    end

    # @param url [String]
    # @param document [Nokogiri::HTML::Document]
    #
    # @return [Facility]
    def self.parse(url:, document:)
      id = Integer(document.at_css('[data-facility-id]')['data-facility-id'])
      name = document.at_css('.section-title').text.strip

      geocode = Geocode.parse(document:)
      address = Address.parse(document:)
      prices = Price.fetch(facility_id: id)

      new(id:, url:, name:, address:, geocode:, prices:)
    end

    # @param document [Nokogiri::HTML::Document]
    #
    # @raise [ParseError]
    #
    # @return [Hash]
    def self.parse_ld_json_script(document:)
      parse_ld_json_scripts(document:).find do |data|
        data['@type'] == 'SelfStorage'
      end || raise(ParseError, 'missing ld+json')
    end

    # @param document [Nokogiri::HTML::Document]
    #
    # @return [Array<Hash>]
    def self.parse_ld_json_scripts(document:)
      elements = document.xpath('//script[@type="application/ld+json"]')

      elements.map { |element| element.text.empty? ? {} : JSON.parse(element.text) }
    end

    # @param id [String]
    # @param url [String]
    # @param name [String]
    # @param address [Address]
    # @param geocode [Geocode]
    # @param phone [String]
    # @param email [String]
    # @param prices [Array<Price>]
    def initialize(id:, url:, name:, address:, geocode:, phone: DEFAULT_PHONE, email: DEFAULT_EMAIL, prices: [])
      @id = id
      @url = url
      @name = name
      @address = address
      @geocode = geocode
      @phone = phone
      @email = email
      @prices = prices
    end

    # @return [String]
    def inspect
      props = [
        "id=#{@id.inspect}",
        "url=#{@url.inspect}",
        "address=#{@address.inspect}",
        "geocode=#{@geocode.inspect}",
        "phone=#{@phone.inspect}",
        "email=#{@email.inspect}",
        "prices=#{@prices.inspect}"
      ]
      "#<#{self.class.name} #{props.join(' ')}>"
    end

    # @return [String]
    def text
      "#{@id} | #{@name} | #{@phone} | #{@email} | #{@address.text} | #{@geocode ? @geocode.text : 'N/A'}"
    end
  end
end
