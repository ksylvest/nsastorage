# frozen_string_literal: true

RSpec.describe NSAStorage do
  it 'has a version number' do
    expect(NSAStorage::VERSION).not_to be_nil
  end
end
