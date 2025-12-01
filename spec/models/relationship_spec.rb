# frozen_string_literal: true

require "rails_helper"

RSpec.describe Relationship, type: :model do
  let(:follower) { create(:user) }
  let(:followed) { create(:user) }
  subject(:relationship) { build(:relationship, follower: follower, followed: followed) }

  describe "バリデーション" do
    it "有効なリレーションシップであること" do
      expect(relationship).to be_valid
    end

    it "follower_idが空の場合は無効であること" do
      relationship.follower_id = nil
      expect(relationship).not_to be_valid
    end

    it "followed_idが空の場合は無効であること" do
      relationship.followed_id = nil
      expect(relationship).not_to be_valid
    end
  end
end

