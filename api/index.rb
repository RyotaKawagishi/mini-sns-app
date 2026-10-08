# frozen_string_literal: true

require 'stringio'
require 'webrick'

ENV['BOOTSNAP_CACHE_DIR'] ||= '/tmp/bootsnap'
ENV['RAILS_ENV'] ||= 'production'
require_relative '../config/environment'

# Vercel supplies WEBrick requests; Rails expects the Rack interface.
Handler = proc do |request, response|
  env = request.meta_vars.merge(
    'SCRIPT_NAME' => '',
    'PATH_INFO' => request.path,
    'rack.input' => StringIO.new(request.body.to_s),
    'rack.errors' => $stderr,
    'rack.url_scheme' => 'https'
  )
  status, headers, body = Rails.application.call(env)
  begin
    response.status = status
    headers.each do |name, value|
      if name.downcase == 'set-cookie'
        Array(value).flat_map { |cookies| cookies.split("\n") }.each do |cookie|
          response.cookies.concat(WEBrick::Cookie.parse_set_cookies(cookie))
        end
      else
        response[name] = Array(value).join(', ')
      end
    end
    response.body = +''.b
    body.each { |chunk| response.body << chunk }
  ensure
    body.close if body.respond_to?(:close)
  end
end
