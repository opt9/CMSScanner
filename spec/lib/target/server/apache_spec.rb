require 'spec_helper'

describe CMSScanner::Target::Server::Apache do
  subject(:target) { CMSScanner::Target.new(url).extend(CMSScanner::Target::Server::Apache) }
  let(:url)        { 'http://ex.lo' }
  let(:fixtures)   { File.join(FIXTURES, 'target', 'server', 'apache') }

  before { stub_request(:get, target.url(path)).to_return(body: body, status: status) }

  describe '#directory_listing?, #directory_listing_entries' do
    let(:path) { 'somedir' }

    context 'when not a 200' do
      let(:status) { 404 }
      let(:body)   { '' }

      it 'returns false and an empty array' do
        expect(target.directory_listing?(path)).to be false
        expect(target.directory_listing_entries(path)).to eql []
      end
    end

    context 'when 200' do
      let(:status) { 200 }
      let(:body)   { File.read(File.join(fixtures, 'directory_listing', '2.2.16.html')) }

      it 'returns true and the expected array' do
        expect(target.directory_listing?(path)).to be true
        expect(target.directory_listing_entries(path)).to eq %w(backup.php database-empty.php)
      end
    end
  end
end