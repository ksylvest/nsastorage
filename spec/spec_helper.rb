# frozen_string_literal: true

require 'nsastorage'

Dir.glob(File.join(__dir__, 'support', '**', '*.rb')).each { |file| require file }

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
