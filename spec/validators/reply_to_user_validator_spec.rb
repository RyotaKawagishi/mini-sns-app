# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReplyToUserValidator, type: :validator do
  let(:dummy_model) do
    Struct.new(:in_reply_to) do
      include ActiveModel::Validations

      def self.name
        "DummyModel"
      end

      validates :in_reply_to, reply_to_user: true
    end
  end

  describe "バリデーション" do
    subject { dummy_model.new(in_reply_to) }

    context "in_reply_toがnilの場合" do
      let(:in_reply_to) { nil }

      it "有効であること" do
        expect(subject).to be_valid
      end
    end

    context "存在するユーザーIDの場合" do
      let(:user) { create(:user) }
      let(:in_reply_to) { user.id }

      it "有効であること" do
        expect(subject).to be_valid
      end
    end

    context "存在しないユーザーIDの場合" do
      let(:in_reply_to) { 99999 }

      it "無効であること" do
        expect(subject).not_to be_valid
        expect(subject.errors[:in_reply_to]).to be_present
      end
    end
  end
end

