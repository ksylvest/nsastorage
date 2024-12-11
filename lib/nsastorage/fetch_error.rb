# frozen_string_literal: true

module NSAStorage
  # Raised for unexpected HTTP responses.
  class FetchError < Error
    # @param url [String]
    # @param response [HTTP::Response]
    def initialize(url:, response:)
      super("url=#{url} status=#{response.status.inspect} body=#{String(response.body).inspect}")
    end
  end
end
