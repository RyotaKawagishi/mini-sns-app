# frozen_string_literal: true

require "rails_helper"

RSpec.describe MicropostPolicy, type: :policy do
  subject { described_class.new(user, record) }

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:micropost_user) { create(:user) }
  let(:micropost) { create(:micropost, user: micropost_user) }
  let(:other_micropost) { create(:micropost, user: other_user) }

  describe "#create?" do
    let(:record) { Micropost.new }

    it "ログインユーザーはマイクロポストを作成できること" do
      expect(subject.create?).to be true
    end

    context "未ログインユーザーの場合" do
      let(:user) { nil }

      it "マイクロポストを作成できないこと" do
        expect(subject.create?).to be false
      end
    end
  end

  describe "#destroy?" do
    context "自分のマイクロポストの場合" do
      let(:user) { micropost_user }
      let(:record) { micropost }

      it "削除できること" do
        expect(subject.destroy?).to be true
      end
    end

    context "他のユーザーのマイクロポストの場合" do
      let(:record) { other_micropost }

      it "削除できないこと" do
        expect(subject.destroy?).to be false
      end
    end

    context "未ログインユーザーの場合" do
      let(:user) { nil }
      let(:record) { create(:micropost) }

      it "削除できないこと" do
        expect(subject.destroy?).to be false
      end
    end
  end
end

