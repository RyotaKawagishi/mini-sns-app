# frozen_string_literal: true

FactoryBot.define do
  factory :micropost do
    association :user
    content { Faker::Lorem.sentence(word_count: 5) }
    in_reply_to { nil }
  end
end

