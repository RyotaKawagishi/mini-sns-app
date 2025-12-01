# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe "バリデーション" do
    it "有効なユーザーであること" do
      expect(user).to be_valid
    end

    it "nameが空の場合は無効であること" do
      user.name = " "
      expect(user).not_to be_valid
    end

    it "emailが空の場合は無効であること" do
      user.email = " "
      expect(user).not_to be_valid
    end

    it "nameが51文字以上の場合は無効であること" do
      user.name = "a" * 51
      expect(user).not_to be_valid
    end

    it "emailが255文字を超える場合は無効であること" do
      user.email = "a" * 244 + "@example.com"
      expect(user).not_to be_valid
    end

    it "有効なメールアドレスを受け入れること" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid, "#{valid_address.inspect} should be valid"
      end
    end

    it "無効なメールアドレスを拒否すること" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).not_to be_valid, "#{invalid_address.inspect} should be invalid"
      end
    end

    it "メールアドレスが一意であること" do
      duplicate_user = user.dup
      user.save
      expect(duplicate_user).not_to be_valid
    end

    it "メールアドレスが小文字で保存されること" do
      mixed_case_email = "Foo@ExamPle.Com"
      user.email = mixed_case_email
      user.save
      expect(user.reload.email).to eq mixed_case_email.downcase
    end

    it "passwordが空の場合は無効であること" do
      user.password = user.password_confirmation = " " * 8
      expect(user).not_to be_valid
    end

    it "passwordが8文字未満の場合は無効であること" do
      user.password = user.password_confirmation = "a" * 7
      expect(user).not_to be_valid
    end
  end

  describe "#authenticated?" do
    it "nil digestの場合はfalseを返すこと" do
      expect(user.authenticated?(:remember, "")).to be false
    end
  end

  describe "アソシエーション" do
    it "ユーザーを削除すると関連するマイクロポストも削除されること" do
      user.save
      user.microposts.create!(content: "Lorem ipsum")
      expect { user.destroy }.to change(Micropost, :count).by(-1)
    end
  end

  describe "#follow" do
    let(:michael) { create(:user) }
    let(:archer) { create(:user) }

    it "ユーザーをフォローできること" do
      expect { michael.follow(archer) }.to change { michael.following.count }.by(1)
      expect(michael.following?(archer)).to be true
      expect(archer.followers).to include(michael)
    end

    it "ユーザーをフォロー解除できること" do
      michael.follow(archer)
      expect { michael.unfollow(archer) }.to change { michael.following.count }.by(-1)
      expect(michael.following?(archer)).to be false
    end

    it "自分自身をフォローできないこと" do
      michael.follow(michael)
      expect(michael.following?(michael)).to be false
    end
  end

  describe "#feed" do
    let(:michael) { create(:user) }
    let(:archer) { create(:user) }
    let(:lana) { create(:user) }

    before do
      michael.follow(lana)
      create_list(:micropost, 3, user: lana)
      create_list(:micropost, 3, user: michael)
      create_list(:micropost, 3, user: archer)
    end

    it "フォローしているユーザーの投稿がフィードに含まれること" do
      lana.microposts.each do |post_following|
        expect(michael.feed).to include(post_following)
      end
    end

    it "自身の投稿がフィードに含まれること" do
      michael.microposts.each do |post_self|
        expect(michael.feed).to include(post_self)
      end
      expect(michael.feed.distinct).to eq michael.feed
    end

    it "フォローしていないユーザーの投稿がフィードに含まれないこと" do
      archer.microposts.each do |post_unfollowed|
        expect(michael.feed).not_to include(post_unfollowed)
      end
    end
  end
end

