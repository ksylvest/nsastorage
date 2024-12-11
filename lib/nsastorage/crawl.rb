# frozen_string_literal: true

module NSAStorage
  # Handles the crawl command via CLI.
  class Crawl
    def self.run(...)
      new(...).run
    end

    # @param stdout [IO] optional
    # @param stderr [IO] optional
    # @param options [Hash] optional
    def initialize(stdout: $stdout, stderr: $stderr, options: {})
      @stdout = stdout
      @stderr = stderr
      @options = options
    end

    def run
      sitemap = Facility.sitemap
      @stdout.puts("count=#{sitemap.links.count}")
      @stdout.puts

      sitemap.links.each { |link| process(url: link.loc) }
    end

    def process(url:)
      @stdout.puts(url)
      facility = Facility.fetch(url: url)
      @stdout.puts(facility.text)
      facility.prices.each { |price| @stdout.puts(price.text) }
      @stdout.puts
    rescue FetchError => e
      @stderr.puts("url=#{url} error=#{e.message}")
    end
  end
end
