# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
    admin { false }

    trait :admin do
      admin { true }
    end

    trait :inactive do
      activated { false }
      activated_at { nil }
    end
  end
end

