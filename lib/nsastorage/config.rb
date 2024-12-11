# frozen_string_literal: true

module NSAStorage
  # The core configuration.
  class Config
    # @attribute [rw] accept_language
    #   @return [String]
    attr_accessor :accept_language

    # @attribute [rw] user_agent
    #   @return [String]
    attr_accessor :user_agent

    # @attribute [rw] timeout
    #   @return [Integer]
    attr_accessor :timeout

    # @attribute [rw] proxy_url
    #   @return [String]
    attr_accessor :proxy_url

    def initialize
      @accept_language = ENV.fetch('NSASTORAGE_ACCEPT_LANGUAGE', 'en-US,en;q=0.9')
      @user_agent = ENV.fetch('NSASTORAGE_USER_AGENT', "nsastorage.rb/#{VERSION}")
      @timeout = Integer(ENV.fetch('NSASTORAGE_TIMEOUT', 60))
      @proxy_url = ENV.fetch('NSASTORAGE_PROXY_URL', nil)
    end

    # @return [Boolean]
    def headers?
      !@user_agent.nil?
    end

    # @return [Boolean]
    def timeout?
      !@timeout.zero?
    end

    # @return [Boolean]
    def proxy?
      !@proxy_url.nil?
    end

    # @return [Hash<String, String>] e.g { 'User-Agent' => 'nsastorage.rb/1.0.0' }
    def headers
      {
        'Accept-Language' => @accept_language,
        'User-Agent' => @user_agent
      }
    end

    # @return [Array] e.g. ['proxy.example.com', 8080, 'user', 'pass']
    def via
      proxy_uri = URI.parse(@proxy_url)
      [proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password]
    end
  end
end
