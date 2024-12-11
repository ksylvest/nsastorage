# frozen_string_literal: true

RSpec.describe NSAStorage::Facility do
  describe '.sitemap' do
    subject(:sitemap) { described_class.sitemap }

    around { |example| VCR.use_cassette('nsastorage/facility/sitemap', &example) }

    it 'fetches and parses the sitemap' do
      expect(sitemap).to be_a(NSAStorage::Sitemap)
      expect(sitemap.links).to all(be_a(NSAStorage::Link))
    end
  end

  describe '.fetch' do
    subject(:fetch) { described_class.fetch(url: url) }

    let(:url) { 'https://www.nsastorage.com/storage/california/storage-units-paramount/7752-Jackson-St-876' }

    around { |example| VCR.use_cassette('nsastorage/facility/fetch', &example) }

    it 'fetches and parses the facility' do
      expect(fetch).to be_a(described_class)
      expect(fetch.address).to be_a(NSAStorage::Address)
      expect(fetch.geocode).to be_a(NSAStorage::Geocode)
      expect(fetch.prices).to all(be_a(NSAStorage::Price))
    end
  end
end
