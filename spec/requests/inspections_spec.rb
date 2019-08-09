require 'rails_helper'

RSpec.describe Api::V1::InspectionsController, type: :request do
  let!(:test_user) { create(:normal_user) }
  let!(:test_condition_type) { create(:channel_condition_type) }
  let(:test_association_class) { "ChannelConditionType" }
  let!(:test_bridge) { create(:bridge) }
  let!(:test_culvert) { create(:culvert) }
  let!(:test_inspection) { create(:bridge_condition, highway_structure: test_bridge.highway_structure, state: 'assigned', assigned_organization_id: test_user.organization_id) }
  let!(:test_culvert_inspection) { create(:culvert_condition, highway_structure: test_culvert.highway_structure, state: 'assigned', assigned_organization_id: test_user.organization_id) }
  let!(:test_roadway) { create(:roadway, highway_structure: test_bridge.highway_structure) }
  let!(:test_element) { create(:element, inspection: test_inspection.inspection) }
  let!(:test_defect) { create(:defect, inspection: test_inspection.inspection, element: test_element) }

  let(:valid_headers) { {"X-User-Email" => test_user.email, "X-User-Token" => test_user.authentication_token} }

  describe 'GET /api/v1/inspections' do

    before {
      test_user.organizations = [test_user.organization]
      test_user.viewable_organizations = [test_user.organization]
      test_user.save
      get "/api/v1/inspections.json", headers: valid_headers 
    }

    it 'returns data' do
      expect(response).to render_template(:index)
      expect(json).not_to be_empty
      expect(json['status']).to eq('success')
      expect(json['data'].keys).to match_array(['inspections', 'elements', 'defects', 'structures', 'roadways', 'bridge_conditions', 'culvert_conditions', 'images', 'documents', 'users', 'streambed_profiles', 'streambed_profile_points', 'roadbeds', 'roadbed_lines'])
    end

    it 'includes structures data' do 
      expect(json['data']['structures']).not_to be_empty
      expect(json['data']['structures']['bridges'].size).to eq(1)
      expect(json['data']['structures']['bridges'][0]["id"]).to eq(test_bridge.guid)
    end

    it 'includes inspections data' do 
      expect(json['data']['inspections'].size).to eq(2)
      expect(json['data']['inspections'][0]["id"]).to eq(test_inspection.guid)
      expect(json['data']['inspections'][1]["id"]).to eq(test_culvert_inspection.guid)
    end

    it 'includes bridge_conditions data' do
      expect(json['data']['bridge_conditions'].size).to eq(1)
      expect(json['data']['bridge_conditions'][0]["id"]).to eq(test_inspection.guid)
    end

    it 'includes culvert_conditions data' do
      expect(json['data']['culvert_conditions'].size).to eq(1)
      expect(json['data']['culvert_conditions'][0]["id"]).to eq(test_culvert_inspection.guid)
    end

    it 'includes roadways data' do 
      expect(json['data']['roadways'].size).to eq(1)
      expect(json['data']['roadways'][0]["id"]).to eq(test_roadway.guid)
    end

  end
end

