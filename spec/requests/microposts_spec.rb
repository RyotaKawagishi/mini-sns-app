# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Microposts", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:micropost) { create(:micropost, user: user) }
  let!(:other_micropost) { create(:micropost, user: other_user) }

  describe "POST /microposts" do
    context "ログインしていない場合" do
      it "マイクロポストが作成されないこと" do
        expect { post microposts_path, params: { micropost: { content: "Lorem ipsum" } } }
          .not_to change(Micropost, :count)
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe "DELETE /microposts/:id" do
    context "ログインしていない場合" do
      it "マイクロポストが削除されないこと" do
        expect { delete micropost_path(micropost) }
          .not_to change(Micropost, :count)
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(login_url)
      end
    end

    context "他のユーザーのマイクロポストの場合" do
      before { log_in_as(user) }

      it "マイクロポストが削除されないこと" do
        expect { delete micropost_path(other_micropost) }
          .not_to change(Micropost, :count)
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end

