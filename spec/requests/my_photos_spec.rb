require 'rails_helper'

RSpec.describe "MyPhotos", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/my_photos/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/my_photos/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/my_photos/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/my_photos/edit"
      expect(response).to have_http_status(:success)
    end
  end
end
