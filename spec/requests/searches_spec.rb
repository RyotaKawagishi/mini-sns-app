# frozen_string_literal: true

# Keep each end-to-end scenario and its related assertions together.
# rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength

require 'rails_helper'

RSpec.describe 'Searches', type: :request do
  subject(:search) { get searches_path, params: { query: 'SearchTarget' } }

  let(:user) { create(:user, name: 'Viewer', email: 'viewer@example.com') }
  let!(:target) { create(:user, name: 'SearchTarget', email: 'secret@example.com') }

  it 'requires authentication' do
    search
    expect(response).to redirect_to(login_path)
  end

  it 'finds activated users by name' do
    create(:user, :inactive, name: 'SearchTargetInactive')
    log_in_as(user)
    search
    expect(response.body).to include('SearchTarget')
    expect(response.body).not_to include('SearchTargetInactive')
  end

  it 'allows email search only for administrators' do
    log_in_as(user)
    get searches_path, params: { query: 'secret@example.com' }
    expect(response.body).not_to include("href=\"/users/#{target.id}\"")
    user.update!(admin: true)
    get searches_path, params: { query: 'secret@example.com' }
    expect(response.body).to include("href=\"/users/#{target.id}\"")
  end

  it 'combines content, author and inclusive date filters' do
    create(:micropost, user: target, content: 'matching content', created_at: Time.zone.parse('2026-09-02 23:59'))
    create(:micropost, user: target, content: 'outside range', created_at: Time.zone.parse('2026-09-03'))
    create(:micropost, user: user, content: 'other author')
    log_in_as(user)
    get searches_path,
        params: { type: 'microposts', query: 'content', author_id: target.id, from_date: '2026-09-02',
                  to_date: '2026-09-02' }
    expect(response.body).to include('matching content')
    expect(response.body).not_to include('outside range', 'other author')
  end

  it 'rejects invalid and reversed dates without raising' do
    log_in_as(user)
    get searches_path, params: { type: 'microposts', from_date: 'invalid' }
    expect(response.body).to include('日付を正しく')
    get searches_path, params: { type: 'microposts', from_date: '2026-09-03', to_date: '2026-09-02' }
    expect(response.body).to include('開始日は終了日以前')
  end

  it 'paginates results and preserves filters' do
    create_list(:user, 21, name: 'PagedPerson')
    log_in_as(user)
    get searches_path, params: { query: 'PagedPerson' }
    expect(response.body.scan('class="gravatar"').size).to eq(20)
    expect(response.body).to include('page=2', 'query=PagedPerson')
  end

  it 'treats wildcard and SQL syntax as literal input' do
    log_in_as(user)
    get searches_path, params: { query: "%_' OR 1=1 --" }
    expect(response.body).to include('該当するユーザーはありません')
  end
end

# rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
