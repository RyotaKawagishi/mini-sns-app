# frozen_string_literal: true

require "rails_helper"

RSpec.describe Micropost, type: :model do
  let(:user) { create(:user) }
  subject(:micropost) { build(:micropost, user: user) }

  describe "バリデーション" do
    it "有効なマイクロポストであること" do
      expect(micropost).to be_valid
    end

    it "user_idが空の場合は無効であること" do
      micropost.user_id = nil
      expect(micropost).not_to be_valid
    end

    it "contentが空の場合は無効であること" do
      micropost.content = "   "
      expect(micropost).not_to be_valid
    end

    it "contentが141文字以上の場合は無効であること" do
      micropost.content = "a" * 141
      expect(micropost).not_to be_valid
    end
  end

  describe "デフォルトスコープ" do
    it "最新の投稿が最初に来ること" do
      user = create(:user)
      old_post = create(:micropost, user: user, created_at: 1.day.ago)
      new_post = create(:micropost, user: user, created_at: Time.zone.now)
      expect(Micropost.first).to eq new_post
    end
  end

  describe "メンション機能" do
    let(:user) { create(:user) }
    let(:reply_to) { create(:user) }

    it "リプライでない場合は有効であること" do
      micropost = build(:micropost, user: user, in_reply_to: nil)
      expect(micropost).to be_valid
    end

    it "自分自身にリプライできないこと" do
      micropost = build(:micropost, user: user, in_reply_to: user.id)
      expect(micropost).not_to be_valid
      expect(micropost.errors.full_messages).to include("In reply to You can't reply to yourself.")
    end
  end
end

