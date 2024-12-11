# frozen_string_literal: true

RSpec.describe NSAStorage::CLI do
  let(:cli) { described_class.new }

  describe '#parse' do
    context 'with an unknown command' do
      it 'prints an error message' do
        allow(cli).to receive(:warn)
        expect { cli.parse(%w[unknown]) }.to raise_error(SystemExit)
        expect(cli).to have_received(:warn).with('unsupported command="unknown"')
      end
    end

    context 'with a crawl command' do
      it 'proxies NSAStorage::Crawl.crawl' do
        allow(NSAStorage::Crawl).to receive(:run)
        expect { cli.parse(%w[crawl]) }.to raise_error(SystemExit)
        expect(NSAStorage::Crawl).to have_received(:run)
      end
    end

    context 'with a version flag' do
      %w[-v --version].each do |option|
        it "prints version with '#{option}'" do
          allow(cli).to receive(:puts)
          expect { cli.parse([option]) }.to raise_error(SystemExit)
          expect(cli).to have_received(:puts).with(NSAStorage::VERSION)
        end
      end
    end

    context 'with a help flag' do
      %w[-h --help].each do |option|
        it "prints help with '#{option}'" do
          allow(cli).to receive(:puts)
          expect { cli.parse([option]) }.to raise_error(SystemExit)
          expect(cli).to have_received(:puts)
        end
      end
    end
  end
end
