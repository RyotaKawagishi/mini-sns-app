# frozen_string_literal: true

# Keep each end-to-end scenario and its related assertions together.
# rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength

require 'rails_helper'

RSpec.describe Search, type: :model do
  subject(:search) { described_class.new(query: 'content') }

  it 'matches literal wildcard characters as literal input' do
    target = create(:user, name: '100%_matched')
    create(:user, name: '100Xmatched')
    expect(described_class.new(query: '%_').users(User.all)).to eq([target])
  end

  it 'keeps database queries bounded as results grow' do
    create_list(:micropost, 25, content: 'content')
    queries = []
    subscriber = lambda { |_name, _start, _finish, _id, payload|
      queries << payload[:sql] if payload[:sql].start_with?('SELECT') && payload[:name] != 'SCHEMA'
    }
    ActiveSupport::Notifications.subscribed(subscriber, 'sql.active_record') do
      posts = search.microposts(Micropost.all).paginate(page: 1, per_page: 20)
      posts.each do |post|
        post.user.name
        post.image.attached?
        post.likes.size
      end
      expect(posts.size).to eq(20)
    end
    expect(queries.size).to be <= 5
  end
end

# rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
