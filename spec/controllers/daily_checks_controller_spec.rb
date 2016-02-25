require 'rails_helper'

RSpec.describe DailyChecksController, :type => :controller do

  describe "GET today" do
    it "returns http success" do
      get :today
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET yesterday" do
    it "returns http success" do
      get :yesterday
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET history" do
    it "returns http success" do
      get :history
      expect(response).to have_http_status(:success)
    end
  end

end
