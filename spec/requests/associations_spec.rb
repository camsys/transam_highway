require 'rails_helper'

RSpec.describe Api::V1::AssociationsController, type: :request do
  let(:test_user) { create(:normal_user) }
  let(:test_condition_type) { create(:channel_condition_type) }
  let(:test_association_class) { "ChannelConditionType" }

  let(:valid_headers) { {"X-User-Email" => test_user.email, "X-User-Token" => test_user.authentication_token} }

  describe 'GET /api/v1/associations' do

    before { get "/api/v1/associations.json?class=#{test_association_class}", headers: valid_headers }

    context 'when the association class exists' do
      it 'returns association data' do
        expect(response).to render_template(:index)
        expect(json).not_to be_empty
        expect(json['status']).to eq('success')

        # test output
        expect(json['data']['associations'].size).to eq(1)
        expect(json['data']['associations'][0]["id"]).to eq(test_condition_type.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the association class does not exist' do
      let(:test_association_class) { 'INVALID_CLASS' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['status']).to eq('fail')
        expect(json['data']['class']).to match(/not found/)
      end
    end

    context 'when the association class is not allowed' do
      let(:test_association_class) { 'Asset' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['status']).to eq('fail')
        expect(json['data']['class']).to match(/not allowed/)
      end
    end
  end
end

