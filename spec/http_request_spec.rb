require 'spec_helper'

describe 'Fb::HTTPRequest#run' do
  let(:params) { {fields: 'id,is_verified,link', access_token: access_token} }
  let(:request) { Fb::HTTPRequest.new path: path, params: params }
  let(:access_token) { ENV['FB_TEST_ACCESS_TOKEN'] }

  context 'given a valid GET request to a Facebook Graph API endpoint' do
    let(:path) { '/v2.10/221406534569729' }

    it 'returns the HTTP response with the JSON-parsed body' do
      response = request.run
      expect(response).to be_a Net::HTTPOK
      expect(response.body).to be_a Hash
    end
  end

  context 'given a invalid GET request to a Facebook JSON API' do
    let(:path) { '/v2.10/1' }
    let(:message) { '(#803) Some of the aliases you requested do not exist: 1' }

    it 'raises an HTTPError' do
      expect{request.run}.to raise_error Fb::HTTPError, message
    end
  end
end

describe 'Fb::HTTPRequest#url' do
  let(:options) { {host: 'www.facebook.com', path: '/test', params: {id: 1}} }
  let(:request) { Fb::HTTPRequest.new options }

  context 'given a valid GET request to a Facebook Graph API endpoint' do
    it 'returns the request URL' do
      expect(request.url).to eq 'https://www.facebook.com/test?id=1'
    end
  end
end
