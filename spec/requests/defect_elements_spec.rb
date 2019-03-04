require 'rails_helper'

RSpec.describe Api::V1::DefectDefinitionsController, type: :request do
  let!(:test_user) { create(:normal_user) }
  let!(:test_defect_def) { create(:defect_definition) }

  let(:valid_headers) { {"X-User-Email" => test_user.email, "X-User-Token" => test_user.authentication_token} }

  describe 'GET /api/v1/defect_definitions' do

    before { 
      get "/api/v1/defect_definitions.json", headers: valid_headers 
    }

    it 'returns defect definitions data' do
      expect(response).to render_template(:index)
      expect(json).not_to be_empty
      expect(json['status']).to eq('success')
      # test output
      expect(json['data']['defect_definitions'].size).to eq(1)
      expect(json['data']['defect_definitions'][0]["id"]).to eq(test_defect_def.id)
    end

  end
end

