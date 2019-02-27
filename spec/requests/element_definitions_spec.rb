require 'rails_helper'

RSpec.describe Api::V1::ElementDefinitionsController, type: :request do
  let!(:test_user) { create(:normal_user) }
  let!(:test_element_def) { create(:element_definition) }

  let(:valid_headers) { {"X-User-Email" => test_user.email, "X-User-Token" => test_user.authentication_token} }

  describe 'GET /api/v1/element_definitions' do

    before { 
      get "/api/v1/element_definitions.json", headers: valid_headers 
    }

    it 'returns element definitions data' do
      expect(response).to render_template(:index)
      expect(json).not_to be_empty
      expect(json['status']).to eq('success')
      # test output
      expect(json['data']['element_definitions'].size).to eq(1)
      expect(json['data']['element_definitions'][0]["id"]).to eq(test_element_def.id)
    end

  end
end

