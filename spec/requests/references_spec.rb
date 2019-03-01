require 'rails_helper'

RSpec.describe Api::V1::ReferencesController, type: :request do
  let!(:test_user) { create(:normal_user) }
  let!(:test_condition_type) { create(:channel_condition_type) }
  let(:test_association_class) { "ChannelConditionType" }
  let!(:test_highway_structure) { create(:highway_structure) }

  let(:valid_headers) { {"X-User-Email" => test_user.email, "X-User-Token" => test_user.authentication_token} }

  describe 'GET /api/v1/reference_data' do

    before { 
      get "/api/v1/reference_data.json", headers: valid_headers 
    }

    it 'returns data' do
      expect(response).to render_template(:index)
      expect(json).not_to be_empty
      expect(json['status']).to eq('success')
    end

    it 'includes associations data' do 
      expect(json['data']['associations']['ChannelConditionType'].size).to eq(1)
      expect(json['data']['associations']['ChannelConditionType'][0]["id"]).to eq(test_condition_type.id)
    end

    it 'includes highway_structures data' do 
      expect(json['data']['highway_structures'].size).to eq(1)
      expect(json['data']['highway_structures'][0]["object_key"]).to eq(test_highway_structure.object_key)
    end

  end
end
