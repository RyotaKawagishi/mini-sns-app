require 'benchmark'
require 'factory_bot'
ApplicationRecord.transaction do
  viewer = FactoryBot.create(:user)
  author = FactoryBot.create(:user)
  viewer.follow(author)
  users = FactoryBot.create_list(:user, 40)
  users.each { |u| u.follow(author) }
  FactoryBot.create_list(:micropost, 150, user: author)
  old_feed = Micropost.left_outer_joins(user: :followers)
                     .where('relationships.follower_id = :id OR microposts.user_id = :id OR microposts.in_reply_to = :id', id: viewer.id).distinct
  new_feed = viewer.feed.except(:includes)
  raise 'different results' unless old_feed.pluck(:id) == new_feed.pluck(:id)
  ActiveRecord::Base.uncached do
    {old: old_feed, new: new_feed}.each do |name, query|
      elapsed = Benchmark.realtime { 100.times { query.limit(30).pluck(:id) } }
      puts "#{name}: #{elapsed.round(4)}s (100 page reads)"
      puts query.explain
    end
  end
  raise ActiveRecord::Rollback
end
