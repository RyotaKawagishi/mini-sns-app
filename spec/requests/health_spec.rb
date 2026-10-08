require "rails_helper"

RSpec.describe "Health", type: :request do
  describe "GET /up" do
    subject(:request_health) { get "/up" }

    it "認証なしでヘルスチェックに成功する" do
      request_health

      expect(response).to have_http_status(:ok)
    end
  end
end
