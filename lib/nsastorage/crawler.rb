# frozen_string_literal: true

module NSAStorage
  # Used to fetch and parse either HTML or XML via a URL.
  class Crawler
    HOST = 'https://www.nsastorage.com'

    # @attribute url [String]
    # @raise [FetchError]
    # @return [Hash]
    def self.json(url:)
      new.json(url:)
    end

    # @param url [String]
    # @raise [FetchError]
    # @return [Nokogiri::HTML::Document]
    def self.html(url:)
      new.html(url:)
    end

    # @param url [String]
    # @raise [FetchError]
    # @return [Nokogiri::XML::Document]
    def self.xml(url:)
      new.xml(url:)
    end

    # @return [HTTP::Client]
    def connection
      @connection ||= begin
        config = NSAStorage.config

        connection = HTTP.use(:auto_deflate).use(:auto_inflate).persistent(HOST)
        connection = connection.headers(config.headers) if config.headers?
        connection = connection.timeout(config.timeout) if config.timeout?
        connection = connection.via(*config.via) if config.proxy?

        connection
      end
    end

    # @param url [String]
    # @return [HTTP::Response]
    def fetch(url:)
      response = connection.get(url)
      raise FetchError.new(url:, response: response.flush) unless response.status.ok?

      response
    end

    # @param url [String]
    # @raise [FetchError]
    # @return [Hash]
    def json(url:)
      JSON.parse(String(fetch(url:).body))
    end

    # @param url [String]
    # @raise [FetchError]
    # @return [Nokogiri::XML::Document]
    def html(url:)
      Nokogiri::HTML(String(fetch(url:).body))
    end

    # @param url [String]
    # @raise [FetchError]
    # @return [Nokogiri::XML::Document]
    def xml(url:)
      Nokogiri::XML(String(fetch(url:).body))
    end
  end
end
