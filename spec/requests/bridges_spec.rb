require 'rails_helper'

RSpec.describe Api::V1::BridgesController, type: :request do
  let!(:test_user) { create(:normal_user) }
  let!(:test_bridge) { create(:bridge) }

  let(:valid_headers) { {"X-User-Email" => test_user.email, "X-User-Token" => test_user.authentication_token} }

  describe 'GET /api/v1/bridges/{bridge_id}' do

    it "alerts if bridge not found" do 
      get "/api/v1/bridges/INVALID_BRIDGE_KEY.json", headers: valid_headers
      expect(response).to have_http_status(:not_found)
    end

    it "succeed" do 
      get "/api/v1/bridges/#{test_bridge.object_key}.json", headers: valid_headers

      expect(response).to have_http_status(:success)
      expect(json["data"]["bridge"]["object_key"]).to eq(test_bridge.object_key)
    end
  end

  describe 'GET /api/v1/bridges' do

    it "succeed" do 
      get "/api/v1/bridges.json", headers: valid_headers

      expect(response).to have_http_status(:success)
      expect(json["data"]["bridges"].size).to eq(1)
      expect(json["data"]["bridges"][0]["object_key"]).to eq(test_bridge.object_key)
    end

  end

  describe 'PATCH /api/v1/bridges/{bridge_id}' do

    it "succeed" do 
      params = { bridge: {num_spans_main: 100} }
      patch "/api/v1/bridges/#{test_bridge.object_key}.json", headers: valid_headers, params: params
      
      expect(response).to have_http_status(:success)
      expect(json["data"]["bridge"]["num_spans_main"]).to eq(100)
    end

  end

  describe 'DELETE /api/v1/bridges/{bridge_id}' do

    it "succeed" do 
      delete "/api/v1/bridges/#{test_bridge.object_key}.json", headers: valid_headers

      expect(response).to have_http_status(:success)
      expect(Bridge.count).to eq(0)
    end

  end
end

