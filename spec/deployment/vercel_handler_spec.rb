# frozen_string_literal: true

# Keep request scenarios and their protocol assertions together.
# rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations

require 'rails_helper'
require 'webrick'
require 'stringio'
require_relative '../../api/index'

RSpec.describe 'Vercel Rack adapter', type: :request do
  def invoke(request_text)
    request = WEBrick::HTTPRequest.new(WEBrick::Config::HTTP)
    request.parse(StringIO.new(request_text))
    response = WEBrick::HTTPResponse.new(WEBrick::Config::HTTP)
    Handler.call(request, response)
    response
  end

  it 'renders Rails pages' do
    response = invoke("GET /login HTTP/1.1\r\nHost: www.example.com\r\n\r\n")

    expect(response.status).to eq(200)
    expect(response.body).to include('Log in')
  end

  it 'preserves Rails authentication redirects and session cookies' do
    response = invoke("GET /users HTTP/1.1\r\nHost: www.example.com\r\n\r\n")

    expect(response.status).to eq(303)
    expect(response['location']).to end_with('/login')
    expect(response.cookies.map(&:name)).to include('_sample_app2_session')
  end

  it 'preserves form bodies, query strings, headers and separate cookies' do
    received = nil
    body = instance_double(StringIO)
    allow(body).to receive(:each).and_yield('result')
    allow(body).to receive(:close)
    allow(Rails.application).to receive(:call) do |env|
      received = env
      [302, { 'location' => '/login', 'set-cookie' => ['first=1; Path=/', 'second=2; Path=/'] }, body]
    end
    headers = [
      'POST /login?from=home HTTP/1.1',
      'Host: www.example.com',
      'Content-Type: application/x-www-form-urlencoded',
      'Cookie: session=token',
      'Content-Length: 8'
    ].join("\r\n")
    response = invoke("#{headers}\r\n\r\nname=joe")

    expect(received['rack.input'].read).to eq('name=joe')
    expect(received['QUERY_STRING']).to eq('from=home')
    expect(received['HTTP_COOKIE']).to eq('session=token')
    expect(received['rack.url_scheme']).to eq('https')
    expect(response.status).to eq(302)
    expect(response['location']).to eq('/login')
    expect(response.cookies.map(&:name)).to eq(%w[first second])
    expect(response.body).to eq('result')
    expect(body).to have_received(:close)
  end
end

# rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
