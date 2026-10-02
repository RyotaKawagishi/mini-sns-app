require "rails_helper"
require "webrick"
require "stringio"
require_relative "../../api/index"

RSpec.describe "Vercel Rack adapter" do
  def invoke(request_text)
    request = WEBrick::HTTPRequest.new(WEBrick::Config::HTTP)
    request.parse(StringIO.new(request_text))
    response = WEBrick::HTTPResponse.new(WEBrick::Config::HTTP)
    Handler.call(request, response)
    response
  end

  it "renders Rails pages" do
    response = invoke("GET /login HTTP/1.1\r\nHost: www.example.com\r\n\r\n")

    expect(response.status).to eq(200)
    expect(response.body).to include("Log in")
  end

  it "preserves Rails authentication redirects and session cookies" do
    response = invoke("GET /users HTTP/1.1\r\nHost: www.example.com\r\n\r\n")

    expect(response.status).to eq(303)
    expect(response["location"]).to end_with("/login")
    expect(response.cookies.map(&:name)).to include("_sample_app2_session")
  end

  it "preserves form bodies, query strings, headers and separate cookies" do
    received = nil
    body = double("body")
    allow(body).to receive(:each).and_yield("result")
    expect(body).to receive(:close)
    allow(Rails.application).to receive(:call) do |env|
      received = env
      [302, { "location" => "/login", "set-cookie" => ["first=1; Path=/", "second=2; Path=/"] }, body]
    end
    response = invoke("POST /login?from=home HTTP/1.1\r\nHost: www.example.com\r\nContent-Type: application/x-www-form-urlencoded\r\nCookie: session=token\r\nContent-Length: 8\r\n\r\nname=joe")

    expect(received["rack.input"].read).to eq("name=joe")
    expect(received["QUERY_STRING"]).to eq("from=home")
    expect(received["HTTP_COOKIE"]).to eq("session=token")
    expect(received["rack.url_scheme"]).to eq("https")
    expect(response.status).to eq(302)
    expect(response["location"]).to eq("/login")
    expect(response.cookies.map(&:name)).to eq(%w[first second])
    expect(response.body).to eq("result")
  end
end
