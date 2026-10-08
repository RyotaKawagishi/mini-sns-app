# frozen_string_literal: true

# Keep each security scenario and its assertions together.
# rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength

require 'rails_helper'

RSpec.describe 'Security', type: :request do
  subject(:visit) { get root_path }

  it 'sets restrictive browser headers' do
    visit
    expect(response.headers).to include('X-Frame-Options' => 'SAMEORIGIN', 'X-Content-Type-Options' => 'nosniff',
                                        'Referrer-Policy' => 'strict-origin-when-cross-origin')
    expect(response.headers['Content-Security-Policy']).to include("object-src 'none'", "frame-ancestors 'self'",
                                                                   "script-src 'self'")
  end

  it 'escapes script markup in posts' do
    user = create(:user)
    create(:micropost, user: user, content: '<script>alert(1)</script>')
    get user_path(user)
    expect(response.body).to include('&lt;script&gt;')
    expect(response.body).not_to include('<script>alert(1)</script>')
  end

  it 'stores the forwarding location for HEAD requests' do
    head users_path
    expect(response).to redirect_to(login_path)
    user = create(:user)
    log_in_as(user)
    expect(response).to redirect_to(users_path)
  end

  it 'does not redirect deletion to an external referrer' do
    user = create(:user)
    micropost = create(:micropost, user: user)
    log_in_as(user)
    delete micropost_path(micropost), headers: { 'HTTP_REFERER' => 'https://attacker.example/' }
    expect(response).to redirect_to(root_path)
  end

  it 'marks persistent authentication cookies as HttpOnly and SameSite' do
    log_in_as(create(:user))
    cookies_header = Array(response.headers['Set-Cookie']).join("\n")
    expect(cookies_header).to include('httponly', 'samesite=lax')
  end

  it 'rejects forged state-changing requests' do
    original = ApplicationController.allow_forgery_protection
    ApplicationController.allow_forgery_protection = true
    user = create(:user)
    post login_path, params: { session: { email: user.email, password: 'password' } }
    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include('InvalidAuthenticityToken')
  ensure
    ApplicationController.allow_forgery_protection = original
  end

  it 'does not treat SQL syntax as a login query' do
    create(:user)
    post login_path, params: { session: { email: "' OR 1=1 --", password: 'password' } }
    expect(response).to have_http_status(:unprocessable_entity)
  end
end

# rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
