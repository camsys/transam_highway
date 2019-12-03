require 'rails_helper'

RSpec.describe Api::V1::ReferencesController, type: :request do
  let!(:test_user) { create(:normal_user) }
  let!(:test_condition_type) { create(:channel_condition_type) }
  let(:test_association_class) { "ChannelConditionType" }
  let!(:test_highway_structure) { create(:bridge) }
  let!(:test_inspection) { create(:inspection, highway_structure: test_highway_structure) }
  let!(:test_element) { create(:element, inspection: test_inspection) }
  let!(:test_defect) { create(:defect, inspection: test_inspection, element: test_element) }

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

    it 'includes structures data' do 
      expect(json['data']['structures'].size).to eq(6)
      expect(json['data']['structures']['bridges'][0]["object_key"]).to eq(test_highway_structure.object_key)
    end

    it 'includes element_definition data' do 
      expect(json['data']['element_definitions'].size).to eq(1)
      expect(json['data']['element_definitions'][0]["id"]).to eq(test_element.element_definition.id)
    end

    it 'includes defect_definition data' do 
      expect(json['data']['defect_definitions'].size).to eq(1)
      expect(json['data']['defect_definitions'][0]["id"]).to eq(test_defect.defect_definition.id)
    end

    it 'includes element_defect_definitions data' do
      # Set up cross associations and test again
      test_element.element_definition.defect_definition_ids = test_defect.defect_definition.id
      test_defect.defect_definition.element_definition_ids = test_element.element_definition.id

      get "/api/v1/reference_data.json", headers: valid_headers
      expect(json['data']['element_defect_definitions'])
        .to match_array([{'defect_definition_id' => test_defect.defect_definition.id,
                          'element_definition_id' => test_element.element_definition.id}])
    end

  end
end

