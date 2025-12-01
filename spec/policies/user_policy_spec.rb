# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserPolicy, type: :policy do
  subject { described_class.new(user, record) }

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }

  describe "#index?" do
    let(:record) { User }

    it "ログインユーザーは一覧を表示できること" do
      expect(subject.index?).to be true
    end

    context "未ログインユーザーの場合" do
      let(:user) { nil }

      it "一覧を表示できないこと" do
        expect(subject.index?).to be false
      end
    end
  end

  describe "#show?" do
    let(:activated_user) { create(:user, activated: true) }
    let(:inactive_user) { create(:user, :inactive) }

    context "アクティベート済みユーザーの場合" do
      let(:record) { activated_user }

      it "表示できること" do
        expect(subject.show?).to be true
      end
    end

    context "未アクティベートユーザーの場合" do
      let(:record) { inactive_user }

      it "表示できないこと" do
        expect(subject.show?).to be false
      end
    end
  end

  describe "#create?" do
    let(:record) { User.new }

    it "誰でもユーザーを作成できること" do
      expect(subject.create?).to be true
    end

    context "未ログインユーザーの場合" do
      let(:user) { nil }

      it "作成できること" do
        expect(subject.create?).to be true
      end
    end
  end

  describe "#update?" do
    context "自分のアカウントの場合" do
      let(:record) { user }

      it "更新できること" do
        expect(subject.update?).to be true
      end
    end

    context "他のユーザーのアカウントの場合" do
      let(:record) { other_user }

      it "更新できないこと" do
        expect(subject.update?).to be false
      end
    end

    context "未ログインユーザーの場合" do
      let(:user) { nil }
      let(:record) { create(:user) }

      it "更新できないこと" do
        expect(subject.update?).to be false
      end
    end
  end

  describe "#destroy?" do
    context "管理者の場合" do
      let(:user) { admin_user }
      let(:record) { other_user }

      it "ユーザーを削除できること" do
        expect(subject.destroy?).to be true
      end
    end

    context "非管理者の場合" do
      let(:record) { other_user }

      it "ユーザーを削除できないこと" do
        expect(subject.destroy?).to be false
      end
    end

    context "未ログインユーザーの場合" do
      let(:user) { nil }
      let(:record) { create(:user) }

      it "削除できないこと" do
        expect(subject.destroy?).to be false
      end
    end
  end

  describe "#following?" do
    let(:record) { user }

    it "ログインユーザーはフォロー中一覧を表示できること" do
      expect(subject.following?).to be true
    end

    context "未ログインユーザーの場合" do
      let(:user) { nil }

      it "フォロー中一覧を表示できないこと" do
        expect(subject.following?).to be false
      end
    end
  end

  describe "#followers?" do
    let(:record) { user }

    it "ログインユーザーはフォロワー一覧を表示できること" do
      expect(subject.followers?).to be true
    end

    context "未ログインユーザーの場合" do
      let(:user) { nil }

      it "フォロワー一覧を表示できないこと" do
        expect(subject.followers?).to be false
      end
    end
  end
end

