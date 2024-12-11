# frozen_string_literal: true

module NSAStorage
  # The features (e.g. climate-controlled, inside-drive-up-access, outside-drive-up-access, etc) of a price.
  class Features
    # @param element [Nokogiri::XML::Element]
    #
    # @return [Features]
    def self.parse(element:)
      text = element.text

      new(
        climate_controlled: text.include?('Climate controlled'),
        drive_up_access: text.include?('Drive Up Access'),
        first_floor_access: text.include?('1st Floor')
      )
    end

    # @param climate_controlled [Boolean]
    # @param drive_up_access [Boolean]
    # @param first_floor_access [Boolean]
    def initialize(climate_controlled:, drive_up_access:, first_floor_access:)
      @climate_controlled = climate_controlled
      @drive_up_access = drive_up_access
      @first_floor_access = first_floor_access
    end

    # @return [String]
    def inspect
      props = [
        "climate_controlled=#{@climate_controlled}",
        "drive_up_access=#{@drive_up_access}",
        "first_floor_access=#{@first_floor_access}"
      ]

      "#<#{self.class.name} #{props.join(' ')}>"
    end

    # @return [String] e.g. "Climate Controlled + First Floor Access"
    def text
      amenities.join(' + ')
    end

    # @return [Array<String>]
    def amenities
      [].tap do |amenities|
        amenities << 'Climate Controlled' if climate_controlled?
        amenities << 'Drive-Up Access' if drive_up_access?
        amenities << 'First Floor Access' if first_floor_access?
      end
    end

    # @return [Boolean]
    def climate_controlled?
      @climate_controlled
    end

    # @return [Boolean]
    def drive_up_access?
      @drive_up_access
    end

    # @return [Boolean]
    def first_floor_access?
      @first_floor_access
    end
  end
end
