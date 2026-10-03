# frozen_string_literal: true

# Keep each end-to-end scenario and its related assertions together.
# rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength

require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  subject(:like_post) do
    post likes_path, params: { micropost_id: micropost.id }, headers: { 'Accept' => 'text/vnd.turbo-stream.html' }
  end

  let(:user) { create(:user) }
  let(:micropost) { create(:micropost) }

  it 'requires login' do
    expect { like_post }.not_to change(Like, :count)
    expect(response).to redirect_to(login_path)
  end

  it 'creates once, updates the button and allows undo' do
    log_in_as(user)
    expect { like_post }.to change(Like, :count).by(1)
    expect(response.body).to include('action="replace"', 'aria-label="Unlike"', 'aria-pressed="true"', '1 likes')
    expect { post likes_path, params: { micropost_id: micropost.id } }.not_to change(Like, :count)
    delete like_path(Like.last), headers: { 'Accept' => 'text/vnd.turbo-stream.html' }
    expect(Like.count).to eq(0)
    expect(response.body).to include('0 likes', 'aria-label="Like"', 'aria-pressed="false"')
  end

  it "cannot delete another user's like" do
    like = Like.create!(user: create(:user), micropost: micropost)
    log_in_as(user)
    expect { delete like_path(like) }.not_to change(Like, :count)
    expect(response).to redirect_to(root_path)
  end

  it 'does not redirect to an external referrer' do
    log_in_as(user)
    post likes_path, params: { micropost_id: micropost.id },
                     headers: { 'HTTP_REFERER' => 'https://attacker.example/' }
    expect(response).to redirect_to(root_path)
  end

  it 'renders buttons on the home feed and profile' do
    micropost.update!(user: user)
    log_in_as(user)
    get root_path
    expect(response.body).to include('aria-label="Like"', 'aria-pressed="false"', 'heart-icon', '0 likes')
    get user_path(user)
    expect(response.body).to include('aria-label="Like"', 'aria-pressed="false"', 'heart-icon', '0 likes')
  end
end

# rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
