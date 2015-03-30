require 'spec_helper'

describe DownloadFile do
  context "when url is valid" do
    it 'should download a file to a local tempfile' do
      d = DownloadFile.new('http://example.com/file.txt')
      stub_request(:get, "http://example.com/file.txt").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => "this is the body", :headers => {})
      expect(File.exists?(d.download)).to be(true)
    end

    it 'should download the same file into unique local files' do
      d1 = DownloadFile.new('http://example.com/file.txt')
      d2 = DownloadFile.new('http://example.com/file.txt')
      stub_request(:get, "http://example.com/file.txt").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => "this is the body", :headers => {})
      expect(d1.download.to_path).not_to eql(d2.download.to_path)
    end
  end

  context "when url is invalid" do
    it 'raises error' do
      d = DownloadFile.new('http://foo')
      stub_request(:get, "http://foo/").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 404, :body => "", :headers => {})
      expect {d.download}.to raise_error
    end
  end
end

