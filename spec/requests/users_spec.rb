# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }

  describe "GET /signup" do
    it "サインアップページが表示されること" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /users" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get users_path
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe "GET /users/:id/edit" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get edit_user_path(user)
        expect(flash).not_to be_empty
        expect(response).to redirect_to(login_url)
      end
    end

    context "他のユーザーでログインしている場合" do
      before { log_in_as(other_user) }

      it "ルートページにリダイレクトされること" do
        get edit_user_path(user)
        expect(flash).to be_empty
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PATCH /users/:id" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        patch user_path(user), params: { user: { name: user.name,
                                                 email: user.email } }
        expect(flash).not_to be_empty
        expect(response).to redirect_to(login_url)
      end
    end

    context "他のユーザーでログインしている場合" do
      before { log_in_as(other_user) }

      it "ルートページにリダイレクトされること" do
        patch user_path(user), params: { user: { name: user.name,
                                                 email: user.email } }
        expect(flash).to be_empty
        expect(response).to redirect_to(root_url)
      end
    end

    context "admin属性の編集" do
      before { log_in_as(other_user) }

      it "admin属性を編集できないこと" do
        expect(other_user.admin?).to be false
        patch user_path(other_user), params: {
                                      user: { password: "password",
                                              password_confirmation: "password",
                                              admin: true } }
        expect(other_user.reload.admin?).to be false
      end
    end
  end

  describe "DELETE /users/:id" do
    context "ログインしていない場合" do
      it "ユーザーが削除されないこと" do
        expect { delete user_path(user) }.not_to change(User, :count)
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(login_url)
      end
    end

    context "非管理者でログインしている場合" do
      before { log_in_as(other_user) }

      it "ユーザーが削除されないこと" do
        expect { delete user_path(user) }.not_to change(User, :count)
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "GET /users/:id/following" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get following_user_path(user)
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe "GET /users/:id/followers" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get followers_user_path(user)
        expect(response).to redirect_to(login_url)
      end
    end
  end
end

