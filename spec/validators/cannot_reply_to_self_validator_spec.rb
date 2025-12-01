# frozen_string_literal: true

require "rails_helper"

RSpec.describe CannotReplyToSelfValidator, type: :validator do
  let(:user) { create(:user) }
  let(:dummy_model) do
    Struct.new(:user_id, :in_reply_to) do
      include ActiveModel::Validations

      def self.name
        "DummyModel"
      end

      validates :in_reply_to, cannot_reply_to_self: true
    end
  end

  describe "バリデーション" do
    subject { dummy_model.new(user_id, in_reply_to) }

    context "in_reply_toがnilの場合" do
      let(:user_id) { user.id }
      let(:in_reply_to) { nil }

      it "有効であること" do
        expect(subject).to be_valid
      end
    end

    context "自分自身にリプライする場合" do
      let(:user_id) { user.id }
      let(:in_reply_to) { user.id }

      it "無効であること" do
        expect(subject).not_to be_valid
        expect(subject.errors[:in_reply_to]).to be_present
      end
    end

    context "他のユーザーにリプライする場合" do
      let(:other_user) { create(:user) }
      let(:user_id) { user.id }
      let(:in_reply_to) { other_user.id }

      it "有効であること" do
        expect(subject).to be_valid
      end
    end
  end
end

