# frozen_string_literal: true

module NSAStorage
  # A link in a sitemap.
  class Link
    # @attribute [rw] loc
    #   @return [String]
    attr_accessor :loc

    # @attribute [rw] lastmod
    #   @return [Time]
    attr_accessor :lastmod

    # @param loc [String]
    # @param lastmod [String]
    def initialize(loc:, lastmod:)
      @loc = loc
      @lastmod = Time.parse(lastmod)
    end

    # @return [String]
    def inspect
      "#<#{self.class.name} loc=#{@loc.inspect} lastmod=#{@lastmod.inspect}>"
    end
  end
end
