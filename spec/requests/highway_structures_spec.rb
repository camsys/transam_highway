require 'rails_helper'

RSpec.describe Api::V1::HighwayStructuresController, type: :request do
  let!(:test_user) { create(:normal_user) }
  let!(:test_highway_structure) { create(:highway_structure) }

  let(:valid_headers) { {"X-User-Email" => test_user.email, "X-User-Token" => test_user.authentication_token} }

  describe 'GET /api/v1/highway_structures/{highway_structure_id}' do

    it "alerts if highway_structure not found" do 
      get "/api/v1/highway_structures/INVALID_KEY.json", headers: valid_headers
      expect(response).to have_http_status(:not_found)
    end

    it "succeed" do 
      get "/api/v1/highway_structures/#{test_highway_structure.object_key}.json", headers: valid_headers

      expect(response).to have_http_status(:success)
      expect(json["data"]["highway_structure"]["object_key"]).to eq(test_highway_structure.object_key)
    end
  end

  describe 'GET /api/v1/highway_structures' do

    it "succeed" do 
      get "/api/v1/highway_structures.json", headers: valid_headers

      expect(response).to have_http_status(:success)
      expect(json["data"]["highway_structures"].size).to eq(1)
      expect(json["data"]["highway_structures"][0]["object_key"]).to eq(test_highway_structure.object_key)
    end

  end

  describe 'PATCH /api/v1/highway_structures/{highway_structure_id}' do

    it "succeed" do 
      params = { highway_structure: {route_number: "test_route_number"} }
      patch "/api/v1/highway_structures/#{test_highway_structure.object_key}.json", headers: valid_headers, params: params
      
      expect(response).to have_http_status(:success)
      expect(json["data"]["highway_structure"]["route_number"]).to eq("test_route_number")
    end

  end

  describe 'DELETE /api/v1/highway_structures/{highway_structure_id}' do

    it "succeed" do 
      delete "/api/v1/highway_structures/#{test_highway_structure.object_key}.json", headers: valid_headers

      expect(response).to have_http_status(:success)
      expect(HighwayStructure.count).to eq(0)
    end

  end
end

